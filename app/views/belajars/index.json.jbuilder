json.array!(@belajars) do |belajar|
  json.extract! belajar, :id, :nama, :ruang
  json.url belajar_url(belajar, format: :json)
end
