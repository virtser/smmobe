class SendController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Nexmo credentials
  PROD_API_KEY = 'b5c09331'
  PROD_API_SECRET = '4cd27bd4'

  # GET /send/1
  def show
     @message_logs = MessageSend.all.where(user_id: current_user[:id], campaign_id: params[:id]).order!(created_at: :desc)
  end

  # POST /send
  def index
    campaign_id = params[:campaign_id]
    test = params[:test].to_s.to_bool

    if !campaign_id.nil?

      @campaign_customers = Customer.where(campaign_id: campaign_id)
      @messages = Message.where(campaign_id: campaign_id)

      # don't allow sending if zero customers where added
      if @campaign_customers.length == 0 
        @progress = Array.new
        @progress.push("Hey, you forgot to add some customers phone numbers to send this campaign! Edit the message and some numbers.")        
        return 
      end

      # Don't allow sending campaign if another one is running with the same phone number, unless current user is Admin
      unless have_same_number(campaign_id, @campaign_customers)

        @from_phone_number = User.where(id: current_user[:id]).limit(1).pluck(:phone)[0]

        @progress = send_smm(@messages, @campaign_customers, @from_phone_number, test)

        # Update campaign status to "Running"
        unless test
          update_campaign_status(campaign_id, 2)
        end

      else
        @progress = Array.new
        @progress.push("Sending was aborted because this campaign include phone number which is already exists in another running campaign. ")
        @progress.push("Please wait until the other campaing is finished.")
      end
    end
  end

  def have_same_number(campaign_id, campaign_customers)

    # get all running campaigns, excluding current one
    all_running_campaigns = Campaign.where("isdisabled = false AND campaign_status_id = 2 AND id != (?)", campaign_id).pluck(:id)

    if all_running_campaigns.length == 0
      return false
    else
      all_running_campaigns_customers = Customer.where("campaign_id IN (?)", all_running_campaigns)

      all_running_campaigns_customers.each do |all_running_customer|
        campaign_customers.each do |current_customer|
          if current_customer.phone == all_running_customer.phone
            return true
          end
        end 
      end
    end

    return false

  end

  def update_campaign_status(campaign_id, campaign_status)
    campaign = Campaign.find(campaign_id)
    campaign.campaign_status_id = campaign_status
    campaign.save
  end

  def send_smm(messages, campaign_customers, from_phone_number, test)
    progress = Array.new

    # TODO: Send all the SMMs to queue, a worker will pull from queue and process it. 

    messages.each do |message|
      campaign_customers.each do |customer|
        message_text = replace_params(message, customer)
        status_msg = dispatch_smm(from_phone_number, customer.phone, message_text, test)
        progress.push(status_msg)
      end
    end

    return progress
  end

  def replace_params(message, customer)
    transformed_message = message.text
    transformed_message = transformed_message.gsub('#first_name', customer.first_name)
    transformed_message = transformed_message.gsub('#last_name', customer.last_name)
    #transformed_message = transformed_message.gsub('#phone', customer.phone)
    transformed_message = transformed_message.gsub('#custom1', customer.custom1)
    transformed_message = transformed_message.gsub('#custom2', customer.custom2)
    transformed_message = transformed_message.gsub('#custom3', customer.custom3)
    return transformed_message
  end

  # Dispatch SMS using 3rd party provider.
  def dispatch_smm(from_phone_number, to_phone_number, message_text, test)

    begin
      # set up a client to talk to the Nexmo REST API
      nexmo = Nexmo::Client.new(key: PROD_API_KEY, secret: PROD_API_SECRET)


      # TODO: add status callback to get message delivery status and errors
      unless test
        messageId = nexmo.send_message(
                                              from: from_phone_number,
                                              to: to_phone_number,
                                              text: message_text,
                                              type: message_text.multibyte? ? 'unicode' : 'text',
                                              :'client-ref' => params[:campaign_id]

        )

        save_sent_message_log(messageId, from_phone_number, to_phone_number, message_text, "queued")
      end

      return "Successfully sent message To " + to_phone_number + "."

    rescue => err
      return err.message
    end
  end

  def save_sent_message_log(message_sid, from_phone, to_phone, body, status)
     @sent_message_log = MessageSend.new(
        sid: message_sid,
        date: DateTime.now,
        from_phone: from_phone,
        to_phone: to_phone,
        body: body,
        status: status,
        campaign_id: params[:campaign_id],
        user_id: current_user[:id]
     )
     @sent_message_log.save
  end
end
