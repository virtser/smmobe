json.array!(@campaigns) do |campaign|
  json.extract! campaign, :id, :title, :description, :template_id, :organization_id
  json.url campaign_url(campaign, format: :json)
end
