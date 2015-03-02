@tk15_module.service 'kilpakoService', [
  '$http', '$q',
  ($http, $q) -> 
    service =
      getCompetitionInfo: ->
        me = this
        $http.get("./competition.json").then (server_response) ->
          server_response.data
    service
]
