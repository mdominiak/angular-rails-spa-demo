angular.module('caloriesApp').controller 'MealEditCtrl', ['$scope', '$http', 'alerts', '$filter', '$location', '$routeParams', ($scope, $http, alerts, $filter, $location, $routeParams) ->
  $scope.meal = {id: $routeParams.mealId}
]