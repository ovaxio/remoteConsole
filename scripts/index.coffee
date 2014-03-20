request = require('superagent')

class RemoteConsole

  constructor : (srv)->
    @server = srv

    if @server?
      window.onerror = @sendError

  sendError : (e,url,l)->
    data = 
        error:
          msg: e
          file: url
          line: l,
        browser: 
          appCodeName: navigator.appCodeName
          appName: navigator.appName
          appVersion: navigator.appVersion
          platform: navigator.platform
          userAgent: navigator.userAgent
          vendor: navigator.vendor
        window:
          innerHeight: window.innerHeight
          innerWidth: window.innerWidth

    request.get @server
    .query JSON.stringify data
    .end ()->      

module.exports = RemoteConsole