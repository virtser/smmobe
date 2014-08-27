class ReviewsController < ApplicationController

  # GET /review/1
  # GET /review/1.json
  def show
    @campaigns = Campaign.where(user_id: current_user[:id], id: params[:id])

    if @campaigns.count > 0
      @messages = Message.where(campaign_id: params[:id])
      @campaign_customers = Customer.where(campaign_id: params[:id])
    end

    @customer = Customer.new
    @customer.campaign_id = params[:id]
  end

  def index
  end
end
