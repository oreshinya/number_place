admobInitialize =
  execute: ->
    if plugins?.AdMob?
      am = plugins.AdMob
      admobKeyAndroid = ""
      opts =
        publisherId: admobKeyAndroid
        adSize: am.AD_SIZE.BANNER
      success = ->
        opts =
          isTesting: false
        success = ->
          am.showAd true
        am.requestAd opts, success, null
      am.createBannerView opts, success, null

module.exports = admobInitialize
