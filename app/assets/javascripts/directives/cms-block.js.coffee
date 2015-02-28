@tk15_module.directive 'cmsBlock', ['cmsService', (cmsService) ->
  ret =
    restrict: 'A'
    scope:
      cmsBlock: '@'
    link: (scope, elem, attr) ->
      cmsService.getBlockView(scope.cmsBlock).then (view) ->
        elem.append(view)
]
