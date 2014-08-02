json.array!(@templates) do |template|
  json.extract! template, :id, :name, :text, :image, :url
  json.url template_url(template, format: :json)
end
