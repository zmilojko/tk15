@tk15_module.controller 'HomeController', [
  '$scope', '$location', ($scope, $location) ->
    $scope.modernWebBrowsers = [
      { name: "Sp4", desc: "Sprint 4 dogs, 7km", selected: false  },
      { name: "Sp6", desc: "Sprint 6 dogs, 12km", selected: false  },
      { name: "Sp8", desc: "Sprint 8 dogs, 12km", selected: false  },
      { name: "SpU", desc: "Sprint open class, 22km", selected: false  },
      { name: "SpJ4", desc: "Sprint 4 dogs, Juniors, 7km", selected: false  },
      { name: "First run", desc: "Run for  kids with dogs, 300m", selected: false  },
    ]
    $scope.raceboxsettings =
      showCheckAll: false
      showUncheckAll: false
    $scope.criteria =
      criteria_text: null
    $scope.onPage = (pageId) ->
      "active" if $location.url() == pageId
    $scope.handle_search_criteria_change = ->
      console.log "Text change, now it is #{$scope.criteria.criteria_text}"
    $scope.handle_search_button_click = ->
      console.log "Search button clicked"
    $scope.submit = ->
      console.log $scope.selectedRaces
]