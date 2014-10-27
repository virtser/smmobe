require 'net/http'

class SendController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Tropo credentials
  PROD_PHONE_NUMBER = '+14075550100'
  PROD_API_KEY = '0280354cc1ca294b841f21ca2f21788086708edc5c3f56c9bc539c7399c4878e6a31134b855a8bc6618ce971'

  # GET /send/1
  def show
     @message_logs = MessageSend.all.where(campaign_id: params[:id])
  end

  # POST /send
  def index
    campaign_id = params[:campaign_id]
    test = params[:test].to_s.to_bool

    if !campaign_id.nil?

      # Update campaign status to "Running"
      unless test
        update_campaign_status(campaign_id, "Running")
      end

      # TODO: Send all the SMMs to queue, a worker will pull from queue and process it. 
      @messages = Message.where(campaign_id: campaign_id)
      @campaign_customers = Customer.where(campaign_id: campaign_id)

      @progress = send_smm(@messages, @campaign_customers, test)

      # Update campaign status to "Finished"
      unless test
        update_campaign_status(campaign_id, "Finished")
      end

    end
  end

  def update_campaign_status(campaign_id, campaign_status)
    campaign = Campaign.find(campaign_id)

    if campaign.campaign_status == CampaignStatus.find_by_name("Pending")
      campaign.campaign_status = CampaignStatus.find_by_name(campaign_status)
    elsif campaign.campaign_status == CampaignStatus.find_by_name("Running")
      campaign.campaign_status = CampaignStatus.find_by_name(campaign_status)
    end

    campaign.save
  end

  def send_smm(messages, campaign_customers, test)
    progress = Array.new

    messages.each do |message|
      campaign_customers.each do |customer|
        message_text = replace_params(message, customer)
        to_phone = clean_phone(customer.phone)
        status_msg = dispatch_smm(to_phone, message_text, test)
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
  def dispatch_smm(to_phone_number, message_text, test)

    # put your own credentials here
    # if test
    #   from_phone_number = TEST_PHONE_NUMBER
    #   account_sid = TEST_ACCOUNT_SID
    #   auth_token = TEST_AUTH_TOKEN
    # else
      from_phone_number = PROD_PHONE_NUMBER
      api_key = PROD_API_KEY
     # api_secret = PROD_API_SECRET
    # end

    begin
      # set up a client to talk to the Nexmo REST API
      #nexmo = Nexmo::Client.new(key: api_key, secret: api_secret)

      result = Net::HTTP.get(URI.parse('https://api.tropo.com/1.0/sessions?action=create&token=' + api_key +
                                           '&numbertodial=' + to_phone_number + '&msg=' + message_text))
      parsed = JSON.parse(result)
      messageId = parsed[:session][:id]

      # TODO: add status callback to get message delivery status and errors

      # if !test
        save_sent_message_log(messageId, from_phone_number, to_phone_number, message_text, "queued")
      # end

      return "Successfully sent message To " + to_phone_number + '. ' + result

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
        campaign_id: params[:campaign_id]
     )
     @sent_message_log.save
  end
end
