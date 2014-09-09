Bldr = (selector, options)->  
  Builder = Object()
  Builder.nodes = Object()
  Builder.nodes.add = (name, content)->
    Builder.nodes[name] = content
  Builder.nodes.get = (name)->
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

  Builder.partials.a = (attributes)->
    @make("a", attributes)
    
  Builder.partials.div = (attributes)->
    @make("div", attributes)

  Builder.partials.img = (attributes)->
    @make("img", attributes)

  Builder.partials.i = (attributes)->
    @make("i", attributes)
    
  Builder.partials.add = (name, localNode)->
    if typeof name == "object"
      Builder.partials[name[0]].push(localNode)
    else
      Builder.partials[name] = localNode
    
  Builder.partials.render = (name, options)->
    Builder.partials[name](options)
  
  Builder.partials.addDiv = (name, attrs, innerHTML)->
    if typeof attrs != "object"
      innerHTML = attrs
      attrs = Object()

    @addTag("div", name, attrs, innerHTML)
  
  Builder.partials.addImg = (name, attrs)->      
    @addTag("img", name, attrs)
  
  Builder.partials.addTag = (tag, fullName, attrs, innerHTML)->
    attrs ?= Object()
    arrayType = false
    name = fullName
    if typeof fullName == "object"
      arrayType = true
      name = fullName = fullName[0]
      
    splitFullName = fullName.split(".")
    if splitFullName.length != 1
      name = splitFullName[splitFullName.length - 1]
    if !attrs.class
      attrs.class = Builder.helpers.toDash(name)
    currentNode = Builder.partials[tag](attrs)
    if arrayType
      Builder.nodes[fullName] ?= Array()
      Builder.nodes[fullName].push(currentNode)
    else
      Builder.nodes[fullName] = currentNode
    if innerHTML
      currentNode.innerHTML = innerHTML
    currentNode.appendTo = (target)->
      if typeof target == "object"
        fullName = target[0]
        index = target[1]
        Builder.nodes[fullName][index].appendChild(@)
      else
        Builder.nodes[target].appendChild(@)
    currentNode.append = (target)->
      if typeof target == "object"
        fullName = target[0]
        index = target[1]
        @appendChild(Builder.nodes[target][index])
      else
        @appendChild(Builder.nodes[target])
    currentNode
  
  Builder.partials.data = (name, value)->
    if name && value
      Builder.data[name] = value
    else if name
      Builder.data[name]
    else
      Builder.data
  
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