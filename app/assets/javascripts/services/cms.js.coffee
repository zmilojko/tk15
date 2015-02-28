@tk15_module.service 'cmsService', [
  '$http', '$q',
  ($http, $q) -> 
    service =
      getBlock: (block_name) ->
        me = this
        $http.get("./cms/#{block_name}.json").then (server_response) ->
          server_response.data
      getBlockView: (block_name) ->
        this.getBlock(block_name).then (data) ->
          data.view
    service
]
