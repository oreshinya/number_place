ami = require "./libs/admob_initialize.coffee"
Puzzle = require './models/puzzle.coffee'

initializeApp = ->
  # initialize admob
  ami.execute()

  # initialize master data
  Puzzle.populateFromJSON()

  #initialize app
  app = new Vue
    el: "#app"
    data:
      currentView: "start"
      params: {}
    methods:
      route: (componentName, params) ->
        @params = params
        @currentView = componentName

$(document).bind "deviceready", initializeApp
