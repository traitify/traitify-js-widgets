Mocker = Object()
Mocker.initialize = ->
  window.XMLHttpRequest = ->
    @open = (method, url)->
      @requestMethod = method
      @requestUrl = url
    @send = (params)->
      try
        byMethodAndUrl = Mocker.mocks[@requestMethod][@requestUrl]
        unless(params)
          params = JSON.stringify(Object())
        @response = byMethodAndUrl[params]
        @onload()
      catch err
        console.log("#{@requestMethod} with url #{@requestUrl} and #{params} is not mocked")

    @headers = Object()
    @setRequestHeader = (key, value)->
      @headers[key] = value

    @withCredentials = ->
      Object()
    this
  
  window.XDomainRequest = window.XMLHttpRequest
  
Mocker.mocks = Object()
Mocker.mock = (method, url, params, data)->
  if typeof Mocker.mocks[method] == "undefined"
    Mocker.mocks[method] = Object()
  if typeof window.Mocker.mocks[method][url] == "undefined"
    Mocker.mocks[method][url] = Object()
    Mocker.mocks[method][url][params] = JSON.stringify(data)
