json.array!(@unstructured_data) do |unstructured_datum|
  json.extract! unstructured_datum, :id, :name, :subcriterium_id
  json.url unstructured_datum_url(unstructured_datum, format: :json)
end
