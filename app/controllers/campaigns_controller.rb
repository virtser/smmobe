class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]

  # GET /campaigns
  # GET /campaigns.json
  def index
    flash[:message_text] = nil
    @campaigns = Campaign.where(user_id: current_user[:id]).order!('campaign_status_id', created_at: :desc)
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = Campaign.new(campaign_params)
    @campaign.user_id = current_user[:id]

    respond_to do |format|
      if @campaign.save
        format.html {
          flash[:campaign_id] = @campaign.id
          redirect_to :controller => 'messages', :action => 'new'
        }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html {
          flash[:campaign_id] = @campaign.id
          @message_id = Message.find_by_campaign_id(@campaign.id)
          
          # in case that customer didn't complete campaign creation flow and have no message
          if @message_id.nil? 
            redirect_to :controller => 'messages', :action => 'new'
          else
            redirect_to :controller => 'messages', :action => 'edit', :id => @message_id
          end
        }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @messages = Message.where(campaign_id: @campaign.id)
    @messages.each do |m|
      m.destroy
    end

    @customers = Customer.where(campaign_id: @campaign.id)
    @customers.each do |c|
      c.destroy
    end

    @campaign.destroy
    respond_to do |format|
      format.html {
        redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.'
      }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
      @campaign.user_id = current_user[:id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:title, :description, :campaign_type_id)
    end
end
