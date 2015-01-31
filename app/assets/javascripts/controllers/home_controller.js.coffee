@tk15_module.controller 'HomeController', [
  '$scope', '$location', '$http', '$timeout', ($scope, $location, $http,$timeout) ->
    $scope.modernWebBrowsers = [
      { name: "Sp4", desc: "Sprint 4 dogs", selected: false  },
      { name: "Sp4J", desc: "Sprint 4 dogs juniors", selected: false  },
      { name: "Sp6", desc: "Sprint 6 dogs", selected: false  },
      { name: "Sp8", desc: "Sprint 8 dogs", selected: false  },
      { name: "SpU", desc: "Sprint open class", selected: false  },
      { name: "NWS1A", desc: "Dog skiing Women A", selected: false  },
      { name: "NWS1B", desc: "Dog skiing Women B", selected: false  },
      { name: "NMS1A", desc: "Dog skiing Men A", selected: false  },
      { name: "NMS1B", desc: "Dog skiing Men B", selected: false  },
      { name: "NWSJ A/B", desc: "Dog skiing Girls A&B", selected: false  },
      { name: "NMSJ A/B", desc: "Dog skiing Boys A&B", selected: false  },
      { name: "Veteraani Naiset A", desc: "Dog skiing Veteran women A", selected: false  },
      { name: "Veteraani Naiset B", desc: "Dog skiing Veteran women B", selected: false  },
      { name: "Veteraani Miehet A", desc: "Dog skiing Veteran men A", selected: false  },
      { name: "Veteraani Miehet B", desc: "Dog skiing Veteran men B", selected: false  },
      { name: "NWC A", desc: "Combined Women A", selected: false  },
      { name: "NMC A", desc: "Combined Men A", selected: false  },
      { name: "Harrastussarja la", desc: "Dog skiing motion class Sat", selected: false  },
      { name: "Harrastussarja su", desc: "Dog skiing motion class Sun", selected: false  },
    ]
    $scope.alerts = []
    $scope.closeAlert = (index) ->
      $scope.alerts.splice(index, 1);
    $scope.app_form =
      name: 'zeljko'
      email: 'zeljko@zwr.fi'
      club: 'z-ware'
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
      $http.post("/apply.json", $scope.app_form)
      .then (result) ->
        console.log "Great success! Application: #{result.data.application}"
        $scope.alerts.push { type: 'success', msg: "Great success! You will soon receive a confirmation by email. Your application number is #{result.data.application.appnum}." }
      .catch (reason) ->
        console.log "error: #{JSON.stringify(reason)}"
        $scope.alerts.push { type: 'danger', msg: 'Oh snap! Something did not go well. If all other fails, try the phone.' }
]