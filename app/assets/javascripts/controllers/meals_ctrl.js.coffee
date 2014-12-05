angular.module('caloriesApp').controller 'MealsCtrl', ['$scope', '$http', 'alerts', '$window', ($scope, $http, alerts, $window) ->
  $scope.meals = []
  $scope.mealFilter = {}

  fetchMeals = ->
    filterData = $scope.mealFilter

    $http.get('/api/meals')
      .success (data) ->
        $scope.meals = data
      .error ->
        alerts.addAlert('danger', 'Failed to load meals.')

  $scope.filterMeals = (filter) ->
    fetchMeals()

  $scope.deleteMeal = (meal) ->
    return unless $window.confirm("Are you sure you want to delete this meal?")
    $http.delete("/api/meals/#{meal.id}")
      .success ->
        $scope.meals.splice $scope.meals.indexOf(meal), 1
      .error ->
        alerts.addAlert('danger', 'Failed to delete the meal.')

  fetchMeals()
]