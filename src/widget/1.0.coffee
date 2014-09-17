class Data
  sources: Object()
  fetch: (name)->
    @source[name]()
  addDataSource: (name, dataSource)->
    @sources[name] = dataSource

class Libary
  store: Object()
  add: (name, item)->
    store[name] item
  get: (name)->
    store[name]
  
class Tags
  libary: new Library()
  div: (name, options)->
    @addTag("div", )
  tag: (name, tag, attributes, content)->
    element = document.createElement(type)
    for attributeName of attributes
      element.setAttribute(attributeName, attributes[attributeName])
    @library.add(name, element)

class Views
  tags: new Tags()
  
class Widget
  views: new Views()
  library: new Library()
  constructor: (@selector)->
    @nodes.main = document.querySelector(@selector)
  