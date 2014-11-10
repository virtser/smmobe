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

      # TODO: Send all the SMMs to queue, a worker will pull from queue and process it. 
      @messages = Message.where(campaign_id: campaign_id)
      @campaign_customers = Customer.where(campaign_id: campaign_id)
      @from_phone_number = User.where(id: current_user[:id]).limit(1).pluck(:phone)[0]

      @progress = send_smm(@messages, @campaign_customers, @from_phone_number, test)

      # Update campaign status to "Running"
      unless test
        update_campaign_status(campaign_id, @from_phone_number, "Running")
      end

    end
  end

  def update_campaign_status(campaign_id, from_phone_number, campaign_status)
    campaign = Campaign.find(campaign_id)

    campaign.sent_from_phone = from_phone_number

    if campaign.campaign_status == CampaignStatus.find_by_name("Pending")
      campaign.campaign_status = CampaignStatus.find_by_name(campaign_status)
    elsif campaign.campaign_status == CampaignStatus.find_by_name("Running")
      campaign.campaign_status = CampaignStatus.find_by_name(campaign_status)
    end

    campaign.save
  end

  def send_smm(messages, campaign_customers, from_phone_number, test)
    progress = Array.new

    messages.each do |message|
      campaign_customers.each do |customer|
        message_text = replace_params(message, customer)
        to_phone = clean_phone(customer.phone)
        status_msg = dispatch_smm(from_phone_number, to_phone, message_text, test)
        progress.push(status_msg)
      end
    end

    return progress
  end

  def clean_phone(phone_number)
    phone_number = phone_number.to_s.tr("+", "")
    phone_number = phone_number.to_s.tr("-", "")
    phone_number = phone_number.to_s.tr("(", "")
    phone_number = phone_number.to_s.tr(")", "")
    phone_number = phone_number.to_s.tr(" ", "")
    return phone_number
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

    rescue Exception => error_msg
      return error_msg
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
