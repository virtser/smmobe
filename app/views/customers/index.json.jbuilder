json.array!(@customers) do |customer|
  json.extract! customer, :id, :phone, :first_name, :last_name, :campaign_id, :custom1, :custom2, :custom3
  json.url customer_url(customer, format: :json)
end
