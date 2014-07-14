window.mocker = Object()
window.XMLHttpRequest = ->
  @open = (method, url)->
    @requestMethod = method
    @requestUrl = url
  @send = (params)->
    try
      byMethodAndUrl = window.mocker.mocks[@requestMethod][@requestUrl]
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

window.mocker.mocks = Object()
window.mocker.mock = (method, url, params, data)->
  if typeof window.mocker.mocks[method] == "undefined"
    window.mocker.mocks[method] = Object()
  if typeof window.mocker.mocks[method][url] == "undefined"
    window.mocker.mocks[method][url] = Object()
    window.mocker.mocks[method][url][params] = JSON.stringify(data)
