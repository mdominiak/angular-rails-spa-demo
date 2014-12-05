angular.module('caloriesApp').controller 'MealCtrl', ['$scope', '$http', 'alerts', '$filter', '$location', '$routeParams', ($scope, $http, alerts, $filter, $location, $routeParams) ->
  if $routeParams.mealId
    $scope.meal = {id: $routeParams.mealId}

    $http.get("/api/meals/" + $routeParams.mealId)
      .success (data) ->
        data.eaten_at = new Date(data.eaten_at)
        data.time = angular.copy(data.eaten_at)
        $scope.meal = data
      .error ->
        alerts.addAlert('danger', "Failed to load the meal.")
  else
    $scope.meal =
      eaten_at: new Date()
      time: new Date()

  $scope.saveMeal = (meal) ->
    return if $scope.formMeal.$invalid
    meal.eaten_at.setHours meal.time.getHours()
    meal.eaten_at.setMinutes meal.time.getMinutes()
    mealAttr = 
      calories: parseInt(meal.calories)
      description: meal.description
      eaten_at: meal.eaten_at.toJSON()
  
    saveMethod = if meal.id then $http.patch else $http.post
    saveMethod((if meal.id then "/api/meals/#{meal.id}" else "/api/meals/"), mealAttr)
      .success (data) ->
        $location.path('/dashboard')
      .error ->
        alerts.addAlert('danger', 'Failed to save meal.')
]
