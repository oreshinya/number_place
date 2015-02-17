class PuzzleTimer
  constructor: ->
    @seconds = 0
    return @

  start: (timerCallback) ->
    callback = =>
      @seconds += 1
      timerCallback(@seconds)

    @timer = setInterval callback, 1000

  stop: ->
    clearInterval @timer

module.exports = PuzzleTimer
