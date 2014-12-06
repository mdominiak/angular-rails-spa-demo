class CaloriesDailyQuery
  def initialize(user)
    @scope = MealsQuery.new(nil, nil, nil, nil, user).query
  end

  def query
    @scope.select("date_trunc('day', meals.eaten_at) as eaten_at_date, sum(meals.calories) as daily_calories").group('eaten_at_date').order('eaten_at_date desc')
  end
end