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
        @status.push(["Imported successfully!", "alert-success"])
      end

      flash[:notice] = @status

      flash[:campaign_id] = params[:campaign_id]
      flash[:message_text] = flash[:message_text]
      redirect_to :controller => 'customers', :action => 'index'

    end
  end

  def process_csv(file, campaign_id, status)
      begin
          filename = file.original_filename.downcase

          if filename.include? ".csv"
            spreadsheet = Roo::CSV.new(file.path, csv_options: {encoding: Encoding::UTF_8})
          elsif filename.include? ".xlst"
            spreadsheet = Roo::Excelx.new(file.path, nil, :ignore)
          elsif filename.include? ".xls"
            spreadsheet = Roo::Excel.new(file.path, nil, :ignore)
          elsif filename.include? ".ods" # Open Office support
            spreadsheet = Roo::OpenOffice.new(file.path, nil, :ignore)
          end

          spreadsheet.default_sheet = spreadsheet.sheets.first             # first sheet in the spreadsheet file will be used
          header = spreadsheet.row(1)

          (2..spreadsheet.last_row).each do |i|   
            single_customer_data = Hash[[header, spreadsheet.row(i)].transpose]
            single_customer_data['campaign_id'] = campaign_id
            single_customer_data['phone'] = Generic.clean_phone(single_customer_data['phone'])
            single_customer_data['phone'] = Generic.transform_phone(single_customer_data['phone'])
            puts single_customer_data

          if !duplicate(single_customer_data) # Check if number wasn't already imported
            begin
              Customer.create!(single_customer_data)
            rescue => err
              if err.message.include? "unknown attribute"
                status.push(["Wrong column names detected. Make sure your file include at least 'phone' column in first row header.", "alert-error"])   
                break
              else
                status.push(["#{err.message}: #{single_customer_data['phone']}", "alert-error"])   
              end
            end
          else
            status.push(["Duplicate customer record was detected and filtered out: #{single_customer_data['phone']}", ""])   
          end
        end
      rescue => err
         status.push(["#{err.message}", "alert-error"])   
         puts "Import CSV file errors: #{err.message}"   
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

    # Adding valid phone to array to make sure no duplicate phone entries where submitted in CSV file
    @phones.push(Customer.new(phone: phone, campaign_id: flash[:campaign_id]).phone)
    return dup
  end

  private
    # initiate @phones globally on import to check for duplicates
    def set_phones
      @phones = Customer.where(campaign_id: flash[:campaign_id]).pluck(:phone)
    end

end
