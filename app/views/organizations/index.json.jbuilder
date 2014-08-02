json.array!(@organizations) do |organization|
  json.extract! organization, :id, :name, :phone, :address
  json.url organization_url(organization, format: :json)
end
