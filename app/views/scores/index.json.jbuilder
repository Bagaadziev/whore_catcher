json.array!(@scores) do |score|
  json.extract! score, :id
  json.url score_url(score, format: :json)
  json.whore_count score.whore_count
  json.total_time score.whore_count
end
