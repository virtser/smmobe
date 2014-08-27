class SendController < ApplicationController
  def show
    @campaign_id = params[:id]

    # TODO: send all the SMMs to worker for processing.

    # Update campaign status to "Running"
    campaign = Campaign.find(@campaign_id)

    if campaign.campaign_status == CampaignStatus.find_by_name("Pending")
      campaign.campaign_status = CampaignStatus.find_by_name("Running")
      campaign.save
    end
  end

end
