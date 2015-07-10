json.array!(@subcriteria) do |subcriterium|
  json.extract! subcriterium, :id, :name, :criteria_id
  json.url subcriterium_url(subcriterium, format: :json)
end
