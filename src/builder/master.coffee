# Base Helpers with the ability to add More helpers.
#
# @example How use Helpers
#   helpers = new Helpers()
#   helpers.add("removeXHR", ->
#     window.XMLHttpRequest = Object()
#   )
#
class Helpers
  # toDash
  #
  # @example toDash(text)
  #   new Helpers().toDash('veryCoolThing') # very-cool-thing
  #
  # @param [String] Text the string that you wish to conver
  # @return [String] a lowercase version of the string with dashes
  #
  toDash: (text)->
    if text
      text.replace(/([A-Z])/g, ($1)-> "-"+$1.toLowerCase())
  # hexToRGB
  #
  # @example hexToRGB(hex)
  #   new Helpers().hexToRGB('8d834f') # [141, 131, 79]
  #
  # @param [String] Hex the string that you wish to convert
  # @return [Array<Numbers>] The 3 decimal values of rgb
  #
  hexToRGB: (hex)->
    if hex.length != 0
      matches = hex.match(/([\da-f]{2})([\da-f]{2})([\da-f]{2})/i);
      matches.slice(1).map((m)-> parseInt(m, 16) )
  # add
  #
  # @example add(name, helper)
  #   helpers = new Helpers()
  #   helpers.add("noNegative", (negative)->
  #     if negative < 0 
  #        negative * -1
  #   )
  #
  # @param [String] Name for the method
  # @param [Function] Process for the Helper
  # @return [Function] An instance of the added helper
  #
  add: (name, helper)->
    @[name] = helper

# Base Library for consistent storage and retrieval.
#
# @example How to use Library
#   libary = new Library()
#   library.add("userName", "Carson Wright")
#   library.get("userName") # "Carson Wright"
#
class Library
  constructor: ->
    @store = Object()
  # Add
  #
  # @example add(name, helper)
  #   library = new Library()
  #   library.add("thisName", "item here")
  #
  # @param [String] Name for the data
  # @param [String, Object, Function] Item to store
  # @return [Object, String, Number, Function] The stored item
  #
  add: (name, item)->
    @store[name] = item
  # Get
  #
  # @example get(name)
  #   library = new Library()
  #   library.get("thisName")
  #
  # @param [String] Name for the data
  # @param [String, Object, Function] Data to store
  # @return [Object, String, Number, Function] An instance of the item store
  #
  get: (name)->
    if name
      @store[name]
    else
      @store

# Base Callbacks Logic for simple Callback addition, setting, and triggering.
#
# @example How use Callbacks
#   main = Object()
#   callbacks = new Callbacks(main)
#   callbacks.add("SitDown")
#   main.sitDown = ->
#     #Do some sitting down
#     callbacks.trigger("SitDown")
#   main.onSitDown(->
#     console.log("Triggered Sit Down Callback")  
#   )
#
class Callbacks
  # Constructor
  #
  # @example constructor(name)
  #   parent = Object()
  #   parent.callbacks = new Callbacks(parent)
  #   parent.callbacks.add("someCallback")
  # @param [String] Name for the callback
  #
  constructor: (@parent)->
    @library = new Library()
    @states = new Library()
  # Trigger
  #
  # @example trigger(name)
  #   callbacks = new Callbacks()
  #   callbacks.trigger("someCallback")
  #
  # @param [String] Name for the data
  # @param [String, Object, Function] Data to store
  #
  trigger: (name)->
    if @library.get(name)
      @library.get(name)(@)
    else
      @states.add(name, true)
  # Add
  #
  # @example add(name)
  #   callbacks = new Callbacks()
  #   callbacks.add("someCallback")
  # @param [String] Name for the callback
  #
  add: (name)->
    states = @states
    library = @library
    @parent["on#{name}"] = (callback)->
      if states.get(name)
        callback()
      else
        library.add(name, callback)

