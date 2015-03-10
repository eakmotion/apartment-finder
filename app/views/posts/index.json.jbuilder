json.array!(@posts) do |post|
  json.extract! post, :id, :heading, :body, :price, :neighborhood, :external_url, :timestamp, :sqft, :bedrooms, :bathrooms, :parking
  json.url post_url(post, format: :json)
end
