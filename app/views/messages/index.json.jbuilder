json.array!(@messages) do |message|
  json.extract! message, :id, :text, :messagetype_id, :campaign_id
  json.url message_url(message, format: :json)
end