# Tags Logic for Building tags with additional helpers
#
# @example How use Tags
#   tags = new Tags()
#   tags.div("sitDown", "data-id":"your-id", "Div with id attached")
#   tags.get("sitDown") # <div class="sit-down" data-id="your-id">Div with id attached</div>
#
#   tags.img("getUp", "sitting-up.jpg", "data-id":"your-id")
#
class Tags
  constructor: ->
    @library = new Library()
  # Div
  #
  # @example div(name, options, content)
  #   tags = new Tags()
  #   tags.div("someTag", {style: {color: "blue"}}, "This is an awesome tag!")
  # @param [String] Name for the tag
  # @param [Object] Options for the tag
  # @param [String] Content for the tag
  #
  div: (name, options, content)->
    if typeof options is "string"
      content = options
      options = Object()
    @tag(name, "div", options, content)
  # Img
  #
  # @example img(name, src, options)
  #   tags = new Tags()
  #   tags.img("someTag", "your-image.jpg", "This is an awesome tag!")
  # @param [String] Name for the tag
  # @param [String] Src for the tag
  # @param [Object] Options for the tag
  #
  img: (name, src, options)->
    options ?= Object()
    options.src = src
    @tag(name, "img", options)
  # I
  #
  # @example i(name, options)
  #   tags = new Tags()
  #   tags.i("someTag", "This is an awesome tag!")
  # @param [String] Name for the tag
  # @param [Object] Options for the tag
  # @param [String] Content for the tag
  #
  i: (name, options, content)->
    @tag(name, "i", options, content)
  # Get
  #
  # @example get(name, options)
  #   tags = new Tags()
  #   tags.get("someTag")
  # @param [String] Name for the tag
  #
  get: (name)->
    @library.get(name)

  # Tag
  #
  # @example tag(fullName, type, options, content)
  #   tags = new Tags()
  #   tags.tag("someTag", "div", {class: "blue"}, This is an awesome tag!")
  # @param [String] fullName for the tag
  # @param [String] type for the tag
  # @param [Object] Options for the tag 
  # @param [String] Content for the tag
  #
  tag: (fullName, tag, attributes, content)->
    element = document.createElement(tag)
    tagIsList = false
    if typeof fullName == "object"
      fullName = fullName[0]
      tagIsList = true
    if fullName.indexOf(".") != -1
      name = fullName.split(".")
      name = name[name.length - 1]
    else
      name = fullName
    attributes ?= Object()
    className = (new Helpers()).toDash(name)
    attributes.class ?= ""
    attributes.class = if attributes.class.length == 0 then className else " #{className}"
    for attributeName of attributes
      if attributeName != "style"
        element.setAttribute(attributeName, attributes[attributeName])
      else
        for styleName in Object.keys(attributes["style"])
          element.style[styleName] = attributes[attributeName][styleName]
    if tagIsList 
      unless @library.get(fullName)
        @library.add(fullName, Array())
      @library.get(fullName).push(element)
    else
      @library.add(fullName, element)
    element.library = @library
    element.appendTo = (target)->
      if typeof target == "object"
        fullName = target[0]
        index = target[1]
        @library.store[fullName][index].appendChild(@)
      else
        @library.get(target).appendChild(@)

    if content
      element.innerHTML = content
    element

# Data Logic for storing data including a counter helper
#
# @example How use Data
#   data = new Data()
#   data.add("chairs", 0)
#   data.counter("chairs").up()
#   data.get("chairs") # 1
#   data.counter("chairs").down()
#   data.get("chairs") # 0
#
class Data extends Library
  # Counter
  #
  # @example counter(name)
  #   data = new Data()
  #   data.counter("someData").up()
  # @param [String] name for data
  #
  counter: (name)->
    store = @store
    up: (number)->
      store[name] += number || 1
    down: (number)->
      store[name] -= number || 1

# View Logic for building, and storing Views
#
# @example How to use Views
#   view = new View()
#   view.add("room", ->
#     @div("room")
#     @div("room.chairs", "data-number":6, "This Room Has 6 Chairs").appendTo("room") # <div class="chairs" ..></div>
#     for [0..6]
#       @div(["room.chairs.chair"], "This is a Chair").appendTo("room.chairs") # <div class="chair" ..></div>
#     @div("table", "This Room Has 1 table").appendTo("room") 
#     @tags.get("room") # return the room with table and chairs
#   )
#
class Views
  constructor: ->
    @library = new Library()
    @tags = new Tags()
  # Add
  #
  # @example add(name, view)
  #   views = new Views()
  #   views.add("someView", ->
  #     @div("everythingIsAwesome")
  #   )
  # @param [String] Name for view
  # @param [Function] Callback for view
  #
  add: (name, view)->
    @library.add(name, view)
  # Render
  #
  # @example render(name, options)
  #   views = new Views()
  #   views.add("someView", (o)->
  #     @div("everythingIsAwesome", o.content)
  #   )
  #   views.render("someView", content: "Everything is awesome!")
  #   )
  # @param [String] Name for view
  # @param [Object] Options for rendering view
  #
  render: (name, options)->
    if @library.get(name)
      @library.get(name).call(@, options)

