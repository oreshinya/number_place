template = require("./../views/start.html")

Vue.component "start",
  template: template
  methods:
    goContentList: ->
      @$root.route "content_list"
