Bldr = (selector, options)->  
  Builder = Object()
  Builder.nodes = Object()
  Builder.nodes.add = (name, content)->
    Builder.nodes[name] = content
  
  Builder.nodes.addDiv = (name, attrs, innerHTML)->
    Builder.nodes.addTag("div", name, attrs, innerHTML)
  
  Builder.nodes.addImg = (name, attrs)->
    Builder.nodes.addTag("img", name, attrs)
  
  Builder.nodes.addTag = (tag, name, attrs, innerHTML)->
    attrs ?= Object()
    if !attrs.class
      attrs.class = Builder.helpers.toDash(name)
    Builder.nodes[name] = Builder.partials[tag](attrs)
    if innerHTML
      Builder.nodes[name].innerHTML = innerHTML
    Builder.nodes[name]
    
  Builder.states = Object()
  Builder.data = Object()
  Builder.states.values = Object()
  Builder.states.add = (name, value)->
    Builder.states.values[name] = value ? false
    Builder.states[name] = (value)->
      if value?
        Builder.states.values[name] = value
      else
        Builder.states.values[name]
      
  Builder.states.add("logging")
  
  Builder.selector = selector
  
  if typeof options == "undefined"
    options = Object()

  if navigator.userAgent.match(/iPad/i)
    Builder.device = "ipad"

  if navigator.userAgent.match(/iPhone/i)
   Builder.device = "iphone"

  if navigator.userAgent.match(/Android/i)
    Builder.device = "android"

  if navigator.userAgent.match(/BlackBerry/i)
    Builder.device = "blackberry"

  if navigator.userAgent.match(/webOS/i)
    Builder.device = "webos"

  if typeof selector != "string"
    Builder.nodes.main = document.createElement("div")
    document.getElementsByTagName("body")[0].appendChild(Builder.nodes.main)
  else if  selector.indexOf("#") != -1
    selector = selector.replace("#", "")
    
    Builder.nodes.main = document.getElementById(selector)
  else
    selector = selector.replace(".", "")
    selectedObject = document.getElementsByClassName(selector)
    Builder.nodes.main = if selectedObject then selectedObject[0] else null

  if !Builder.nodes.main
    console.log("YOU MUST HAVE A TAG WITH A SELECTOR FOR THIS TO WORK")
    return false
  
  Builder.data = Object()
  
  Builder.partials = Object()
  Builder.partials.make = (elementType, attributes)->
    element = document.createElement(elementType)

    for attributeName of attributes
      element.setAttribute(attributeName, attributes[attributeName])

    element

  Builder.partials.div = (attributes)->
    @make("div", attributes)

  Builder.partials.img = (attributes)->
    @make("img", attributes)

  Builder.partials.i = (attributes)->
    @make("i", attributes)
    
  Builder.partials.add = (name, callback)->
    Builder.partials[name] = callback
    
  Builder.partials.render = (name, options)->
    Builder.partials[name](options)
    
  #Callbacks
  Builder.callbacks = Object()
  Builder.callbacks.triggered = Object()
  Builder.callbacks.trigger = (name)->
    if Builder.callbacks[name]
      Builder.callbacks[name](Builder)
    else
      Builder.callbacks.triggered[name] = true
      
  Builder.callbacks.add = (name)->
    Builder["on#{name}"] = (callback)->
      if Builder.callbacks.triggered[name]
        callback()
      else
        Builder.callbacks[name] = callback
  Builder.render = (widgetNodes)->
      Builder.nodes.main.appendChild(widgetNodes)
      
  Builder.helpers = Object()
  Builder.helpers.toDash = (text)->
    if text
      text.replace(/([A-Z])/g, ($1)-> "-"+$1.toLowerCase())

  Builder.events = Object()
  Builder.events.stack = Array()
  Builder.events.add = (callback)->
    Builder.events.stack.push(callback)
  
  
  Builder.initializationEvents = Array()
  
  Builder.initialization = Object()
  Builder.initialization.events = Object()
  Builder.initialization.events.stack = Array()
  
  Builder.initialization.events.add = (description, callback)->
    if callback
      Builder.initialization.events.stack.push({description: description, callback: callback})
  
  Builder.initialize = ()->
    stack = Builder.initialization.events.stack
    for event in stack
      if Builder.states.logging()
        Builder.log(event.description)
        try
          event.callback()
        catch error
          Builder.log(error.message)
      else    
        event.callback()
        
    for event in Builder.events.stack
      event()
      
  Builder