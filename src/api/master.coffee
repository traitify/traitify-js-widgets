@Traitify = new(()->
  tfPromise = (callback)->
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
      else
        localPromise.rejectCallback = callback
      localPromise
    localPromise.rejected = false
    
    localPromise.reject = (error)->
      localPromise.error = error
      if localPromise.rejectCallback
        localPromise.rejectCallback(data)
      else
        localPromise.rejected = true
      localPromise
        
    callback(localPromise.resolve, localPromise.reject)
    localPromise
    
  
  @host = "https://api.traitify.com"
  
  @version = "v1"

  @testMode = false

  @setTestMode = (mode)->
    @testMode = mode
    this

  @setHost = (host) ->
    host = host.replace("http://", "").replace("https://", "")
    host = "https://#{host}"
    @host = host
    this

  @setPublicKey = (key) ->
    @publicKey = key
    this

  @setVersion = (version) ->
    @version = version
    this

  @ajax = (url, method, callback, params)->
    url = "#{@host}/#{@version}#{url}"

    xhr = new XMLHttpRequest()
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

    xhr.open method, url, true

    xhr.setRequestHeader "Authorization", "Basic " + btoa(@publicKey + ":x")

    xhr.setRequestHeader "Content-type", "application/json"
    xhr.setRequestHeader "Accept", "application/json"
    xhr.onload = ->
      data = JSON.parse(xhr.response)
      callback data
      return false

    xhr.send params
    xhr


    this

  @put = (url, params, callback) ->
    @ajax url, "PUT", callback, params
    this

  @get = (url, callback) ->
    @ajax url, "GET", callback, ""
    this

  @getDecks = (callback)->
    promise = new tfPromise((resolve, reject)->
      try
        Traitify.get("/decks", (data)->
          callback(data) if callback
          resolve(data) if resolve
        )
      catch error
        reject(error) if reject
    )
    promise
        

  @getSlides = (id, callback)->
    promise = new tfPromise((resolve, reject)->
      try
        Traitify.get("/assessments/#{id}/slides", (data)->
            callback(data) if callback
            resolve(data) if resolve
        )
      catch error
          reject(error) if reject
    )
    promise

  @addSlide = (assessmentId, slideId, value, timeTaken, callback)->
    promise = new tfPromise((resolve, reject)->
      try
        Traitify.put("/assessments/#{assessmentId}/slides/#{slideId}", JSON.stringify({"response":value, "time_taken": timeTaken}), (data)->
            callback(data) if callback
            resolve(data) if resolve
        )
      catch error
          reject(error) if reject
    )
    promise

  @addSlides = (assessmentId, values, callback)->
    promise = new tfPromise((resolve, reject)->
      try
        Traitify.put("/assessments/#{assessmentId}/slides", JSON.stringify(values), (data)->
            callback(data) if callback
            resolve(data) if resolve
        )
      catch error
          reject(error) if reject
    )
    promise
    
  @getPersonalityTypes = (id, options, callback)->
    promise = new tfPromise((resolve, reject)->
      try
        options ?= Object()
        options.image_pack ?= "linear"
        params = Array()
        
        for key in Object.keys(options)
          params.push("#{key}=#{options[key]}")
        
        Traitify.get("/assessments/#{id}/personality_types?#{params.join("&")}", (data)->
            callback(data) if callback
            resolve(data) if resolve
        )
      catch error
        reject(error) if reject
    )
    promise

  @getPersonalityTraits = (id, options, callback)->
    promise = new tfPromise((resolve, reject)->
      try 
        Traitify.get("/assessments/#{id}/personality_traits/raw", (data)->
          callback(data) if callback
          resolve(data) if resolve
        )
      catch error
        reject(error) if reject
    )
    promise

  @getPersonalityTypesTraits = (assessmentId, personalityTypeId, callback)->
    promise = new tfPromise((resolve, reject)->
      try
        Traitify.get("/assessments/#{assessmentId}/personality_types/#{personalityTypeId}/personality_traits", (data)->
          callback(data) if callback
          resolve(data) if resolve
        )
      catch error
        reject(error) if reject
    )
    promise
    
  
  @ui = Object()
  
  this
)()
