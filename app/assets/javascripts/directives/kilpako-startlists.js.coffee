@tk15_module.directive 'kilpakoStartlists', ['$timeout', 'kilpakoService', ($timeout, kilpakoService) ->
  ret =
    restrict: 'E'
    scope: true
    transclude: false
    controller: ($scope) ->
      kilpakoService.getCompetitionInfo().then (data) ->
        $scope.competition_info = data
      $scope.doShowCompetition = (c) ->
        c and c.state and c.state != "open"
    templateUrl: "kilpako-startlists.html"
  ]
