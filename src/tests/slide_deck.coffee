unPlayedAssessment = "8e5352e8-33d4-4085-ac05-c6314008164b"

body = document.getElementsByTagName("body")[0]
body.innerHTML = body.innerHTML + "<div class='widget' style='display:none'></div>"

QUnit.test("Slide Deck Hooks Exist", (assert)->
  Traitify.setVersion("v1")
  Traitify.setHost("api-sandbox.traitify.com")
  Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

  Builder = Traitify.ui.slideDeck(unPlayedAssessment, ".widget", Object())
  assert.equal(!Builder.onInitialize, false, "on Initialize Event Succeeds!" )
  assert.equal(!Builder.onMe, false, "on Me Event Succeeds!" )
  assert.equal(!Builder.onNotMe, false, "on Not Me Event Succeeds!" )
  assert.equal(!Builder.onAddSlide, false, "on Add Slide Event Succeeds!" )
  assert.equal(!Builder.onFinish, false, "on Finish Event Succeeds!" )
  assert.equal(!Builder.onAdvanceSlide, false, "on Advance Slide Event Succeeds!" )
)
QUnit.asyncTest("Slide Deck Widget Initialize", (assert)->
  Traitify.setVersion("v1")
  Traitify.setHost("api-sandbox.traitify.com")
  Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

  Builder = Traitify.ui.slideDeck(unPlayedAssessment, ".widget", Object())
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
      "meNotMeContainer"
    ] 

    assert.equal( JSON.stringify(Object.keys(Builder.nodes)), JSON.stringify(builderNodeNames), "Node Names append to Builder Succeeds!" )

    QUnit.start()
  )
)
QUnit.test("Slide Deck Widget Appears on Screen", (assert)->
  Traitify.setVersion("v1")
  Traitify.setHost("api-sandbox.traitify.com")
  Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

  Builder = Traitify.ui.slideDeck(unPlayedAssessment, ".widget", Object())
  assert.equal(!document.getElementsByClassName("slide active")[0], false, "on Initialize Event Succeeds!" )
)