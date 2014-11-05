QUnit.module( "Testing UI", {
  setup: ->
    Traitify.XHR = MockRequest
    Traitify.setVersion("v1")
    Traitify.setHost("api-sandbox.traitify.com")
    Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

    unless document.querySelector(".widget .slide-deck")
      widget = document.createElement("div")
      widget.setAttribute("class", "widget")
      body.appendChild(widget)
    document.querySelector(".widget").innerHTML=""

  , teardown: ->
    Traitify.XHR = XMLHttpRequest
})

QUnit.asyncTest("Results Loader works", (assert)->
  builder = Traitify.ui.load("results", playedAssessment, ".widget")

  builder.onInitialize(->
    badge = document.querySelector(".widget .badges-container .badge")
    assert.equal(!badge, false, "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results prints Styles", (assert)->
  Traitify.ui.styles = ""

  builder = Traitify.ui.load(playedAssessment, ".widget")
  builder.results.onInitialize(->
    badge = document.querySelector(".widget .badges-container .badge")
    assert.equal(!badge, false, "Personality types container exists")
    QUnit.start()
  )
)

