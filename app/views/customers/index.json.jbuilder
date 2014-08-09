json.array!(@customers) do |customer|
  json.extract! customer, :id, :phone, :name, :campaign_id
  json.url customer_url(customer, format: :json)
end
