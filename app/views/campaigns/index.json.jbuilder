json.array!(@campaigns) do |campaign|
  json.extract! campaign, :id, :title, :description, :campaign_type_id
  json.url campaign_url(campaign, format: :json)
end
