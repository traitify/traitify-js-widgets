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
  version: "2.0.0 HN"
  views: new Views()
  library: new Library()
  constructor: (@selector)->
    @nodes.main = document.querySelector(@selector)
  