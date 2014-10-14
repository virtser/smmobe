class ImportController < ApplicationController
  skip_before_action :verify_authenticity_token

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
      @status = process_csv(file, params[:campaign_id])

      # if @status.nil?
      #   flash[:notice] = "Imported successfully!"
      # else
      #   flash[:notice] = @status
      # end

      flash[:campaign_id] = params[:campaign_id]
      flash[:message_text] = flash[:message_text]
      redirect_to :controller => 'customers', :action => 'index'

    end
  end

  def process_csv(file, campaign_id)
    begin
      CSV.foreach(file.path, headers: true) do |row|
        single_customer_data = row.to_hash
        single_customer_data[:campaign_id] = campaign_id
        Customer.create!(single_customer_data)
      end
    rescue Exception => error_msg
      return error_msg
    end
  end

end
