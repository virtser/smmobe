json.array!(@phones) do |phone|
  json.extract! phone, :id, :phone, :campaign_id, :user_id
  json.url phone_url(phone, format: :json)
end
