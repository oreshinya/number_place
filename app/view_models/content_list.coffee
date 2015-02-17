Puzzle = require("../models/puzzle.coffee")

template = require("./../views/content_list.html")

Vue.component "content_list",
  template: template
  created: ->
    @puzzles = Puzzle.all()
  methods:
    startPuzzle: (index)->
      puzzle = @puzzles[index]
      @$root.route "puzzle",
        puzzleId: puzzle.id
