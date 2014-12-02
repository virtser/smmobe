class CampaignsController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :edit, :create, :update, :destroy]
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]


  # GET /campaigns
  # GET /campaigns.json
  def index
    cookies[:message_text] = nil
    @campaigns = Campaign.where(isdisabled: false).order!('campaign_status_id', created_at: :desc)
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  end

  # GET /campaigns/new
  def new
    cookies[:message_text] = nil
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
        puts "New campaign created: #{@campaign.inspect}"       

        if Rails.env.production?
            tracker = Mixpanel::Tracker.new(Generic.get_mixpanel_key)
            tracker.track(@campaign.user_id, 'Campaign Created')
        end    

        format.html {
          redirect_to new_campaign_message_path(@campaign)
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
        puts "Campaign updateded: #{@campaign.inspect}"        

        format.html {
          @message = Message.find_by_campaign_id(@campaign.id)

          # in case that customer didn't complete campaign creation flow and have no message
          if @message.nil? 
            redirect_to new_campaign_message_path(@campaign)
          else
            redirect_to edit_campaign_message_path(@campaign, @message)
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
    # @messages = Message.where(campaign_id: @campaign.id)
    # @messages.each do |m|
    #   m.destroy
    # end

    # @customers = Customer.where(campaign_id: @campaign.id)
    # @customers.each do |c|
    #   c.destroy
    # end
    puts "Campaign deleted: #{@campaign.inspect}"        

    @campaign.isdisabled = true
    @campaign.save

    #@campaign.destroy
    respond_to do |format|
      format.html {
        redirect_to campaigns_url
      }
      format.json { head :no_content }
    end
  end

  # DELETE /campaigns/finish/1
  def finish
    puts "HOPA!!!!!!!"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      unless current_user.nil?
        @campaign = Campaign.find(params[:id])
        @campaign.user_id = current_user[:id]
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:title, :description, :campaign_type_id)
    end
end
