angular.module('caloriesApp').controller 'MealsCtrl', ['$scope', '$http', 'alerts', '$window', ($scope, $http, alerts, $window) ->
  $scope.meals = []
  $scope.caloriesDaily = []
  $scope.mealFilter =
    date_from: null
    date_to: null
    time_from: null
    time_to: null

  fetchMeals = ->
    $scope.mealFilter[key] = $scope.mealFilter[key] || null for key of $scope.mealFilter
    $http.get('/api/meals', params: $scope.mealFilter)
      .success (data) ->
        $scope.meals = data
      .error ->
        alerts.addAlert('danger', 'Failed to load meals.')

  fetchCaloriesDaily = ->
    $http.get('/api/calories_daily')
      .success (data) ->
        console.log data
        $scope.caloriesDaily = data
      .error ->
        alerts.addAlert('danger', 'Failed to calories daily.')        

  $scope.filterMeals = (filter) ->
    return unless $scope.formFilter.$valid
    fetchMeals()

  $scope.deleteMeal = (meal) ->
    return unless $window.confirm("Are you sure you want to delete this meal?")
    $http.delete("/api/meals/#{meal.id}")
      .success ->
        $scope.meals.splice $scope.meals.indexOf(meal), 1
      .error ->
        alerts.addAlert('danger', 'Failed to delete the meal.')

  fetchMeals()
  fetchCaloriesDaily()
]