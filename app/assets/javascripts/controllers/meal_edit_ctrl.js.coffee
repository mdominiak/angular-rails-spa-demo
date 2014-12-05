angular.module('caloriesApp').controller 'MealEditCtrl', ['$scope', '$http', 'alerts', '$filter', '$location', '$routeParams', ($scope, $http, alerts, $filter, $location, $routeParams) ->
  $scope.meal = {id: $routeParams.mealId}

  $http.get("/api/meals/" + $routeParams.mealId)
    .success (data) ->
      data.eaten_at = new Date(data.eaten_at)
      data.time = angular.copy(data.eaten_at)
      $scope.meal = data
    .error ->
      alerts.addAlert('danger', "Failed to load the meal.")
]
