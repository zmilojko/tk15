@tk15_module.directive 'ztFullSize', ['$window', ($window) ->
  ret =
    restrict: 'A'
    setHeight: (elem, h) ->
      elem.attr 'style', "min-height: #{h}px;"
    link: ( scope, elem, attrs ) ->
      angular.element($window).bind "resize", (e) ->
        ret.setHeight(elem, e.srcElement.innerHeight)
      ret.setHeight(elem, $window.innerHeight)
]