# Stack Logic
#
# @example How use Stack
#   stack = new Stack()
#   stack.events.add("startThings", ->
#     console.log("started Things")
#   )
#   stack.trigger("startThings")
#
class Stack 
  constructor: ->
    @events = new Library()
  # Trigger
  #
  # @example trigger(name)
  #   stack = new Stack()
  #   stack.add("awesomeness", ->
  #     console.log("awesomeness")
  #   )
  #   stack.trigger("awesomeness")
  # @param [String] Name for stack
  #
  trigger: (name)->
    if name
      @events.get(name)()
    else
      events = @events.get()
      for eventName in Object.keys(events)
        event = events[eventName]
        event()

# Actions Logic
#
# @example How use Actions
#   actions = new Actions()
#   actions.add("goRunning", (o)->
#     console.log("Going Running #{o.laps}")
#   )
#   stack.trigger("goRunning", laps: 10)
#
class Actions extends Library
  # Trigger
  #
  # @example trigger(name)
  #   actions = new Actions()
  #   actions.add("awesomeness", (o)->
  #     console.log("awesomeness score #{o.score}")
  #   )
  #   actions.trigger("awesomeness", score: 10)
  # @param [String] Name for stack
  #
  trigger: (name, options)->
    if @get(name)
      @get(name)(options)

# States Logic
#
# @example How to use States
#   states = new States()
#   states.add("running", true)
#   states.get("running") # true
#
class States extends Library
  # Add
  #
  # @example add(name, value)
  #   states = new States()
  #   states.add("awesomeness") # false
  #   states.add("awesomenessTwo", true) # true
  # @param [String] Name for stack
  # @param [Boolean] Value for stack
  #
  add: (name, value = false)->
    super(name, value)
  set: (name, value)->
    @add(name, value)

# Base to building a Widget
#
# @example How to use Widget
#   widget = new Widget(target)
#   # Data Business Logic
#   widget.run()
# param [String] Target an html selector
#
class Widget
  version: "3.0.0 HNA"
  constructor: (@target)->
    @views = new Views()
    @library = new Library()
    @data = new Data()
    @dataDependencies = Array()
    @states = new States()
    @callbacks = new Callbacks(@)
    @helpers = new Helpers()
    @actions = new Actions()
    @initialization = new Stack()
    @views.data = @data
    @userAgent = Traitify.ui.userAgent
    @views.tags.library.add("main", document.querySelector(@target))
    if @userAgent.match(/iPad/i)
      @device = "ipad"
    if @userAgent.match(/iPhone/i)
      @device = "iphone"
    if @userAgent.match(/Android/i)
      @device = "android"
    if @userAgent.match(/BlackBerry/i)
      @device = "blackberry"
    if @userAgent.match(/webOS/i)
      @device = "webos"
    @
  # dataDependency
  #
  # @example dataDependency(dependencyName)
  #   widget = new Widget(".example-selector")
  #   states.dataDependency("SomeData")
  # @param [String] DependencyName for widget
  #
  dataDependency: (dependencyName)->
    @dataDependencies.push(dependencyName)
  # Nodes
  #
  # @example nodes(name)
  #   widget = new Widget(".example-selector")
  #   states.nodes("someNode")
  # @param [String] Name for node in widgets
  #
  nodes: (name)->
    if name
      @views.tags.library.get(name)
    else
      @views.tags.library.store
  # Run
  #
  # @example run()
  #   widget = new Widget(".example-selector")
  #   states.run() # Triggers all initialization events
  #
  run: ->
    @initialization.trigger()
    
  	