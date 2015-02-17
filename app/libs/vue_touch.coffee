Hammer = require "hammerjs"

Vue.directive "touch",
  isFn: true
  bind: ->
    if !@el.hammer?
      @el.hammer = Hammer @el
  update: (fn) ->
    vm = @vm
    @handler = (e) ->
      e.targetVM = vm
      fn.call vm, e
    @el.hammer.on @arg, @handler
  unbind: ->
    @el.hammer.off @arg, @handler
    if !@el.hammer.eventHandlers.length
      @el.hammer = null

