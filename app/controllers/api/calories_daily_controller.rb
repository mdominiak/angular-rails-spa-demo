module Api
  class CaloriesDailyController < BaseController
    before_filter :authenticate_user!

    # GET /api/calories_daily
    def index
      @calories_daily = CaloriesDailyQuery.new(current_user).query
    end

  end
end