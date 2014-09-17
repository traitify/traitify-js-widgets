require = (file, options)->
  options ?= Object()
  document.write("<script src='#{file}' #{if options.cover then "data-cover"}></script>")

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

require("../compiled/tests/base.js")

locationHash = Object()
location.search.replace("?", "").split("&").forEach((value)->
  value = value.split("=")
  locationHash[value[0]]=value[1]
)