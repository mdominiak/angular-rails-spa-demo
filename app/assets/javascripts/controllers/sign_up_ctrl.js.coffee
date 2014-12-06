angular.module('caloriesApp').controller 'SignUpCtrl', ['$scope', '$http', '$location', 'alerts', '$rootScope', ($scope, $http, $location, alerts, $rootScope) ->
  busy = false

  $scope.signUp = (user) ->
    return if $scope.formUser.$invalid
    return if busy
    busy = true
    $http.post('/api/users', user: user)
      .success (data) ->
        $rootScope.currentUser = data
        $location.path('/dashboard')
      .error (data, status, headers, config) ->
        if status == 422 and data.errors
          alerts.addAlert 'danger', "Please fix the following errors: #{data.errors.join(', ')}."
        else
          alerts.addAlert 'danger', 'Failed to sign up.'        
        busy = false
]
