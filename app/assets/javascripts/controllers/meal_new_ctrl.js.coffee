angular.module('caloriesApp').controller 'MealNewCtrl', ['$scope', '$http', 'alerts', '$filter', '$location', ($scope, $http, alerts, $filter, $location) ->
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
  
    $http.post('/api/meals', mealAttr)
      .success (data) ->
        $location.path('/dashboard')
      .error ->
        alerts.addAlert('danger', 'Failed to save meal.')
]