require = (file, options, type)->
  options ?= Object()
  if [type, options].indexOf("css") != -1
    document.write("<style href='#{options}.css'  rel='stylesheet' ></style>")
  else
    document.write("<script src='#{file}.js' #{if options.cover then "data-cover"}></script>")

div = (attrs)->
  tag("div", attrs)
link = (href, attrs)->
  attrs ?= Object()
  attrs.href = href
  attrs.rel = "stylesheet" 
  tag("link", attrs)
tag = (type, attrs)->
  attrs ?= Object()
  localTag = document.createElement(type)
  for key in Object.keys(attrs)
    localTag.setAttribute(key, attrs[key])
  document.write(localTag.outerHTML)

Number::times = (fn) ->
  for [0..@valueOf()]
    fn(_i)

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
      event = document.createEvent("MouseEvent");
      event.initMouseEvent('click', true, true, window, 1, 0, 0)
      this.dispatchEvent(event)
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

class TestSuite
  constructor: ->
    @versions = Object()
  add: (@version, @setup)->
    @versions[@version] = @setup
  defaultSuite: (@version)->
    @defaultVersion = @version
  run: ->
    if locationHash["suite"]
      @versions[locationHash["suite"]]()
    else
      @versions[@defaultVersion]()
testSuite = new TestSuite()

require("../compiled/tests/support/spec_helper")

locationHash = Object()
location.search.replace("?", "").split("&").forEach((value)->
  value = value.split("=")
  locationHash[value[0]]=value[1]
)