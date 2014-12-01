
app = angular.module('caloriesApp', ['ngRoute']);

app.config ['$routeProvider', '$locationProvider', ($routeProvider, $locationProvider) ->
  $locationProvider.html5Mode true
  $routeProvider.when '/', templateUrl: '/home.html'
  $routeProvider.when '/meals/new', templateUrl: 'new.html'
]