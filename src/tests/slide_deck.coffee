unPlayedAssessment = "unplayed"
playedAssessment = "played"

body = document.getElementsByTagName("body")[0]
body.innerHTML = body.innerHTML + "<div class='widget' style='display:none'></div>"

QUnit.test("Slide Deck Hooks Exist", (assert)->
  Traitify.setVersion("v1")
  Traitify.setHost("api-sandbox.traitify.com")
  Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")
  document.getElementsByClassName("widget")[0].innerHTML = ""

  Builder = Traitify.ui.load(unPlayedAssessment, ".widget", Object())
  assert.equal(!Builder.onInitialize, false, "on Initialize Event Succeeds!" )
  assert.equal(!Builder.onMe, false, "on Me Event Succeeds!" )
  assert.equal(!Builder.onNotMe, false, "on Not Me Event Succeeds!" )
  assert.equal(!Builder.onAddSlide, false, "on Add Slide Event Succeeds!" )
  assert.equal(!Builder.onFinished, false, "on Finish Event Succeeds!" )
  assert.equal(!Builder.onAdvanceSlide, false, "on Advance Slide Event Succeeds!" )
)

QUnit.module( "Testing API Version 1", {setup: ->
  Traitify.setVersion("v1")
  Traitify.setHost("api-sandbox.traitify.com")
  Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

  document.getElementsByClassName("widget")[0].innerHTML = ""
});
QUnit.asyncTest("Slide Deck Widget Initialize", (assert)->

  Builder = Traitify.ui.load(unPlayedAssessment, ".widget", Object())
  Builder.onInitialize(->
    #Data Should Exist
    assert.equal( Builder.data.slides[0].caption, "Navigating", "First Slide Caption Succeeds!" )

    #First Slide
    firstSlide = Builder.nodes.currentSlide.getElementsByClassName("caption")[0].innerHTML
    assert.equal( firstSlide, "Navigating", "First Slide is on DOM Succeeds!" )

    #Builder Nodes
    builderNodeNames = [
      "main", 
      "progressBar", 
      "progressBarInner", 
      "currentSlide", 
      "nextSlide", 
      "slides", 
      "me", 
      "notMe", 
      "meNotMeContainer",
      "container"
    ] 

    assert.equal( JSON.stringify(Object.keys(Builder.nodes)), JSON.stringify(builderNodeNames), "Node Names append to Builder Succeeds!" )

    QUnit.start()
  )
)

QUnit.test("Slide Deck Widget Appears on Screen", (assert)->

  Builder = Traitify.ui.load(unPlayedAssessment, ".widget", Object())
  assert.equal(!document.getElementsByClassName("slide active")[0], false, "on Initialize Event Succeeds!" )
)

QUnit.asyncTest("Results Widget Appears on Screen", (assert)->
  assert.equal(!document.getElementsByClassName("personality-types")[0], true, "Personality types container exists")

  Builder = Traitify.ui.load(playedAssessment, ".widget", Object())
  Builder.results.onInitialize(->
    assert.equal(!document.getElementsByClassName("blend")[0], false, "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results Widget Shows Traits When Requested", (assert)->
  assert.equal(!document.getElementsByClassName("personality-types")[0], true, "Personality types container exists")

  Builder = Traitify.ui.load(playedAssessment, ".widget", {traits:true})
  Builder.results.onInitialize(->
    assert.equal(!document.getElementsByClassName("toggle-traits")[0], false, "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results Widget Does Not Show Traits View Upon Request", (assert)->
  assert.equal(!document.getElementsByClassName("personality-types")[0], true, "Personality types container exists")

  Builder = Traitify.ui.load(playedAssessment, ".widget")
  Builder.results.onInitialize(->
    assert.equal(!document.getElementsByClassName("toggle-traits")[0], true, "Personality types container exists")
    QUnit.start()
  )
)