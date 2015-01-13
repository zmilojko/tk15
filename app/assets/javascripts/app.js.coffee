#= require angular
#= require angular-route
#= require angular-resource
#= require angular-rails-templates
#= require_tree ./templates
#= require_self
#= require_tree ./includes
#= require_tree ./directives
#= require_tree ./services
#= require_tree ./controllers
#= require angular-ui-bootstrap

@tk15_module = angular.module('tk15', [
  'ngRoute', 
  'ngResource', 
  'templates',
  'ui.bootstrap',
  'LocalStorageModule',
  ])

@tk15_module.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    #when('/url', {
    #  templateUrl: 'template.html',
    #}).
    otherwise({
      templateUrl: 'home.html',
    }) 
])

@tk15_module.config(['localStorageServiceProvider', (localStorageServiceProvider) ->
  localStorageServiceProvider
    .setPrefix('tk15')
    .setStorageType('localStorage')
    .setStorageCookie(0, '<path>')
    .setNotify(true, true)
])
