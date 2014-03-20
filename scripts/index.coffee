request = require('superagent')

window.onerror = (e,url,l)->
  data = 
    msg: e
    file: url
    line: l

  server = "http://requestb.in/xcglyexc"
  
  request.post server
  .send JSON.stringify data
  .end ()->
