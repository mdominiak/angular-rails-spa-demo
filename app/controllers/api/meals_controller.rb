module Api
  class MealsController < ApplicationController
    before_filter :authenticate_user!

    def index
      @meals = current_user.meals
    end

  end
end