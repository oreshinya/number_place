portraitWidth = landscapeWidth = null
ua = window.navigator.userAgent

$(window).bind "resize", ->
  if Math.abs window.orientation is 0
    if /Android/.test ua
      portraitWidth = $(window).width() if not portraitWidth
    else
      portraitWidth = $(window).width()
    $("html").css("zoom", portraitWidth / 320)
  else
    if /Android/.test ua
      landscapeWidth = $(window).width() if not landscapeWidth
    else
      landscapeWidth = $(window).width()
    $("html").css("zoom", landscapeWidth / 320)

$(window).trigger "resize"
