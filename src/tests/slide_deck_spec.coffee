Traitify.XHR = MockRequest

QUnit.module( "module A", {
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

QUnit.test("Slide Deck Hooks Exist", (assert)->

  widgets = Traitify.ui.load(unPlayedAssessment, ".widget", Object())


  assert.equal(!widgets.slideDeck.onInitialize, false, "on Initialize Event Succeeds!" )
  assert.equal(!widgets.slideDeck.onMe, false, "on Me Event Succeeds!" )
  assert.equal(!widgets.slideDeck.onNotMe, false, "on Not Me Event Succeeds!" )
  assert.equal(!widgets.slideDeck.onAddSlide, false, "on Add Slide Event Succeeds!" )
  assert.equal(!widgets.slideDeck.onFinished, false, "on Finish Event Succeeds!" )
 
  assert.equal(!widgets.slideDeck.onAdvanceSlide, false, "on Advance Slide Event Succeeds!" )
)

QUnit.test("Slide Deck Widget Appears on Screen", (assert)->

  Builder = Traitify.ui.load(unPlayedAssessment, ".widget", Object())
  assert.equal(!document.getElementsByClassName("slide active")[0], false, "on Initialize Event Succeeds!" )
)

QUnit.asyncTest("Slide Deck Widget Initializes with all expected nodes", (assert)->

  widgets = Traitify.ui.load(unPlayedAssessment, ".widget", Object())

  slideDeck = widgets.slideDeck
  console.log(JSON.stringify(slideDeck))
  slideDeck.onInitialize(->
    #Data Should Exist
    assert.equal(slideDeck.data.get("Slides")[0].caption, "Navigating", "First Slide Caption Succeeds!")

    #First Slide
    firstSlide = slideDeck.nodes().currentSlide.getElementsByClassName("caption")[0].innerHTML
    assert.equal(firstSlide, "Navigating", "First Slide is on DOM Succeeds!")

    #Builder Nodes
    builderNodeNames = [
      "main", 
      "tfSlideDeckContainer", 
      "cover", 
      "progress-bar", 
      "progress-bar-inner", 
      "progressBar", 
      "progressBarInner", 
      "slides", 
      "slide", 
      "caption", 
      "slide.image", 
      "currentSlide", 
      "nextSlide", 
      "meNotMeContainer", 
      "me", 
      "notMe", 
      "container"
    ]
    for name in builderNodeNames
      assert.ok( slideDeck.nodes(), name, "Node Name #{name} exists in Node list!")
    QUnit.start()
  )

)

QUnit.asyncTest("Slide Deck Widget can click through slides", (assert)->
  widgets = Traitify.ui.load(unPlayedAssessment, ".widget", Object())
  slideDeck = widgets.slideDeck

  slideDeck.onInitialize(->
    #Data Should Exist
    assert.equal( slideDeck.data.slides.all[0].caption, "Navigating", "First Slide Caption Succeeds!" )

    #First Slide
    firstSlide = slideDeck.nodes().currentSlide.getElementsByClassName("caption")[0].innerHTML
    assert.equal( firstSlide, "Navigating", "First Slide is on DOM Succeeds!" )

    document.querySelector(".widget").innerHTML
    
    slideDeck.data.assessmentId = "played"
    slideDeck.data.slides.notCompleted.length.times((i)->
      currentSlide = slideDeck.nodes().currentSlide
      type =  if i % 2 == 0 then 0 else 1
      meNotMe = [document.querySelector(".me"), document.querySelector(".not-me")][type]
      meNotMe.trigger('click')

      currentSlide.trigger("webkitTransitionEnd")
      currentSlide.trigger("transitionEnd")
      sentSlideNumber = slideDeck.data.sentSlides
    )
    
    waitUntil( ->
      slideDeck.data.sentSlides == slideDeck.data.slidesToPlayLength
    ).then(->
      assert.ok(document.querySelector(".widget .tf-results"), "Node Name #{name} exists in Node list!")
      QUnit.start()    
    )
    
  )

)

QUnit.asyncTest("Slide Deck Widget Initialize with load('slideDeck', ...)", (assert)->

  slideDeck = Traitify.ui.load("slideDeck", unPlayedAssessment, ".widget", Object())

  slideDeck.onInitialize(->
    assert.ok(document.querySelector(".widget .slides"), "awesome")
    #Data Should Exist
    QUnit.start()
  )

)

QUnit.asyncTest("Slide Deck Widget can load Iphone Version", (assert)->
  Traitify.ui.userAgent = "iPhone"
  slideDeck = Traitify.ui.load("slideDeck", unPlayedAssessment, ".widget", Object())

  slideDeck.onInitialize(->
    assert.ok(document.querySelector(".widget .slides"), "awesome")
    assert.ok(document.querySelector(".widget .iphone"), "awesome")
    #Data Should Exist
    QUnit.start()
  )

)