json.array!(@criteria) do |criterium|
  json.extract! criterium, :id, :name
  json.url criterium_url(criterium, format: :json)
end
