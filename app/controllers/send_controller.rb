class SendController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Twilio credentials
  TEST_PHONE_NUMBER = '+15005550006'
  TEST_ACCOUNT_SID = 'AC10b8f9e4aa87f004fab239a25ce7d2e3'
  TEST_AUTH_TOKEN = 'a74b2ba349cf560ce80f780e473a1281'

  PROD_PHONE_NUMBER = '+16469821367'
  PROD_ACCOUNT_SID = 'ACb6cb809937dc461855486ad0790988ed'
  PROD_AUTH_TOKEN = 'ec2179c879978ff07e15e7a0cce5f8fc'

  # POST /send
  def index
    campaign_id = params[:campaign_id]
    test = params[:test].to_s.to_bool

    if !campaign_id.nil?

      # Update campaign status to "Running"
      unless test
        update_campaign_status(campaign_id, "Running")
      end

      # TODO: Send all the SMMs to queue, a worker will pull from queue and process it. - Twilio has queues support - https://www.twilio.com/docs/api/rest
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
        status_msg = dispatch_smm(customer.phone, message_text, test)
        progress.push(status_msg)
      end
    end

    return progress
  end

  def replace_params(message, customer)
    transformed_message = message.text
    transformed_message = transformed_message.gsub('#first_name', customer.first_name)
    transformed_message = transformed_message.gsub('#last_name', customer.last_name)
    transformed_message = transformed_message.gsub('#phone', customer.phone)
    transformed_message = transformed_message.gsub('#custom1', customer.custom1)
    transformed_message = transformed_message.gsub('#custom2', customer.custom2)
    transformed_message = transformed_message.gsub('#custom3', customer.custom3)
    return transformed_message
  end

  # Dispatch SMS using 3rd party provider.
  def dispatch_smm(to_phone_number, message_text, test)

    # put your own credentials here
    if test
      from_phone_number = TEST_PHONE_NUMBER
      account_sid = TEST_ACCOUNT_SID
      auth_token = TEST_AUTH_TOKEN
    else
      from_phone_number = PROD_PHONE_NUMBER
      account_sid = PROD_ACCOUNT_SID
      auth_token = PROD_AUTH_TOKEN
    end

    begin
      # set up a client to talk to the Twilio REST API
      @client = Twilio::REST::Client.new account_sid, auth_token

      # TODO: add status callback to get message delivery status and errors  - https://www.twilio.com/docs/api/rest/sending-messages#post-parameters-required
      @message_details = @client.account.messages.create({
                                          :from => from_phone_number,
                                          :to => to_phone_number,
                                          :body => message_text,
                                      })
      if !test
        save_sent_message_log(@message_details)
      end 
      
      return "Successfully sent message To " + to_phone_number + "."
    rescue Exception => error_msg
      return error_msg
    end
  end

  def save_sent_message_log(message)
     @sent_message_log = MessageSend.new(
                                          sid: message.sid,
                                          date: DateTime.now,
                                          from_phone: message.from,
                                          to_phone: message.to,
                                          body: message.body,
                                          status: message.status
                                        )
     @sent_message_log.save
  end
end
