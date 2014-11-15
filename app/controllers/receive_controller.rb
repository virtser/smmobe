class ReceiveController < ApplicationController
  skip_before_action :verify_authenticity_token


  # GET /receive/1
  def show
     @message_logs = MessageReceive.all.where(user_id: current_user[:id], campaign_id: params[:id]).order!(created_at: :desc)
  end

  # GET /receive
  def index
    if(params[:messageId].present?)
      message_sid = params[:messageId]
      from_phone_number = params[:msisdn]
      to_phone_number = params[:to]
      body = params[:text]
      body = params[:text]
      status = params[:type]
      user_id = User.where(phone: to_phone_number).limit(1).pluck(:id)[0]

      # possible campaign IDs to assign the message to
      campaign_id = Campaign.where("isdisabled = false AND user_id = (?) AND campaign_status_id = 2 AND campaigns.updated_at + interval '?' day  > now()", user_id, Generic.get_campaign_run_interval)
                             .joins("JOIN customers ON campaigns.id = customers.campaign_id AND customers.phone = '" + from_phone_number + "'")
                             .limit(1).pluck("campaigns.id")[0]

      save_received_message_log(message_sid, from_phone_number, to_phone_number, body, status, campaign_id, user_id)

      # TODO: reply if body contains defined variable to reply.
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
end
