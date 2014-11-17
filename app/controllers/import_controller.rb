class ImportController < ApplicationController
  
  skip_before_action :verify_authenticity_token
  before_action :set_phones, only: [:create]

  # GET /import/1
  def index
    if !flash[:campaign_id].nil?
      flash[:campaign_id] = flash[:campaign_id]
      flash[:message_text] = flash[:message_text]
    end
  end

  # POST
  def create
    if !flash[:campaign_id].nil?
      file = params[:file]
      @status = Array.new
      @status = process_csv(file, params[:campaign_id], @status)

      if @status.length == 0
        @status.push("Imported successfully!")
      end

      flash[:notice] = @status

      flash[:campaign_id] = params[:campaign_id]
      flash[:message_text] = flash[:message_text]
      redirect_to :controller => 'customers', :action => 'index'

    end
  end

  def process_csv(file, campaign_id, status)
      begin
        CSV.foreach(file.path, headers: true) do |row|
          single_customer_data = row.to_hash
          single_customer_data['campaign_id'] = campaign_id
          single_customer_data['phone'] = Generic.clean_phone(single_customer_data['phone'])
          single_customer_data['phone'] = Generic.transform_phone(single_customer_data['phone'])
          puts single_customer_data

          if !duplicate(single_customer_data) # Check if number wasn't already imported
            begin
              Customer.create!(single_customer_data)
            rescue => err
              status.push(err.message + " - " + single_customer_data['phone'])       
            end
          else
            status.push("Duplicate customer record was detected and will be ignored - " + single_customer_data['phone'])
          end
        end
      rescue => err
         status.push(err.message)       
      end
    return status
  end

  def duplicate(single_customer_data)
    phone = single_customer_data['phone']

    dup = false
    @phones.each do |p|
      if p == phone
        dup = true
        break
      end
    end

    return dup
  end

  private
    # initiate @phones globally on import to check for duplicates
    def set_phones
      @phones = Customer.where(campaign_id: flash[:campaign_id]).pluck(:phone)
    end

end
