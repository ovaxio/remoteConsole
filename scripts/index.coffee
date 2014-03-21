request = require('superagent')

class RemoteConsole

  constructor : (@server)->
    window.onerror = @sendError if @server?
      
  sendError : (e,url,l)=>
    # console.log @server
    data = 
        error:
          msg: e
          file: url
          line: l,
        browser: 
          @getNavigatorData()
        window:
          @getWindowData()

    request.get @server
    .query JSON.stringify data
    .end ()->      
    # console.log data

  getWindowData : ()->
    innerHeight: window.innerHeight
    innerWidth: window.innerWidth

  getNavigatorData : ()->
    appCodeName: navigator.appCodeName
    appName: navigator.appName
    appVersion: navigator.appVersion
    platform: navigator.platform
    userAgent: navigator.userAgent
    vendor: navigator.vendor

module.exports = RemoteConsole