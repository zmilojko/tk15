@tk15_module.service 'kilpakoService', [
  '$http', '$q', '$timeout',
  ($http, $q, $timeout) -> 
    service =
      latestCompetitionInfo: null
      getCompetitionInfo: ->
        $http.get("./competition.json").then (server_response) ->
          service.connection_Error = false
          service.latestCompetitionInfo = server_response.data
      competitionInfo: ->
        if @latestCompetitionInfo
          $q.when @latestCompetitionInfo
        else
          @getCompetitionInfo()
      hasActiveToShow: ->
        @competitionInfo().then (data) ->
          return true for competition in data when competition.state == "active"
          return false
      hasResultsToShow: ->
        @competitionInfo().then (data) ->
          return true for competition in data when ("done closed".indexOf(competition.state) + 1)
          return false
      hasStartlistToShow: ->
        @competitionInfo().then (data) ->
          return true for competition in data when ("ready active".indexOf(competition.state) + 1)
          return false
      should_poll_fast: false
      connection_Error: false
      fastPolling: (should_poll_fast) ->
        @should_poll_fast = should_poll_fast
      startPolling: ->
        @getCompetitionInfo().then (data) ->
          console.log "received updated data"
          service.hasStartlistToShow().then (is_active_competition) ->
            if is_active_competition
              $timeout ->
                service.startPolling()
              , if service.should_poll_fast then 3000 else 10000
        .catch ->
          service.connection_Error = true
          $timeout ->
            service.startPolling()
          , 10000
    service.startPolling()
    service
]
