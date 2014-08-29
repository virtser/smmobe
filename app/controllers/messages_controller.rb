class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

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

    # In case that passed campaign_id param from campaigns controller in flash var
    if !flash[:campaign_id].nil?
      @message.campaign_id = flash[:campaign_id]
    end
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
        format.html {
          flash[:campaign_id] = @message.campaign_id
          redirect_to :controller => 'customers', :action => 'index'
        }
        format.json { render :show, status: :created, location: @message }
      else
        format.html {
          render :new
          #redirect_to new_message_path(@message, campaign_id: params[:campaign_id])
          #redirect_to() :controller => 'messages', :action => 'new', :campaign_id => @campaign.id
          #redirect_to action: "new", text: @message.text, campaign_id: params[:message][:campaign_id], error: @message.errors[:text][0].to_s
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
        format.html {
          #redirect_to @message, notice: 'Message was successfully updated.'
          #flash[:campaign_id] = @customer.campaign_id
          #@customer.campaign_id = flash[:campaign_id]
          #customer = Message.find_by_campaign_id(@campaign.id)
          flash[:campaign_id] = @message.campaign_id
          redirect_to :controller => 'customers', :action => 'index'
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
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:text, :campaign_id)
    end
end
