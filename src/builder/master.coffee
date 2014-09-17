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
    @store[name]

class Callbacks
  constructor: ->
    @library = new Library()
    @states = new Library()
  trigger: (name)->
    if @library.get(name)
      @library.get(name)(@)
    else
      @states.add(name, true)
  add: (name)->
    @["on#{name}"] = (callback)->
      if @states.get(name)
        callback()
      else
        @library.add(name, callback)

class Tags
  constructor: ->
    @library = new Library()
  div: (name, options, content)->
    if typeof options is "string"
      content = options
      options = Object()
    @tag(name, "div", options, content)
  tag: (name, tag, attributes, content)->
    element = document.createElement(tag)
    element.className = (new Helpers()).toDash(name)
    for attributeName of attributes
      element.setAttribute(attributeName, attributes[attributeName])
    @library.add(name, element)
    element

class Views
  constructor: ->
    @tags = new Tags()

class Widget
  version: "2.0.0 HN"
  constructor: (@selector)->
    @views = new Views()
    @library = new Library()
    @views.tags.library.add("main", document.querySelector(@selector))
    
  	