class MealsQuery

  def initialize(date_from_s, date_to_s, time_from_s, time_to_s, user)
    @date_from = date_from_s.to_date rescue nil
    @date_to = date_to_s.to_date rescue nil
    @time_from = /^\d+:\d{2}$/ === time_from_s ? time_from_s : nil
    @time_to = /^\d+:\d{2}$/ === time_to_s ? time_to_s : nil
    @user = user
  end

  def query
    scope = @user.meals
    scope = scope.where("meals.eaten_at::date >= ?", @date_from) if @date_from
    scope = scope.where("meals.eaten_at::date <= ?", @date_to) if @date_to
    scope = scope.where("date_trunc('minute', meals.eaten_at::time) >= ?", @time_from) if @time_from
    scope = scope.where("date_trunc('minute', meals.eaten_at::time) <= ?", @time_to) if @time_to
    scope.order(eaten_at: :desc)
  end
end