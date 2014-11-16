class CustomersController < ApplicationController

  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customer = Customer.new

    flash[:campaign_id] = flash[:campaign_id]
    flash[:message_text] = flash[:message_text]

    if !flash[:campaign_id].nil?
      @customer.campaign_id = flash[:campaign_id]
      @customers = Customer.where(campaign_id: flash[:campaign_id]).order!(:first_name, :last_name)
    else
      @customers = Customer.where(campaign_id: 0)
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new

    # In case that passed campaign_id param from messages controller in flash var
    if !flash[:campaign_id].nil?
      @customer.campaign_id = flash[:campaign_id]
      flash[:campaign_id] = flash[:campaign_id]
      flash[:message_text] = flash[:message_text]
    end

    # find all customers associated with this campaign id
    if !@customer.campaign_id.nil?
      @campaign = Campaign.find(@customer.campaign_id)
      @campaign_customers =  @campaign.customers.order(:first_name, :last_name)
    end

  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)
    @customer.phone = Generic.clean_phone(@customer.phone)
    @customer.phone = Generic.transform_phone(@customer.phone)
    
    respond_to do |format|
      if @customer.save
        format.html  {
          flash[:campaign_id] = @customer.campaign_id
          flash[:message_text] = flash[:message_text]
          redirect_to :controller => 'customers', :action => 'index'
        }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html  {
          flash[:campaign_id] = @customer.campaign_id
          flash[:message_text] = flash[:message_text]
          redirect_to :controller => 'customers', :action => 'index'
          #redirect_to :controller => 'reviews', :action => 'show', :id => @customer.campaign_id
        }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html  {
        flash[:campaign_id] = @customer.campaign_id
        flash[:message_text] = flash[:message_text]
        redirect_to :controller => 'customers', :action => 'index'
        #redirect_to :controller => 'reviews', :action => 'show', :id => @customer.campaign_id
      }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_customer
    @customer = Customer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def customer_params
    params.require(:customer).permit(:phone, :first_name, :last_name, :campaign_id, :custom1, :custom2, :custom3)
  end
end
