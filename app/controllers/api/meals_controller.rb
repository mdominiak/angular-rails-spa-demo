module Api
  class MealsController < BaseController
    skip_before_filter :verify_authenticity_token
    before_filter :authenticate_user!
    before_filter :load_meal, only: [:destroy, :show, :update]

    # GET /api/meals
    def index
      @meals = MealsQuery.new(params[:date_from], params[:date_to], params[:time_from], params[:time_to], current_user).query
    end

    # POST /api/meals
    def create
      @meal = current_user.meals.create! meal_params
      render status: :created
    end

    # DELETE /api/meals/:id
    def destroy
      @meal.destroy
      head :no_content
    end

    # GET /api/meals/:id
    def show
    end

    # PATCH /api/meals/:id
    def update
      @meal.update! meal_params
    end

    private

      def meal_params
        params.require(:meal).permit(:eaten_at, :description, :calories)
      end

      def load_meal
        @meal = current_user.meals.find(params[:id])
      end

  end
end