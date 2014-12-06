angular.module('caloriesApp').controller 'MealCtrl', ['$scope', '$http', 'alerts', '$filter', '$location', '$routeParams', ($scope, $http, alerts, $filter, $location, $routeParams) ->
  if $routeParams.mealId
    $scope.meal = {id: $routeParams.mealId}

    $http.get("/api/meals/" + $routeParams.mealId)
      .success (data) ->
        data.eaten_at = new Date(data.eaten_at)
        data.date = $filter('date')(data.eaten_at, 'yyyy-MM-dd', 'UTC')
        data.time = $filter('date')(data.eaten_at, 'H:mm', 'UTC')
        $scope.meal = data
      .error ->
        alerts.addAlert('danger', "Failed to load the meal.")
  else
    now = new Date()
    $scope.meal =
      eaten_at: now
      date: $filter('date')(now, 'yyyy-MM-dd', 'UTC')
      time: $filter('date')(now, 'H:mm', 'UTC')

  $scope.saveMeal = (meal) ->
    return if $scope.formMeal.$invalid
    mealAttr = 
      calories: parseInt(meal.calories)
      description: meal.description
      eaten_at: "#{meal.date}T#{meal.time}Z"
  
    saveMethod = if meal.id then $http.patch else $http.post
    saveMethod((if meal.id then "/api/meals/#{meal.id}" else "/api/meals/"), mealAttr)
      .success (data) ->
        $location.path('/dashboard')
      .error (data, status, headers, config) ->
        if status == 422 and data.errors
          alerts.addAlert 'danger', "Please fix the following errors: #{data.errors.join(', ')}."
        else
          alerts.addAlert 'danger', 'Failed to save meal.'
]
