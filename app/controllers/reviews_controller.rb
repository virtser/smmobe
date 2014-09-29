class ReviewsController < ApplicationController

  # GET /review/1
  # GET /review/1.json
  def show
    @campaigns = Campaign.where(user_id: current_user[:id], id: params[:id])

    if @campaigns.count > 0
      @messages = Message.where(campaign_id: params[:id])
      @customers = Customer.where(campaign_id: params[:id]).order!(:first_name, :last_name)
    end

    @customer = Customer.new
    @customer.campaign_id = params[:id]
    flash[:message_text] = flash[:message_text]
  end

  def index
  end
end
