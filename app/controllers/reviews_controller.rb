class ReviewsController < ApplicationController
  before_action :signed_in_user, only: [:show, :index]

  # GET /review/1
  # GET /review/1.json
  def show
    @campaigns = Campaign.where(id: params[:id])

    if @campaigns.count > 0
      @messages = Message.where(campaign_id: params[:id]).limit(1)
      @customers = Customer.where(campaign_id: params[:id]).order!(:first_name, :last_name)

      if @messages.count > 0
        cookies[:message_text] = @messages[0].text
      end
    end

    @customer = Customer.new
    @customer.campaign_id = params[:id]
  end

  def index
  end
end
