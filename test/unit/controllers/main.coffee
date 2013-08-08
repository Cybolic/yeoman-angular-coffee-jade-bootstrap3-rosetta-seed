'use strict'

describe 'Controller: MainCtrl', () ->

  # load the controller's module
  beforeEach module 'yoAngularApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 7

  it 'should add a few specific strings to awesomeThings', ->
    expect(scope.awesomeThings).toContain 'AngularJS'
    expect(scope.awesomeThings).toContain 'Jade'
    expect(scope.awesomeThings).toContain 'CoffeeScript'
