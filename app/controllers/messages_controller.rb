class MessagesController < ApplicationController
  before_action :signed_in_user, only: [:index, :show, :edit, :create, :update, :destroy]
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :set_campaign, only: [:new, :edit, :create, :update]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
    @message.campaign_id = params[:campaign_id]
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        puts "New message created: #{@message.inspect}"        

        format.html {
          cookies[:message_text] = @message.text
          redirect_to campaign_customers_path
        }
        format.json { render :show, status: :created, location: @message }
      else
        format.html {
          render :new
        }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        puts "Message updated: #{@message.inspect}"        

        format.html {
          cookies[:message_text] = @message.text
          redirect_to campaign_customers_path
        }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      unless current_user.nil?
        @message = Message.find(params[:id])
      end
    end

    def set_campaign
      unless current_user.nil?
        @campaign = Campaign.find(params[:campaign_id])
        @campaign.user_id = current_user[:id]        
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:text, :campaign_id)
    end
end
