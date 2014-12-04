angular.module('caloriesApp').controller 'MealsCtrl', ['$scope', '$http', ($scope, $http) ->
  $scope.meals = []

  $http.get('/api/meals')
    .success (data) ->
      $scope.meals = data
    .error ->
      console.log 'error'
]