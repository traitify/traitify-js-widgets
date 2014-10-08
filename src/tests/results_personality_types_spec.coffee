QUnit.module( "Results Personality Types Tests", {
  setup: ->
    Traitify.XHR = MockRequest
    Traitify.setVersion("v1")
    Traitify.setHost("api-sandbox.traitify.com")
    Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

    unless document.querySelector(".widget")
      widget = document.createElement("div")
      widget.setAttribute("class", "widget")
      body.appendChild(widget)

    unless document.querySelector(".personality-traits")
      personalityTypes = document.createElement("div")
      personalityTypes.setAttribute("class", "personality-traits")
      body.appendChild(personalityTypes)
  ,
  teardown: ->
    Traitify.XHR = XMLHttpRequest
})

QUnit.asyncTest("Results Personality Types Widget Appears with load('personalityTypes'...)", (assert)->
  builder = Traitify.ui.load("personalityTypes", playedAssessment, ".widget")
  builder.onInitialize(->
    trait = document.querySelector(".personality-type")

    assert.ok(trait, "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results Click Through Personality Types", (assert)->
  builder = Traitify.ui.load("personalityTypes", playedAssessment, ".widget")

  builder.onInitialize(->
    waitUntil(->
      document.querySelector(".widget .description")
    ).then(->
      document.querySelectorAll(".widget .personality-type")[0].trigger('click')
      descriptionBefore = document.querySelector(".widget .description").innerHTML
      
      index = document.querySelectorAll(".widget .personality-type")[1].getAttribute("data-index")
      document.querySelectorAll(".widget .personality-type")[1].trigger('click')
      descriptionAfter = document.querySelector(".widget .description").innerHTML
      waitUntil(->
        descriptionAfter = document.querySelector(".widget .description").innerHTML
        descriptionAfter != descriptionBefore
      ).then((truthy)->
        assert.ok(descriptionBefore != descriptionAfter, "Personality types container exists")
        QUnit.start()
      )
    )
  )
)