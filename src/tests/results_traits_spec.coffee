Traitify.XHR = MockRequest

QUnit.module( "Results Traits Tests", {
  setup: ->
    Traitify.XHR = MockRequest
    Traitify.setVersion("v1")
    Traitify.setHost("api-sandbox.traitify.com")
    Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")
    document.getElementsByClassName("widget")[0].innerHTML = ""
    unless document.querySelector(".widget")
      widget = document.createElement("div")
      widget.setAttribute("class", "widget")
      body.appendChild(widget)
  ,
  teardown: ->
    Traitify.XHR = XMLHttpRequest
})

QUnit.asyncTest("Results Traits Widget Appears with load('perosnalityTraits'...)", (assert)->
  builder = Traitify.ui.load("personalityTraits", playedAssessment, ".widget")
  builder.personalityTraits.onInitialize(->
    trait = document.querySelector(".trait")

    assert.ok(trait, "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results Traits", (assert)->
  unless document.querySelector(".personality-traitss")
    personalityTypes = document.createElement("div")
    personalityTypes.setAttribute("class", "personality-traits")
    body.appendChild(personalityTypes)

  options = {
    personalityTraits: {
      target:".personality-traits"
    }
  }

  builder = Traitify.ui.load(playedAssessment, ".widget", options)

  builder.results.onInitialize(->
    assert.equal(!document.querySelector(".trait"), false, "Personality types container exists")
    QUnit.start()
  )
)