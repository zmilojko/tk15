@tk15_module.controller 'HomeController', [
  '$scope', '$location', '$http', '$timeout', 'kilpakoService', 
  ($scope, $location, $http,$timeout,kilpakoService) ->
    kilpakoService.startPolling()
    $scope.modernWebBrowsers = [
      { raceGroup: 'reki', name: "Sp4 SM", desc: "Sp4 SM - Sprint 4 dogs", selected: false  },
      { raceGroup: 'reki', name: "Sp4J SM", desc: "Sp4J SM - Sprint 4 dogs juniors", selected: false  },
      { raceGroup: 'reki', name: "Sp6", desc: "Sp6 - Sprint 6 dogs", selected: false  },
      { raceGroup: 'reki', name: "Sp8 SM", desc: "Sp8 SM - Sprint 8 dogs", selected: false  },
      { raceGroup: 'reki', name: "SpU", desc: "SpU - Sprint open class", selected: false  },
      { raceGroup: 'hiihto', name: "NWS1A SM", desc: "NWS1A SM - Dog skiing Women A", selected: false  },
      { raceGroup: 'hiihto', name: "NWS1B SM", desc: "NWS1B SM - Dog skiing Women B", selected: false  },
      { raceGroup: 'hiihto', name: "NMS1A SM", desc: "NMS1A SM - Dog skiing Men A", selected: false  },
      { raceGroup: 'hiihto', name: "NMS1B SM", desc: "NMS1B SM - Dog skiing Men B", selected: false  },
      { raceGroup: 'hiihto', name: "NWSJ A/B SM", desc: "NWSJ SM A/B - Skiing Girls A&B", selected: false  },
      { raceGroup: 'hiihto', name: "NMSJ A/B SM", desc: "NMSJ SM A/B - Skiing Boys A&B", selected: false  },
      { raceGroup: 'hiihto', name: "Veteraani Naiset A SM", desc: "Dog skiing Veteran women A SM", selected: false  },
      { raceGroup: 'hiihto', name: "Veteraani Naiset B SM", desc: "Dog skiing Veteran women B SM", selected: false  },
      { raceGroup: 'hiihto', name: "Veteraani Miehet A SM", desc: "Dog skiing Veteran men A SM", selected: false  },
      { raceGroup: 'hiihto', name: "Veteraani Miehet B SM", desc: "Dog skiing Veteran men B SM", selected: false  },
      { raceGroup: 'hiihto', name: "NWC A SM", desc: "NWC A - Combined Women A SM", selected: false  },
      { raceGroup: 'hiihto', name: "NMC A SM", desc: "NMC A - Combined Men A SM", selected: false  },
      { raceGroup: 'hiihto', name: "Harrastussarja la", desc: "Harrastussarja la - Dog skiing motion class Sat", selected: false  },
      { raceGroup: 'hiihto', name: "Harrastussarja su", desc: "Harrastussarja su - Dog skiing motion class Sun", selected: false  },
    ]
    $scope.alerts = []
    $scope.closeAlert = (index) ->
      $scope.alerts.splice(index, 1);
    $scope.app_form = {}
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
      $scope.app_form.races = []
      $scope.app_form.races.push race.name for race in $scope.selectedRaces
      $scope.alerts.push { type: 'success', msg: "Ole hyvä ja odota, lataaminen voi kestää hetken!" }
      $http.post("/apply.json", $scope.app_form)
      .then (result) ->
        console.log "Great success! Application: #{result.data.application}"
        $scope.alerts.push { type: 'success', msg: "Ilmoittautuminen onnistui!" }
        $scope.app_form = {}
      .catch (reason) ->
        console.log "error: #{JSON.stringify(reason)}"
        if reason.data? and reason.data.reason?
          $scope.alerts.push { type: 'danger', msg: reason.data.reason }
        else
          $scope.alerts.push { type: 'danger', msg: 'Oh snap! Something did not go well. If all other fails, try the phone.' }
    $scope.checkCompetitions = ->
      kilpakoService.hasActiveToShow().then (has_active_to_show) ->
        $scope.has_active_to_show = has_active_to_show
        unless $scope.has_active_to_show
          if $location.url() == "LIVE"
            $location.url("tulokset")
      kilpakoService.hasStartlistToShow().then (has_startlist_to_show) ->
        $scope.has_startlist_to_show = has_startlist_to_show
      kilpakoService.hasResultsToShow().then (has_results_to_show) ->
        $scope.has_results_to_show = has_results_to_show
      $timeout ->
        $scope.checkCompetitions()
      , 200
    $scope.checkCompetitions()
]

.directive "blinker", ['$timeout', ($timeout) ->
  restrict: 'A',
  link: (scope, element, attributes) ->
    blinker = ->
      $timeout ->
        element.toggleClass "blink-on"
        blinker()
      , 800
    blinker()
  ]
    
    #many thanks to http://stackoverflow.com/questions/17063000/ng-model-for-input-type-file
.directive "fileread", ->
    ret = 
      scope:
        fileread: "="
      link: (scope, element, attributes) ->
        element.bind "change", (changeEvent) ->
          reader = new FileReader()
          reader.onload = (loadEvent) ->
            scope.$apply ->
              scope.fileread = loadEvent.target.result;
          reader.readAsDataURL(changeEvent.target.files[0]);
          ###
          scope.$apply ->
            scope.fileread = changeEvent.target.files[0]
          ###

