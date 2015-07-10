json.array!(@plants) do |plant|
  json.extract! plant, :id, :name, :profile
  json.url plant_url(plant, format: :json)
end
