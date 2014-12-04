module Api
  class MealsController < ApplicationController
    before_filter :authenticate_user!

    def index
      @meals = current_user.meals.order(eaten_at: :desc)
    end

  end
end