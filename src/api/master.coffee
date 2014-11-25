unless Array::map
  Array::map = (callback, thisArg) ->
    T = undefined
    A = undefined
    k = undefined
    throw new TypeError(" this is null or not defined")  unless this?
    O = Object(this)
    len = O.length >>> 0
    throw new TypeError(callback + " is not a function")  if typeof callback isnt "function"
    T = thisArg  if thisArg
    A = new Array(len)
    k = 0
    while k < len
      kValue = undefined
      mappedValue = undefined
      if k of O
        kValue = O[k]
        mappedValue = callback.call(T, kValue, k, O)
        A[k] = mappedValue
      k++
    A


unless Array::filter
  Array::filter = (fun) -> #, thisp
    "use strict"
    throw new TypeError()  if this is undefined or this is null
    t = Object(this)
    len = t.length >>> 0
    throw new TypeError()  if typeof fun isnt "function"
    res = []
    thisp = arguments[1]
    i = 0

    while i < len
      if i of t
        val = t[i] # in case fun mutates this
        res.push val  if fun.call(thisp, val, i, t)
      i++
    res

unless Array::indexOf
  Array::indexOf = (elt) -> #, from
    len = @length >>> 0
    from = Number(arguments[1]) or 0
    from = (if (from < 0) then Math.ceil(from) else Math.floor(from))
    from += len  if from < 0
    while from < len
      return from  if from of this and this[from] is elt
      from++
    -1
unless console
    console = {
     log: ->

    }


unless Object.keys
      Object.keys = (->
          "use strict"
          hasOwnProperty = Object::hasOwnProperty
          hasDontEnumBug = not (toString: null).propertyIsEnumerable("toString")
          dontEnums = [
                "toString"
                "toLocaleString"
                "valueOf"
                "hasOwnProperty"
                "isPrototypeOf"
                "propertyIsEnumerable"
                "constructor"
              ]
          dontEnumsLength = dontEnums.length
          (obj) ->
            throw new TypeError("Object.keys called on non-object")  if typeof obj isnt "object" and (typeof obj isnt "function" or obj is null)
            result = []
            prop = undefined
            i = undefined
            for prop of obj
              result.push prop  if hasOwnProperty.call(obj, prop)
            if hasDontEnumBug
              i = 0
              while i < dontEnumsLength
                result.push dontEnums[i]  if hasOwnProperty.call(obj, dontEnums[i])
                i++
            result
        )()
# Build a New Widget.
#
# @example SimplePromise()
#   response = new SimplePromise((resolve, reject)->
#     try
#      # something async
#      resolve(data)
#     catch error
#       reject(error)
#   )
#   response.then((dataResolved)->
#     console.log(dataResolved)
#   )
#   response.catch((dataRejected)->
#     console.log(dataRejected)
#   )
# @callback Do something Async and Resolve or Reject
#
SimplePromise = (callback)->
    localPromise = Object()
    localPromise.then = (callback)->
      localPromise.thenCallback = callback
      if localPromise.resolved
        localPromise.thenCallback(localPromise.data)
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

