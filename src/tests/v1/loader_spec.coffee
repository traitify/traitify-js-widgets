QUnit.module( "Testing Loader Spec", {
  setup: ->
    Traitify.XHR = MockRequest
    Traitify.setVersion("v1")
    Traitify.setHost("api-sandbox.traitify.com")
    Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

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

