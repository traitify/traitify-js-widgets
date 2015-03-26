class MockRequest
  mocks = Array()
  @addMock = (options)->
    mocks.push(options)
  constructor: ->
    @headers = Array()
    @response = null
    @onload = ->
  
  open: (method, url)->
    @currentMethod = method
    @currentUrl = url
  send: (params)->
    currentMethod = @currentMethod
    currentUrl = @currentUrl
    params = JSON.parse(params) 
    request = mocks.filter( (request)-> 
      goodParams = true
      if request.params && JSON.stringify(params) == JSON.stringify({})
        if params
          for key, value of request.params
            goodParams = goodParams && params[key] == value
        else
          goodParams = false
      request.method == currentMethod && request.url == currentUrl && goodParams
    )
    if request[0]
      @response = JSON.stringify(request[0].response)
      @onload()
    else
      console.log("#{currentMethod} with url #{currentUrl} and #{JSON.stringify(params)} is not mocked")
      @onload()
  
  setRequestHeader: (key, value)->
    @headers.push([key, value])

  withCredentials: ->
    Object()
    this

class MockIEXMLRequest
  mocks = Array()
  @addMock = (options)->
    mocks.push(options)
  constructor: ->
    @headers = Array()
    @response = null
    @onload = ->
  
  open: (method, url)->
    @currentMethod = method
    @currentUrl = url
  send: (params)->
    currentMethod = @currentMethod
    currentUrl = @currentUrl
    params = JSON.parse(params) 
    request = mocks.filter( (request)-> 
      goodParams = true
      if request.params && JSON.stringify(params) == JSON.stringify({})
        if params
          for key, value of request.params
            goodParams = goodParams && params[key] == value
        else
          goodParams = false
      request.method == currentMethod && request.url == currentUrl && goodParams
    )
    if request[0]
      @response = JSON.stringify(request[0].response)
      @onload()
    else
      console.log("#{currentMethod} with url #{currentUrl} and #{JSON.stringify(params)} is not mocked")
      @onload()
  
  setRequestHeader: (key, value)->
    @headers.push([key, value])

class MockRequestWithError
  mocks = Array()
  @addMock = (options)->
    mocks.push(options)
  constructor: ->
    @headers = Array()
    @response = null
    @onload = ->
  
  open: (method, url)->
    @currentMethod = method
    @currentUrl = url
  send: (params)->
    throw "Mock Request Error"
  
  setRequestHeader: (key, value)->
    @headers.push([key, value])
  withCredentials: ->
    Object()
    this
setTimeout = (func, notfunc)->
  func()
