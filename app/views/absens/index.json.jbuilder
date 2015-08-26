json.array!(@absens) do |absen|
  json.extract! absen, :id, :nama, :alamat, :nim
  json.url absen_url(absen, format: :json)
end
