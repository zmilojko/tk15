json.array!(@competitions) do |competition|
  json.extract! competition, :id, :code, :name, :type
  json.url competition_url(competition, format: :json)
end
