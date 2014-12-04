angular.module('caloriesApp').controller 'MealsCtrl', ['$scope', '$http', 'alerts', ($scope, $http, alerts) ->
  $scope.meals = []

  $http.get('/api/meals')
    .success (data) ->
      $scope.meals = data
    .error ->
      alerts.addAlert('danger', 'Failed to load meals.')
]