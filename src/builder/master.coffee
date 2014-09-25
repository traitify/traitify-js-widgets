#########################################################################################################################################################
#                                                                                                                                                       #
#   ____        _ _     _             ____                                                                                                              #
#  | __ ) _   _(_) | __| | ___ _ __  |___ \                                                                                                             #
#  |  _ \| | | | | |/ _` |/ _ \ '__|   __) |                                                                                                            #
#  | |_) | |_| | | | (_| |  __/ |     / __/                                                                                                             #
#  |____/ \__,_|_|_|\__,_|\___|_|    |_____|                                                                                                            #
#   _   _ _ _     _ _            _                 _   _             _                                                                                  #
#  | | | (_) | __| (_) __ _ _ __(_)_ __ ___       | \ | | ___   __ _| | _____  ___                                                                      #
#  | |_| | | |/ _` | |/ _` | '__| | '_ ` _ \      |  \| |/ _ \ / _` | |/ / _ \/ __|                                                                     #
#  |  _  | | | (_| | | (_| | |  | | | | | | |     | |\  | (_) | (_| |   <  __/\__ \                                                                     #
#  |_| |_|_|_|\__,_|_|\__, |_|  |_|_| |_| |_|     |_| \_|\___/ \__,_|_|\_\___||___/                                                                     #
#                     |___/                                                                                                                             #
#                                                                                                                                                       #
#########################################################################################################################################################
#                                                                                                                                                       #
#  Hildigrim Noakes                                                                                                                                     #
#  Its surname, Noakes, is from:                                                                                                                        #
#  Shire hobbits of the working class. The name is derived from a place of dwelling and means 'at the oak' or 'dweller by the oak tree'.                #
#                                                                                                                                                       #
#  Hildigrim Took: (2840–2941) A distant relation of Bilbo and Frodo Baggins. The forth child of Gerontius the Old Took. He married Rosa Baggins.       #
#  Peregrin Took and Meriadoc Brandybuck are both his great-grandchildren.                                                                              #
#                                                                                                                                                       #
#########################################################################################################################################################    
class Helpers
  toDash: (text)->
    if text
      text.replace(/([A-Z])/g, ($1)-> "-"+$1.toLowerCase())
  hexToRGB: (hex)->
    if hex.length != 0
      matches = hex.match(/([\da-f]{2})([\da-f]{2})([\da-f]{2})/i);
      matches.slice(1).map((m)-> parseInt(m, 16) )
  add: (name, helper)->
    @[name] = helper

class Data
  constructor: ->
    @sources = new Library()
    @sources.data = new Library()
    @sources.fetch = (name)->
      if @data.get(name)
        data = @data.get(name)
        return new SimplePromise((resolve, reject)->
          resolve(data)
        )
      else
        dataPointer = @data
        source = @get(name)
        promise = new SimplePromise((resolve, reject)->
          source.then((localData)->
            dataPointer.add(name, localData)
            resolve(localData)
          ).catch((localError)->
            reject(localError)
          )
        )
        return promise

class Library
  constructor: ->
    @store = Object()
  add: (name, item)->
    @store[name] = item
  get: (name)->
    if name
      @store[name]
    else
      @store

class Callbacks
  constructor: (@parent)->
    @library = new Library()
    @states = new Library()
  trigger: (name)->
    if @library.get(name)
      @library.get(name)(@)
    else
      @states.add(name, true)
  add: (name)->
    states = @states
    library = @library
    @parent["on#{name}"] = (callback)->
      if states.get(name)
        callback()
      else
        library.add(name, callback)

class Tags
  constructor: ->
    @library = new Library()
  div: (name, options, content)->
    if typeof options is "string"
      content = options
      options = Object()
    @tag(name, "div", options, content)
  img: (name, src, options)->
    options ?= Object()
    options.src = src
    @tag(name, "img", options)
  i: (name, options)->
    @tag(name, "i", options)
  get: (name)->
    @library.get(name)

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

class Views
  constructor: ->
    @library = new Library()
    @tags = new Tags()
    
  add: (name, view)->
    @library.add(name, view)
  render: (name, options)->
    if @library.get(name)
      @library.get(name).call(@, options)

class Stack 
  constructor: ->
    @events = new Library()
  trigger: (name)->
    if name
      @events.get(name)()
    else
      events = @events.get()
      for eventName in Object.keys(events)
        event = events[eventName]
        event()

class Actions extends Library
  trigger: (name, options)->
    if @get(name)
      @get(name)(options)

class States extends Library
  add: (name, value)->
    value ?= false
    super(name, value)
  set: (name, value)->
    @add(name, value)

Traitify.ui.userAgent = navigator.userAgent

class Widget
  version: "2.0.0 HN"
  constructor: (@selector)->
    @views = new Views()
    @library = new Library()
    @data = new Data()
    @states = new States()
    @callbacks = new Callbacks(@)
    @helpers = new Helpers()
    @actions = new Actions()
    @initialization = new Stack()
    @views.data = @data
    @userAgent = Traitify.ui.userAgent
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
    @views.tags.library.add("main", document.querySelector(@selector))
    @

  nodes: (name)->
    if name
      @views.tags.library.get(name)
    else
      @views.tags.library.store
  run: ->
    @initialization.trigger()
    
  	