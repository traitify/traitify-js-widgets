SimplePromise = (callback)->
    localPromise = Object()
    localPromise.then = (callback)->
      if localPromise.resolved
        callback(localPromise.data)
        localPromise
      else
        localPromise.thenCallback = callback
      localPromise
    localPromise.resolved = false
    
    localPromise.resolve = (data)->
      localPromise.data = data
      if localPromise.thenCallback
        localPromise.thenCallback(data)
      else
        localPromise.resolved = true
      localPromise
        
    localPromise.catch = (callback)->
      if localPromise.rejected
        callback(localPromise.error)
        localPromise
      else
        localPromise.rejectCallback = callback
      localPromise
    localPromise.rejected = false
    
    localPromise.reject = (error)->
      localPromise.error = error
      if localPromise.rejectCallback
        localPromise.rejectCallback(error)
      else
        localPromise.rejected = true
      localPromise
        
    callback(localPromise.resolve, localPromise.reject)
    localPromise

class ApiClient
  constructor: ->
    @host = "https://api.traitify.com"
    
    @version = "v1"

    @testMode = false
    @beautify = false  
    @ui = Object()
    @XHR = XMLHttpRequest
    @

  setBeautify: (mode)->
    @beautify = mode
    @

  setHost: (host) ->
    host = host.replace("http://", "").replace("https://", "")
    host = "https://#{host}"
    @host = host
    this

  setPublicKey: (key) ->
    @publicKey = key
    this

  setVersion: (version) ->
    @version = version
    this

  ajax: (method, url, callback, params)->
    beautify = @beautify
    url = "#{@host}/#{@version}#{url}"
    xhr = new @XHR()
    if "withCredentials" of xhr
      # XHR for Chrome/Firefox/Opera/Safari.
      xhr.open method, url, true
    else unless typeof XDomainRequest is "undefined"

      # XDomainRequest for IE.
      xhr = new XDomainRequest()
      xhr.open method, url
    else

      # CORS not supported.
      console.log "There was an error making the request."
      xhr = null
    xhr

    if xhr
      xhr.setRequestHeader "Authorization", "Basic " + btoa(@publicKey + ":x")

      xhr.setRequestHeader "Content-type", "application/json"
      xhr.setRequestHeader "Accept", "application/json"

    promise = new SimplePromise((resolve, reject)->
      try
        xhr.onload = ->
          data = xhr.response
          if beautify
            data = data.replace(/_([a-z])/g, (m, w)->
                return w.toUpperCase()
            ).replace(/_/g, "")
          data = JSON.parse(data)
          callback(data) if callback
          resolve(data)
        xhr.send JSON.stringify(params)
        xhr
      catch error
        reject(error)
    )

    promise

  put: (url, params, callback) ->
    @ajax "PUT", url, callback, params

  get: (url, callback) ->
    @ajax "GET", url, callback, ""

  getDecks: (callback)->
    @get("/decks", callback)
        

  getSlides: (id, callback)->
    @get("/assessments/#{id}/slides", callback)

  addSlide: (assessmentId, slideId, value, timeTaken, callback)->
    @put("/assessments/#{assessmentId}/slides/#{slideId}", {"response":value, "time_taken": timeTaken}, callback)

  addSlides: (assessmentId, values, callback)->
    @put("/assessments/#{assessmentId}/slides", values, callback)
    
  getPersonalityTypes: (id, options, callback)->
    options ?= Object()
    options.image_pack ?= "linear"
    params = Array()
        
    for key in Object.keys(options)
      params.push("#{key}=#{options[key]}")
        
    @get("/assessments/#{id}/personality_types?#{params.join("&")}", callback)

  getPersonalityTraits: (id, options, callback)->
    @get("/assessments/#{id}/personality_traits/raw", callback)

  getPersonalityTypesTraits: (assessmentId, personalityTypeId, callback)->
    @get("/assessments/#{assessmentId}/personality_types/#{personalityTypeId}/personality_traits", callback)

Traitify = new ApiClient()