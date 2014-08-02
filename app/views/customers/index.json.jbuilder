json.array!(@customers) do |customer|
  json.extract! customer, :id, :organization_id, :name, :phone, :city, :custom1, :custom2, :custom3
  json.url customer_url(customer, format: :json)
end
