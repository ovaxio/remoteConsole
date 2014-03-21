request = require('superagent')
extend = require('extend')

class RemoteConsole

  constructor : (@_options)->

    @_default = 
      server: null
      method: 'get'
      callback: null
      toScreen: true
      data: 
        error : null
        browser: @getNavigatorData()
        window: @getWindowData()

   # if @_options instanceof Object and @_options?
    @_options = extend {},@_default,@_options

    window.onerror = @sendError if @_options.server?
    @_options.method = @_options.method.toLowerCase() if typeof @_options.method is "string"
    
  sendError : (e,url,l)=>
    
    @_options.data.error = 
      msg: e
      file: url
      line: l

    # Sending method choice
    # switch @_options.method
    #   when "ws","websocket"
    #     if typeof WebSocket is "function" or typeof window.WebSocket is "function"
    #       @sendByWebSocket()
    #     else
    #       @sendByAjax()
    #   else
    #     @sendByAjax()
    @sendByAjax()
    @sendToScreen() if @_options.toScreen is on

    return true

  # sendByWebSocket : ()=>
  #   ws = new WebSocket @_options.server
  #   ws.onopen = ()->
  #     ws.send(@_options.data)
  #   ws.onmessage = (e)->
  #     # console.log e.data
  #   ws.onclose = ()->

  sendByAjax : ()->
    _req = switch @_options.method
      when "post"
        request.post @_options.server
      else
        request.get @_options.server

    # Set headers
    if @_options.headers?
      for variable,value of @_options.headers
        _req.set variable,value

    # Send the request with the data
    _req.send @_options.data

    # callback
    _req.end (err,res)=>
      if @_options.callback?
        @_options.callback(err,res)
        return

  sendToScreen : ()->
    body = document.getElementsByTagName('body')[0]
    rcons = document.createElement 'div'
    pre = document.createElement 'pre'

    rcons.className = 'rcons-wrap'

    pre.innerText = JSON.stringify @_options.data, undefined, 2
    rcons.appendChild pre
    body.appendChild rcons

  getWindowData : ()->
    innerHeight: window.innerHeight
    innerWidth: window.innerWidth

  getNavigatorData : ()->
    appCodeName: navigator?.appCodeName?
    appName: navigator?.appName?
    appVersion: navigator?.appVersion?
    platform: navigator?.platform?
    userAgent: navigator?.userAgent?
    vendor: navigator?.vendor?

module.exports = RemoteConsole