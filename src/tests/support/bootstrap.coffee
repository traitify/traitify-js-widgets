Number::times = (fn) ->
  i = 0
  for [0..@valueOf()]
    fn(i)
    i++

UUID = ->
  s4 = ->
    return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
  s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()

waitUntil = (item)->
  promise = new SimplePromise((resolve, reject)->
    i = 0
    timer = setInterval(->
      storedValue = item()
      if storedValue || i == 5
        clearInterval(timer)
        resolve(storedValue)
      i += 1
    , 100)
  )

HTMLElement.prototype.trigger = (eventType, options)->
  switch eventType
    when "click"
      event = document.createEvent("MouseEvent")
      event.initMouseEvent('click', true, true, window, 1, 0, 0)
      @dispatchEvent(event)
    when "touch"
      event = document.createEvent('UIEvent')
      event.changedTouches = [{clientX: 10, clientY: 10}];
      event.initUIEvent('touchstart', true, true)
      @dispatchEvent(event)
      event = document.createEvent('UIEvent')
      event.changedTouches = [{clientX: 10, clientY: 10}];
      event.initUIEvent('touchend', true, true)
      @dispatchEvent(event)
    else
      event = document.createEvent("Event");
      event.initEvent(eventType, true, true)
      @dispatchEvent(event)

class FactoryBoy
  constructor: ->
    @factoryStore = Object()
    @buildIndex = Object()
    @factories() if @factories
    @
  getIndex: (key)->
    @buildIndex[key]
  factory: (key, hash)->
    @buildIndex[key] = 0
    @factoryStore[key] = hash
  build: (key, options)->
    if @factoryStore[key]
      @buildIndex[key] += 1
      @factoryStore[key](@, options, @buildIndex[key])
    else
      console.log("Your Factory #{key} Doesn't Exist")
