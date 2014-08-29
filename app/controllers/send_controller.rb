class SendController < ApplicationController

  # Twilio credentials
  TEST_PHONE_NUMBER = '+15005550006'
  TEST_ACCOUNT_SID = 'AC10b8f9e4aa87f004fab239a25ce7d2e3'
  TEST_AUTH_TOKEN = 'a74b2ba349cf560ce80f780e473a1281'

  PROD_PHONE_NUMBER = '+16469821367'
  PROD_ACCOUNT_SID = 'ACb6cb809937dc461855486ad0790988ed'
  PROD_AUTH_TOKEN = 'ec2179c879978ff07e15e7a0cce5f8fc'

  def show
    @campaign_id = params[:id]

    if !@campaign_id.nil?

      # Update campaign status to "Running"
      update_campaign_status(@campaign_id, "Running")

      # TODO: Send all the SMMs to queue, a worker will pull from queue and process it.
      @messages = Message.where(campaign_id: @campaign_id)
      @campaign_customers = Customer.where(campaign_id: @campaign_id)

      @progress = send_smm(@messages, @campaign_customers, params[:test])

      # Update campaign status to "Finished"
      update_campaign_status(@campaign_id, "Finished")

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
    @progress = Array.new

    @messages.each do |message|
      @campaign_customers.each do |customer|
        msg = dispatch_smm(customer.phone, message.text, test)
        @progress.push(msg)
      end
    end

    return @progress
  end

  # Dispatch SMS using 3rd party provider.
  def dispatch_smm(to_phone_number, message_text, test)

    # put your own credentials here
    if test == 'true'
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

      @client.account.messages.create({
                                          :from => from_phone_number,
                                          :to => to_phone_number,
                                          :body => message_text,
                                      })
      return "Successfully sent message To " + to_phone_number + "."
    rescue Exception => msg
      return msg
    end
  end
end
