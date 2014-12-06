angular.module('caloriesApp').controller 'SettingsCtrl', ['$scope', '$http', '$location', 'alerts', '$rootScope', ($scope, $http, $location, alerts, $rootScope) ->
  $scope.user = angular.copy($rootScope.currentUser)

  busy = false
  $scope.updateUser = (user) ->
    return if $scope.formUser.$invalid
    return if busy
    busy = true
    $http.patch('/api/users', user: user)
      .success (data) ->
        $rootScope.currentUser = data
        alerts.addAlert 'success', 'Settings have been saved successfully.'
      .error (data, status, headers, config) ->
        if status == 422 and data.errors
          alerts.addAlert 'danger', "Please fix the following errors: #{data.errors.join(', ')}."
        else
          alerts.addAlert 'danger', 'Failed to save settings.'
        busy = false
]
