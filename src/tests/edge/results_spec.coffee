Traitify.XHR = MockRequest

QUnit.module( "Results Tests", {
  setup: ->
    Traitify.XHR = MockRequest
    Traitify.setVersion("v1")
    Traitify.setHost("api-sandbox.traitify.com")
    Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

    unless document.querySelector(".widget")
      widget = document.createElement("div")
      widget.setAttribute("class", "widget")
      body.appendChild(widget)
  ,
  teardown: ->
    Traitify.XHR = XMLHttpRequest
})

QUnit.asyncTest("Results with type When Requested", (assert)->
  unless document.querySelector(".personality-types")
    personalityTypes = document.createElement("div")
    personalityTypes.setAttribute("class", "personality-types")
    body.appendChild(personalityTypes)

  unless document.querySelector(".personality-traits")
    personalityTraits = document.createElement("div")
    personalityTraits.setAttribute("class", "personality-traits")
    body.appendChild(personalityTraits)

  options = {
    personalityTypes: {
      target:".personality-types"
    }
    personalityTraits: {
      target:".personality-traits"
    }
  }

  builder = Traitify.ui.load(playedAssessment, ".widget", options)

  builder.results.onInitialize(->
    assert.equal(!document.querySelector(".badge"), false, "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results Widget Appears on Screen", (assert)->
  builder = Traitify.ui.load(playedWithBlend, ".widget")

  builder.results.onInitialize(->
    badge = document.querySelector(".widget .badges-container .left-badge")
    assert.equal(badge.getAttribute("class"), "left-badge", "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results Widget Appears on Screen", (assert)->
  builder = Traitify.ui.load(playedAssessment, ".widget")

  builder.results.onInitialize(->
    badge = document.querySelector(".widget .badges-container .badge")
    assert.equal(badge.className, "badge", "Personality types container exists")
    QUnit.start()
  )
)