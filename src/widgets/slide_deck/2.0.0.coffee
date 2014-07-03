window.Traitify.ui.slideDeck = (assessmentId, selector, options)->
  Builder = Object()
  Builder.nodes = Object()
  Builder.states = Object()
  Builder.states.animating = false
  Builder.data = Object()
  Builder.data.slideResponses = Object()

  if selector.indexOf("#") != -1
    selector = selector.replace("#", "")
    Builder.nodes.main = document.getElementById(selector)
  else
    selector = selector.replace(".", "")
    selectedObject = document.getElementsByClassName(selector)
    Builder.nodes.main = if selectedObject then selectedObject[0] else null

  if !Builder.nodes.main
    console.log("YOU MUST HAVE A TAG WITH A SELECTOR FOR THIS TO WORK")
    return false

  Builder.classes = ->
    classes = Builder.main.className.split(" ")
    for key of classes
      classes[key] = "." + classes[key]
    classes.join ""

  Builder.data.slidesLeft = ->
    Builder.data.slides.length - Builder.data.currentSlide

  # LOCAL DB FOR SLIDES
  Builder.addSlide = (id, value)->
      Traitify.addSlide(assessmentId, id, value, 1000, ->
        Builder.data.sentSlides += 1
        if Builder.data.sentSlides == Builder.data.slidesToPlayLength
          console.log("tried the prop ui")
          Builder.nodes.main.innerHTML = ""
          Traitify.ui.resultsProp(assessmentId, selector, options)

        
      )

  # VIEW LOGIC
  Builder.partials = Object()
  Builder.partials.make = (elementType, attributes)->
    element = document.createElement(elementType)

    for attributeName of attributes
      element.setAttribute(attributeName, attributes[attributeName])

    element

  Builder.partials.div = (attributes)->
    @make("div", attributes)

  Builder.partials.img = (attributes)->
    @make("img", attributes)

  Builder.partials.i = (attributes)->
    @make("i", attributes)

  Builder.data.getProgressBarNumbers = ->
    ((Builder.data.totalSlideLength - Builder.data.slides.length + Builder.data.currentSlide) / Builder.data.totalSlideLength) * 100

  Builder.partials.slideDeckContainer = ->
    slidesContainer = @div({class:"tf-slide-deck-container"})
    slidesLeft = Builder.data.getProgressBarNumbers()

    slidesContainer.appendChild(Builder.partials.progressBar(slidesLeft))

    slidesContainer.appendChild(@slides(Builder.data.slides))

    slidesContainer.appendChild(@meNotMe())
    slidesContainer

  Builder.partials.meNotMe = ->
    meNotMeContainer = @div({class:"me-not-me-container"})
    Builder.nodes.me = @div({class:"me"})
    Builder.nodes.notMe = @div({class:"not-me"})
    Builder.nodes.notMe.innerHTML = "Not Me"
    Builder.nodes.me.innerHTML = "Me"
    meNotMeContainer.appendChild(Builder.nodes.me)
    meNotMeContainer.appendChild(Builder.nodes.notMe)
    Builder.nodes.meNotMeContainer = meNotMeContainer

    meNotMeContainer

  Builder.partials.slides = (slidesData)->
    slides = @div({class:"slides"})
    placeHolderSlide = Builder.partials.slide(slidesData[0])
    placeHolderSlide.className += " placeholder"
    slides.appendChild(placeHolderSlide)

    Builder.nodes.slide = Array()

    Builder.nodes.currentSlide = Builder.partials.slide(slidesData[0])
    Builder.nodes.currentSlide.className += " active"
    slides.appendChild(Builder.nodes.currentSlide)

    if slidesData[1]
      Builder.nodes.nextSlide = Builder.partials.slide(slidesData[1])
      slides.appendChild(Builder.nodes.nextSlide)
    else
      Builder.nodes.nextSlide = false

    Builder.nodes.slides = slides

    slides

  Builder.partials.slide = (slideData)->
    slideImg = @img({src:slideData.image_desktop})
    slide = @div({class:"slide"})
    slideCaption = @div({class:"caption"})
    slideCaption.innerHTML = slideData.caption
    slide.appendChild(slideCaption)
    slide.appendChild(slideImg)
    slide

  Builder.partials.progressBar = (percentFinished)->
    progressBar = @div({class:"progress-bar"})
    progressBarInner = @div({class:"progress-bar-inner"})
    progressBarInner.style.width = percentFinished + "%"
    progressBar.appendChild(progressBarInner)

    Builder.nodes.progressBar = progressBar
    Builder.nodes.progressBarInner = progressBarInner

    progressBar

  Builder.partials.loadingAnimation = ()->
    loadingContainer = @div({class:"loading"})
    leftDot = @i(Object())
    rightDot = @i(Object())
    loadingSymbol = @div({class:"symbol"})
    loadingSymbol.appendChild(leftDot)
    loadingSymbol.appendChild(rightDot)
    loadingContainer.appendChild(loadingSymbol)

    loadingContainer

  Builder.actions = ->
    Builder.nodes.me.onclick = ->
      if !Builder.states.animating && !Builder.data.slidesLeft() != 1
        if !Builder.data.slides[Builder.data.currentSlide] 
          Builder.events.loadingAnimation()

        Builder.events.advanceSlide()

        currentSlide = Builder.data.slides[Builder.data.currentSlide - 1]

        Builder.addSlide(currentSlide.id, true)

        Builder.data.currentSlide += 1

    Builder.nodes.notMe.onclick = ->
      if !Builder.states.animating && Builder.nodes.nextSlide
        if !Builder.data.slides[Builder.data.currentSlide] 
          Builder.events.loadingAnimation()

        Builder.events.advanceSlide()

        currentSlide = Builder.data.slides[Builder.data.currentSlide - 1]

        Builder.addSlide(currentSlide.id, false)

        Builder.data.currentSlide += 1

  Builder.events = Object()
  Builder.events.advanceSlide = ->

    

    Builder.nodes.progressBarInner.style.width = Builder.data.getProgressBarNumbers() + "%"

    Builder.states.animating = true

    if Builder.nodes.playedSlide
      # REMOVE NODE
      Builder.nodes.slides.removeChild(Builder.nodes.playedSlide)

    Builder.nodes.playedSlide = Builder.nodes.currentSlide
    Builder.nodes.playedSlide.addEventListener('webkitTransitionEnd', (event)-> 
      if Builder.events.advancedSlide
        Builder.events.advancedSlide()
      Builder.states.animating = false
    , false )

    Builder.nodes.currentSlide = Builder.nodes.nextSlide

    Builder.nodes.playedSlide.className += " played"
    Builder.nodes.currentSlide.className += " active"
    
    # NEW NEXT SLIDE
    nextSlideData = Builder.data.slides[Builder.data.currentSlide + 1]
    if nextSlideData
      Builder.nodes.nextSlide = Builder.partials.slide(nextSlideData)
      Builder.nodes.slides.appendChild(Builder.nodes.nextSlide)

  Builder.events.loadingAnimation = ->
    Builder.nodes.meNotMeContainer.className += " hide"
    Builder.nodes.slides.removeChild(Builder.nodes.currentSlide)
    Builder.nodes.slides.insertBefore(Builder.partials.loadingAnimation(), Builder.nodes.slides.firstChild)

  Builder.initialize = ->
    widget = Builder.partials.make("script", {src:"http://localhost:9292/compiled/js/widgets/results/prop/2.0.0.js", type: "text/javascript"})
    head = document.getElementsByTagName("head")[0]
    head.appendChild(widget)
    Traitify.getSlides(assessmentId, (data)->
      Builder.data.currentSlide = 1
      Builder.data.totalSlideLength = data.length
      Builder.data.sentSlides = 0
      Builder.data.slides = data.filter((slide)->
        !slide.completed_at
      )
      Builder.data.slidesToPlayLength = Builder.data.slides.length

      style = Builder.partials.make("link", {href:"http://localhost:9292/compiled/assets/stylesheets/slide_deck.css", type:'text/css', rel:"stylesheet"})

      Builder.nodes.main.innerHTML = ""

      Builder.nodes.main.appendChild(style)

      if Builder.data.slides.length != 0
        Builder.nodes.main.appendChild(Builder.partials.slideDeckContainer())

        Builder.actions()
      else
        Builder.results = Traitify.ui.resultsProp(assessmentId, selector, options)
      
    )
  
  Builder.initialize()

  Builder