json.array! @calories_daily do |day|
  json.date day.eaten_at_date.to_date
  json.calories day.daily_calories
end