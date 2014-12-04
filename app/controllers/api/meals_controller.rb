module Api
  class MealsController < ApplicationController
    before_filter :authenticate_user!

    def index
      @meals = current_user.meals.order(eaten_at: :desc)
    end

    def create
      @meal = current_user.meals.create! meal_params
      render status: :created
    end

    private

      def meal_params
        params.require(:meal).permit(:eaten_at, :description, :calories)
      end

  end
end