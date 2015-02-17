_           = require "underscore"
Puzzle      = require "../models/puzzle.coffee"
PuzzleTimer = require "../libs/puzzle_timer.coffee"

SELECTED_BG_COLOR = "#FAFAD2"
timer = null
template = require "./../views/puzzle.html"

Vue.component "puzzle",
  template: template

  created: ->
    @puzzleId = @$root.params.puzzleId
    puzzle = Puzzle.find @puzzleId
    @flames = puzzle.getGameData()
    timer = new PuzzleTimer()
    timer.start (seconds)=>
      @seconds = seconds

  data:
    flames: []
    selectedIndex: null
    btnHighers: [0,1,2,3,4]
    btnLowers: [5,6,7,8,"x"]
    clearedNow: false
    seconds: 0

  methods:
    checkIfMultipleOf: (baseNumber, number) ->
      (number % baseNumber is 0)

    checkIfLastColumn: (index) ->
      (index + 1 > 72)

    topBorderBold: (index) ->
      nth = index + 1
      (nth <= 9 or (nth > 27 and nth <= 36) or (nth > 54 and nth <= 63))

    selectFlame: (index) ->
      return if @clearedNow
      selected = @flames[index]
      for flame, i in @flames
        if (flame.number? and flame.number is selected.number) or (i is index)
          flame.bgColor = SELECTED_BG_COLOR
        else
          flame.bgColor = "transparent"
      @selectedIndex = index

    setNumber: (number) ->
      return if not @selectedIndex?
      flame = @flames[@selectedIndex]
      return if flame.isImmutable
      if number is "x"
        flame.number = null
      else
        flame.number = number
      @flames[@selectedIndex] = flame
      @checkCorrect()

    checkCorrect: ->
      correctFlames = _.filter @flames, (flame) ->
        return false if not flame.number?
        return (flame.number is flame.answer)

      return if correctFlames.length isnt 81

      @saveClearedRecord()
      @rarefactAllFlames()
      @clearedNow = true

    saveClearedRecord: ->
      timer.stop()
      puzzle = Puzzle.find @puzzleId
      if not puzzle.cleared or timer.seconds < puzzle.time
        puzzle.time = timer.seconds
      puzzle.cleared = true
      puzzle.save()
      Puzzle.saveToDB()

    rarefactAllFlames: ->
      for flame, i in @flames
        flame.bgColor = "transparent"
      return

    backList: ->
      timer.stop()
      @$root.route "content_list"

  filters:
    stringifyPuzzleNumber: (number) ->
      return '' if not number?
      number + 1

    stringifyBtnNumber: (number) ->
      return number if number is "x"
      number + 1
