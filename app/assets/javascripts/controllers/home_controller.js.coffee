@tk15_module.controller 'HomeController', [
  '$scope', '$location', '$http', '$timeout', ($scope, $location, $http,$timeout) ->
    $scope.modernWebBrowsers = [
      { raceGroup: 'reki', name: "Sp4", desc: "Sp4 - Sprint 4 dogs", selected: false  },
      { raceGroup: 'reki', name: "Sp4J", desc: "Sp4J - Sprint 4 dogs juniors", selected: false  },
      { raceGroup: 'reki', name: "Sp6", desc: "Sp6 - Sprint 6 dogs", selected: false  },
      { raceGroup: 'reki', name: "Sp8", desc: "Sp8 - Sprint 8 dogs", selected: false  },
      { raceGroup: 'reki', name: "SpU", desc: "SpU - Sprint open class", selected: false  },
      { raceGroup: 'hiihto', name: "NWS1A", desc: "NWS1A - Dog skiing Women A", selected: false  },
      { raceGroup: 'hiihto', name: "NWS1B", desc: "NWS1B - Dog skiing Women B", selected: false  },
      { raceGroup: 'hiihto', name: "NMS1A", desc: "NMS1A - Dog skiing Men A", selected: false  },
      { raceGroup: 'hiihto', name: "NMS1B", desc: "NMS1B - Dog skiing Men B", selected: false  },
      { raceGroup: 'hiihto', name: "NWSJ A/B", desc: "NWSJ A/B - Dog skiing Girls A&B", selected: false  },
      { raceGroup: 'hiihto', name: "NMSJ A/B", desc: "NMSJ A/B - Dog skiing Boys A&B", selected: false  },
      { raceGroup: 'hiihto', name: "Veteraani Naiset A", desc: "Dog skiing Veteran women A", selected: false  },
      { raceGroup: 'hiihto', name: "Veteraani Naiset B", desc: "Dog skiing Veteran women B", selected: false  },
      { raceGroup: 'hiihto', name: "Veteraani Miehet A", desc: "Dog skiing Veteran men A", selected: false  },
      { raceGroup: 'hiihto', name: "Veteraani Miehet B", desc: "Dog skiing Veteran men B", selected: false  },
      { raceGroup: 'hiihto', name: "NWC A", desc: "NWC A - Combined Women A", selected: false  },
      { raceGroup: 'hiihto', name: "NMC A", desc: "NMC A - Combined Men A", selected: false  },
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

