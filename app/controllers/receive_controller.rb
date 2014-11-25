class ReceiveController < ApplicationController
  skip_before_action :verify_authenticity_token


  # GET /receive/1
  def show
     @message_logs = MessageReceive.all.where(user_id: current_user[:id], campaign_id: params[:id]).order!(created_at: :desc)
  end

  # GET /receive
  def index
    # write received request to log
    puts "New receive request: " + params.to_s

    if(params[:messageId].present?)
      begin
        message_sid = params[:messageId]
        from_phone_number = params[:msisdn]
        to_phone_number = params[:to]
        body = params[:text]
        status = params[:type]
        user_id = User.where(phone: to_phone_number).limit(1).pluck(:id)[0]

        if Rails.env.production?
            tracker = Mixpanel::Tracker.new(Generic.get_mixpanel_key)
            tracker.track(user_id, 'SMS Received')
        end    
        
        puts "New SMS received: " + params.to_s

        # possible campaign IDs to assign the message to
        campaign_id = Campaign.where("isdisabled = false AND user_id = (?) AND campaign_status_id = ?", user_id, Generic.CampaignStatusRunning)
                               .joins("JOIN customers ON campaigns.id = customers.campaign_id AND customers.phone = '" + from_phone_number + "'")
                               .limit(1).pluck("campaigns.id")[0]

        save_received_message_log(message_sid, from_phone_number, to_phone_number, body, status, campaign_id, user_id)

        # TODO: reply if body contains defined variable to reply.
        process_reply(message_sid, from_phone_number, to_phone_number, body, status, campaign_id, user_id)

      rescue => err
        puts "Receive SMS failed: #{err.message} - #{params.to_s}"
      end
    end

    render :nothing => true # this will supply the needed http 200 OK
  end

  def save_received_message_log(message_sid, from_phone, to_phone, body, status, campaign_id, user_id)
     @sent_message_log = MessageReceive.new(
        sid: message_sid,
        date: DateTime.now,
        from_phone: from_phone,
        to_phone: to_phone,
        body: body,
        status: status,
        campaign_id: campaign_id,
        user_id: user_id
     )
     @sent_message_log.save
  end

  def process_reply(message_sid, from_phone_number, to_phone_number, body, status, campaign_id, user_id)
      
      if body.include? "0"  # unsubscribe
        unsubscribe_customer(from_phone_number, user_id)        
      end 

  end

  def unsubscribe_customer(phone, user_id)
    @unsubscribe = Unsubscribe.new(phone: phone, user_id: user_id)
    @unsubscribe.save

    puts "Customer unsubscribed - #{phone}"
  end

end
