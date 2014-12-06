class CaloriesDailyQuery
  def initialize(user, date_from_s, date_to_s, time_from_s, time_to_s)
    @scope = MealsQuery.new(date_from_s, date_to_s, time_from_s, time_to_s, user).query
  end

  def query
    @scope.select("date_trunc('day', meals.eaten_at) as eaten_at_date, sum(meals.calories) as daily_calories").group('eaten_at_date').order('eaten_at_date desc')
  end
end