# Traitify's Api Client.
#
# @example How to create an Instance of the Client
#   client = new ApiClient()
#   client.setPublicKey("your-key-here")
#   client.getPersonalityTypes("an-assessment-id-you-provide").then((data)->
#     console.log(data)
#   )
#
class ApiClient
  constructor: ->
    # Your Api Host (sets to https://api.traitify.com by default)
    @host = "https://api.traitify.com"
    # Your Api Version (sets to v1 by default)
    @version = "v1"
    if navigator.userAgent.match(/MSIE 8/) || navigator.userAgent.match(/MSIE 9/)
        @oldIE = true
    else
        @oldIE = false

    # Whether you want CamelCase Responses (sets to false by default)
    @beautify = false  

    # XHR sets itself to XMLHttpRequest (This allows you to throw your own source of data if you wish)
    @XHR = XMLHttpRequest
    @

  # Set the Json Objects to have Camel Case Keys
  #
  # @example setBeautify(value)
  #   Traitify.setBeautify(true)
  #   Traitify.getPersonalityTypes("assessmentId").then((data)->
  #     console.log(data)  
  #   )
  #
  #
  # @param [Boolean] BeautifyMode
  #
  #
  online: ->
    navigator.onLine

  setBeautify: (mode)->
    @beautify = mode
    @

  # Set the Host for all Api Calls
  #
  # @example setHost(value)
  #   Traitify.setHost("api-sandbox.traitify.com")
  # @param [String] ApiHost
  #
  setHost: (host) ->
    host = host.replace("http://", "").replace("https://", "")
    host = "https://#{host}"
    @host = host
    this

  # Set the Public Key for all Api Calls
  #
  # @example setPublicKey(value)
  #   Traitify.setPublicKey("your-public-key")
  # @param [String] PublicApiKey
  #
  setPublicKey: (key) ->
    @publicKey = key
    this

  # Set the Version for all Api Calls
  #
  # @example setVersion(value)
  #   Traitify.setVersion("v1")
  # @param [String] ApiVersion
  #
  setVersion: (version) ->
    @version = version
    this

  # Make an ajax vanilla ajax request to the api with credentials 
  #
  # @example ajax(method, path, callback, params)
  #   Traitify.ajax("GET", "/decks", function(data){
  #     console.log(data)
  #   })
  # @param [String] Method
  # @param [String] Path
  # @param [Function] Callback
  # @param [String] Params
  #
  ajax: (method, path, callback, params)-> 
    beautify = @beautify
    url = "#{@host}/#{@version}#{path}"
    xhr = new @XHR()
    if "withCredentials" of xhr
      # XHR for Chrome/Firefox/Opera/Safari.
      xhr.open method, url, true
    else unless typeof XDomainRequest is "undefined"
      if @oldIE
        if url.indexOf("?") == -1
          url += "?authorization=#{@publicKey}"
        else
          url += "&authorization=#{@publicKey}"

      # XDomainRequest for IE.
      xhr = new XDomainRequest()
      xhr.open method, url
    else
      return new SimplePromise((resolve, reject)->
        reject("CORS is Not Supported By This Browser")
      )
      
    xhr

    if xhr && !@oldIE
      xhr.setRequestHeader "Authorization", "Basic " + btoa(@publicKey + ":x")

      xhr.setRequestHeader "Content-type", "application/json"
      xhr.setRequestHeader "Accept", "application/json"
    that = this
    online = @online()
    oldIE = @oldIE
    promise = new SimplePromise((resolve, reject)->
      that.reject = reject

      unless online
        return that.reject()
      try
        xhr.onload = ->
          if xhr.status == 404
            that.reject(xhr.response)
          else
            if oldIE
                data = xhr.responseText
            else
                data = xhr.response
            if beautify
              data = data.replace(/_([a-z])/g, (m, w)->
                return w.toUpperCase()
              ).replace(/_/g, "")
            data = JSON.parse(data)
            callback(data) if callback
            that.resolve = resolve
            that.resolve(data)
        xhr.send JSON.stringify(params)
        xhr
      catch error
        that.reject(error)
    )

    promise

  # Make a put request to the api with credentials 
  #
  # @example put(path, callback, params)
  #   responses = [
  #     {
  #       "slide_id":"slide-id-goes-here", 
  #       "value":true,
  #       "time_taken":1000
  #     }
  #   ]
  #   Traitify.put("/slides", responses, function(data){
  #     console.log(data)
  #   })
  # @param [String] Path
  # @param [Function] Callback
  # @param [String] Params
  #
  put: (path, params, callback) ->
    if @oldIE
      @ajax "POST", path, callback, params
    else
      @ajax "PUT", path, callback, params

  # Make a get request to the api with credentials 
  #
  # @example get(path, callback, params)
  #   Traitify.get("/decks", function(data){
  #     console.log(data)
  #   })
  # @param [String] Path
  # @param [Function] Callback
  # @param [String] Params
  #
  get: (path, callback) ->
    @ajax "GET", path, callback, ""

  # Get Decks
  #
  # @example getDecks(callback)
  #   Traitify.getDecks(function(data){
  #     console.log(data)
  #   })
  #   # or use the Promise
  #   Traitify.getDecks().then((data)->
  #     console.log(data)
  #   )
  # @param [Function] Callback
  #
  getDecks: (callback)->
    @get("/decks", callback)

  # Get Slides
  #
  # @example getSlides(assessmentId, callback)
  #   Traitify.getSlides("your-assessment-id", function(data){
  #     console.log(data)
  #   })
  #   # or use the Promise
  #   Traitify.getSlides("your-assessment-id").then((data)->
  #     console.log(data)
  #   )
  # @param [Function] Callback
  #
  getSlides: (assessmentId, callback)->
    @get("/assessments/#{assessmentId}/slides", callback)

  # Add Slide
  #
  # @example addSlide(assessmentId, slideId, value, timeTaken, callback)
  #   Traitify.addSlide("your-assessment-id", "your-slide-id", true, 1000, function(data){
  #     console.log(data)
  #   })
  # @param [String] AssessmentId
  # @param [String] SlideId
  # @param [String] Value
  # @param [String] TimeTaken
  # @param [Function] Callback
  #
  addSlide: (assessmentId, slideId, value, timeTaken, callback)->
    @put("/assessments/#{assessmentId}/slides/#{slideId}", {"response":value, "time_taken": timeTaken}, callback)

  # Add Slides
  #
  # @example addSlides(assessmentId, slideId, value, timeTaken, callback)
  #   responses = [
  #     {
  #       "slide_id":"slide-id-goes-here", 
  #       "value":true,
  #       "time_taken":1000
  #     }
  #   ]
  #   Traitify.addSlide("your-assessment-id", responses, function(data){
  #     console.log(data)
  #   })
  #
  # @param [String] AssessmentId
  # @param [String] SlideId
  # @param [String] Value
  # @param [String] TimeTaken
  # @param [Function] Callback
  #
  addSlides: (assessmentId, values, callback)->
    @put("/assessments/#{assessmentId}/slides", values, callback)

  # Get Personality Types
  #
  # @example getPersonalityTypes(assessmentId, options, callback)
  #   options = {
  #     "image_pack":"flat"
  #   }
  #   Traitify.getPersonalityTypes("your-assessment-id", options, function(data){
  #     console.log(data)
  #   })
  #   # or use the Promise
  #   Traitify.getPersonalityTypes("your-assessment-id", options).then((data)->
  #     console.log(data)
  #   )
  #
  # @param [String] AssessmentId
  # @param [String] Options
  # @param [Function] Callback
  #
  getPersonalityTypes: (id, options, callback)->
    options ?= Object()
    options.image_pack ?= "linear"
    params = Array()
        
    for key in Object.keys(options)
      params.push("#{key}=#{options[key]}")
        
    @get("/assessments/#{id}/personality_types?#{params.join("&")}", callback)

  # Get Personality Traits
  #
  # @example getPersonalityTraits(assessmentId, options, callback)
  #   Traitify.getPersonalityTraits("your-assessment-id", options, function(data){
  #     console.log(data)
  #   })
  #   # or use the Promise
  #   Traitify.getPersonalityTraits("your-assessment-id", options).then((data)->
  #     console.log(data)
  #   )
  #
  # @param [String] AssessmentId
  # @param [Function] Callback
  #
  getPersonalityTraits: (id, options, callback)->
    @get("/assessments/#{id}/personality_traits/raw", callback)

Traitify = new ApiClient()
