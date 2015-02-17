Compact = require('../libs/compact.coffee')
_ = require("underscore")

class Puzzle extends Compact
  @storageName: "Puzzle"

  @_populatedJSONKey: "populatedJSON-#{@_getStorageKey()}"

  @alreadyPopulatedFromJSON: localStorage.getItem(@_populatedJSONKey) ? false

  @populateFromJSON: ->
    return @loadFromDB() if @alreadyPopulatedFromJSON
    puzzles = require("./../../data/puzzles.json")
    @populate(puzzles)
    @saveToDB()
    storageKey = @_getStorageKey()
    localStorage.setItem(@_populatedJSONKey, true)
    @alreadyPopulatedFromJSON = true

  getGameData: ->
    data = []
    for question, i in @question
      data.push
        number: question
        answer: @solution[i]
        isImmutable: question?
        bgColor: "transparent"
        fontWeight: if question? then "bold" else "normal"
    return data

module.exports = Puzzle
