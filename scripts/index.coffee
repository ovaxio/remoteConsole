request = require('superagent')
extend = require('extend')
events = require('events')

class RemoteConsole

  constructor : (@_options)->
    @_icons =
      close: '&#9660;'
      open: '&#9650;'

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
    # @sendByAjax()
    @sendByAjax() if @_options.method? and @_options.server?
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
    classPrefix = 'rcons-'
    body = document.getElementsByTagName('body')[0]
    rcons = document.createElement 'div'
    title = document.createElement 'div'
    close = document.createElement 'span'
    pre = document.createElement 'pre'

    close.id = 'rcons-close'
    close.className = classPrefix+'close'

    rcons.id = 'rconsole'
    rcons.className = classPrefix+'wrap'

    title.className = classPrefix+'title'

    close.innerHTML = @_icons.close
    title.innerText = "Remote Console"
    pre.innerText = JSON.stringify @_options.data, undefined, 2

    # append to DOM
    title.appendChild close
    rcons.appendChild title
    rcons.appendChild pre
    body.appendChild rcons

    # events
    el = document.getElementById 'rconsole'
    @events = events(el, this);
    @events.bind('click .rcons-title', 'toggle', el);

  toggle : ()->
    el = [].slice.call(arguments, 1).shift()
    
    # toggle display (add css class)
    if el.className?
      closeBtn = document.getElementById 'rcons-close'

      if el.className.indexOf("rcons-hidden") != -1
        tmp = el.className.split " "
        idx = tmp.indexOf "rcons-hidden"
        tmp.splice idx, 1
        .join " "

        closeBtn.innerHTML = @_icons.close
      else
        tmp = el.className.concat " rcons-hidden"
        closeBtn.innerHTML = @_icons.open

      el.className = tmp
      
    return
    

  getWindowData : ()->
    if window?
      innerHeight: window.innerHeight
      innerWidth: window.innerWidth

  getNavigatorData : ()->
    if navigator?
      {
        appCodeName: navigator.appCodeName if navigator.appCodeName?
        appName: navigator.appName if navigator.appName?
        appVersion: navigator.appVersion if navigator.appVersion?
        platform: navigator.platform if navigator.platform?
        userAgent: navigator.userAgent if navigator.userAgent?
        vendor: navigator.vendor if navigator.vendor?
      }


module.exports = RemoteConsole