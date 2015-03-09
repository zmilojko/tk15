@tk15_module.directive 'kilpakoStartlists', ['$timeout', 'kilpakoService', ($timeout, kilpakoService) ->
  ret =
    restrict: 'E'
    scope:
      infoType: '@'
    transclude: false
    controller: ['$scope', ($scope) ->
      $scope.poll = ->
        kilpakoService.competitionInfo().then (data) ->
          $scope.competition_info = data
        $timeout ->
          $scope.poll()
        , 200
      $scope.poll()
      $scope.doShowCompetitionInStartlist = (c) ->
        c and c.state and ("ready active".indexOf(c.state) + 1)
      $scope.doShowCompetitionInLive = (c) ->
        c and c.state and ("active".indexOf(c.state) + 1)
      $scope.doShowCompetitionInResults = (c) ->
        c and c.state and ("done closed".indexOf(c.state) + 1)
      $scope.doShowCompetitionInStartlistDay2Results = (c) ->
        c and c.state and c.state=="done" and c.type=="two runs combined"
    ]
    templateUrl: (elem, attr) ->
      "kilpako-#{attr['infoType']}.html"
  ]
