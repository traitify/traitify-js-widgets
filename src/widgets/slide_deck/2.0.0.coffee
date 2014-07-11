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

  Builder.data.slideValues = Array()
  # LOCAL DB FOR SLIDES
  Builder.data.addSlide = (id, value)->
    Builder.data.slideValues.push({id: id, response: value, time_taken: 1000})
    Builder.data.sentSlides += 1
    if Builder.data.slideValues.length % 10 == 0 || Builder.data.sentSlides == Builder.data.slidesToPlayLength
      Traitify.addSlides(assessmentId, Builder.data.slideValues, (response)->
        if Builder.callbacks.addSlide
          Builder.callbacks.addSlide(Builder)
        if Builder.data.sentSlides == Builder.data.slidesToPlayLength
          Builder.nodes.main.innerHTML = ""
          Traitify.ui.resultsDefault(assessmentId, selector, options)
          if Builder.callbacks.finished
            Builder.callbacks.finished(Builder)
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

  Builder.data.getProgressBarNumbers = (initialize)->
    slideLength = Builder.data.totalSlideLength 
    currentLength = Builder.data.slides.length 
    currentPosition = Builder.data.sentSlides
    unless initialize == "initializing"
      currentPosition += 1

    value = slideLength - currentLength + currentPosition
    (value / Builder.data.totalSlideLength) * 100

  Builder.partials.slideDeckContainer = ->
    slidesContainer = @div({class:"tf-slide-deck-container"})
    slidesLeft = Builder.data.getProgressBarNumbers("initializing")

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
    slideImg = @div({
      style:"background-image:url('#{slideData.image_desktop}'); background-position:#{slideData.focus_x}% #{slideData.focus_y}%;'", 
      class:"image"
    })
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

        Builder.data.addSlide(currentSlide.id, true)

        Builder.data.currentSlide += 1

        if Builder.callbacks.me
          Builder.callbacks.me(Builder)

    Builder.nodes.notMe.onclick = ->
      if !Builder.states.animating && Builder.nodes.nextSlide
        if !Builder.data.slides[Builder.data.currentSlide] 
          Builder.events.loadingAnimation()

        Builder.events.advanceSlide()

        currentSlide = Builder.data.slides[Builder.data.currentSlide - 1]

        Builder.data.addSlide(currentSlide.id, false)

        Builder.data.currentSlide += 1

        if Builder.callbacks.notMe
          Builder.callbacks.notMe(Builder)

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

    if Builder.callbacks.advanceSlide
      Builder.callbacks.advanceSlide(Builder)

  Builder.events.loadingAnimation = ->
    Builder.nodes.meNotMeContainer.className += " hide"
    Builder.nodes.slides.removeChild(Builder.nodes.currentSlide)
    Builder.nodes.slides.insertBefore(Builder.partials.loadingAnimation(), Builder.nodes.slides.firstChild)

  Builder.initialized = false
  Builder.initialize = ->
    Traitify.getSlides(assessmentId, (data)->
      Builder.data.currentSlide = 1
      Builder.data.totalSlideLength = data.length
      Builder.data.sentSlides = 0

      Builder.data.slides = data.filter((slide)->
        !slide.completed_at
      )
      Builder.data.slidesToPlayLength = Builder.data.slides.length

      style = Builder.partials.make("link", {href:"https://s3.amazonaws.com/traitify-cdn/assets/stylesheets/slide_deck.css", type:'text/css', rel:"stylesheet"})

      Builder.nodes.main.innerHTML = ""

      Builder.nodes.main.appendChild(style)

      if Builder.data.slides.length != 0
        Builder.nodes.main.appendChild(Builder.partials.slideDeckContainer())

        Builder.actions()
      else
        Builder.results = Traitify.ui.resultsDefault(assessmentId, selector, options)
      
      if Builder.callbacks.initialize 
        Builder.callbacks.initialize(Builder)
      else
        Builder.initialized = true
    )

  Builder.callbacks = Object()
  Builder.onInitialize = (callBack)->
    if Builder.initialized == true
      callBack()
    else
      Builder.callbacks.initialize = callBack

    Builder

  Builder.onFinish = (callBack)->
    Builder.callbacks.finish = callBack
    Builder

  Builder.onAddSlide = (callBack)->
    Builder.callbacks.addSlide = callBack
    Builder

  Builder.onMe = (callBack)->
    Builder.callbacks.me = callBack
    Builder

  Builder.onNotMe = (callBack)->
    Builder.callbacks.notMe = callBack
    Builder

  Builder.onAdvanceSlide = (callBack)->
    Builder.callbacks.advanceSlide = callBack
    Builder

  Builder.initialize()

  Builder












#############################################################
#
# RESULTS WIDGET
#
#############################################################
window.Traitify.ui.resultsDefault = (assessmentId, selector, options)->
  Builder = Object()
  Builder.nodes = Object()
  Builder.states = Object()
  Builder.data = Object()

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

  Builder.nodes.personalityTypes = Array()
  Builder.partials.personalityType = (typeData)->
    personalityType = @div({class:"personality-type"})

    badge = Builder.partials.badge(typeData.personality_type.badge)

    if typeData.score < 0
      barLeft = Builder.partials.barLeft(Math.abs(typeData.score))
      barRight = Builder.partials.barRight(0)
    else
      barLeft = Builder.partials.barLeft(0)
      barRight = Builder.partials.barRight(Math.abs(typeData.score))

    name = @div({class:"name"})
    name.innerHTML = typeData.personality_type.name

    score = @div({class:"score"})
    score.innerHTML = if typeData.score < 0 then "(#{Math.round(Math.abs(typeData.score))})" else Math.round(typeData.score)

    nameAndScore = @div({class:"name-and-score"})

    nameAndScore.appendChild(name)
    nameAndScore.appendChild(score)
    personalityType.appendChild(nameAndScore)

    personalityType.appendChild(barLeft)
    personalityType.appendChild(badge)
    personalityType.appendChild(barRight)

    Builder.nodes.personalityTypes.push({personalityType:personalityType, badge: badge})


    personalityType

  Builder.partials.badge = (badgeData)->
    badge = @div({class:"badge"})
    badge.appendChild(@img({src:badgeData.image_large}))
    badge 

  Builder.partials.barLeft = (scoreData)->
    last = Builder.nodes.personalityTypes.length - 1
    innerBarLeft = @div({class:"bar-inner-left"})
    innerBarLeft.style.width = scoreData + "%"
    barLeft = @div({class:"bar-left"})
    barLeft.appendChild(innerBarLeft)

    barLeft

  Builder.partials.barRight = (scoreData)->
    last = Builder.nodes.personalityTypes.length - 1
    innerBarRight = @div({class:"bar-inner-right"})
    innerBarRight.style.width = scoreData + "%"
    barRight = @div({class:"bar-right"})
    barRight.appendChild(innerBarRight)
    barRight

  Builder.partials.toggleTraits = ->
    toggleTraits = @div({class:"toggle-traits"})
    toggleTraits.innerHTML = "Show / Hide Traits"
    Builder.nodes.toggleTraits = toggleTraits
    toggleTraits

  Builder.nodes.personalityTraits = Array()
  Builder.partials.personalityTrait = (personalityTraitData)->
    personalityTrait = @div({class:"personality-trait"})
    leftName = @div({class:"left-name"})
    leftName.innerHTML = personalityTraitData.left_personality_trait.name

    rightName = @div({class:"right-name"})
    rightName.innerHTML = personalityTraitData.right_personality_trait.name

    personalityTrait.appendChild(leftName)
    personalityTrait.appendChild(rightName)

    traitScorePosition = Builder.partials.traitScorePosition(personalityTraitData.score)

    personalityTrait.appendChild(traitScorePosition)
    Builder.nodes.personalityTraits.push({personalityTrait: personalityTrait, leftName: leftName, rightName: rightName, score: traitScorePosition})

    personalityTrait

  Builder.partials.traitScorePosition = (score)->
    personalityTraitScoreContainer = @div({class:"score-container"})
    personalityTraitScoreWrapper = @div({class:"score-wrapper"})
    personalityTraitScoreContainer.appendChild(personalityTraitScoreWrapper)

    personalityTraitScore = @div({class:"score"})
    personalityTraitScore.style.left = score + "%"
    personalityTraitScoreWrapper.appendChild(personalityTraitScore)

    personalityTraitLine = @div({class:"line"})
    personalityTraitScoreContainer.appendChild(personalityTraitLine)

    personalityTraitScoreContainer

  Builder.partials.printButton = ->
    printButton = @div({class:"print-button"})
    Builder.nodes.printButton = printButton
    printButton.innerHTML = "Print"
    printButton

  Builder.actions = ->
    if Builder.nodes.toggleTraits
      Builder.nodes.toggleTraits.onclick = ->
        if Builder.nodes.personalityTraitContainer
          if Builder.nodes.personalityTypesContainer.style.display == "block"
            Builder.nodes.personalityTypesContainer.style.display = "none"
            Builder.nodes.personalityTraitContainer.style.display = "block"
          else
            Builder.nodes.personalityTypesContainer.style.display = "block"
            Builder.nodes.personalityTraitContainer.style.display = "none"
        else
          Traitify.getPersonalityTraits(assessmentId, (data)->
            personalityTraitContainer = Builder.partials.div({class: "personality-traits"})
            Builder.nodes.personalityTraitContainer = personalityTraitContainer 

            for personalityTrait in data
              personalityTraitContainer.appendChild(Builder.partials.personalityTrait(personalityTrait))

            Builder.nodes.container.appendChild(personalityTraitContainer)
            Builder.nodes.personalityTypesContainer.style.display = "none"
            Builder.nodes.personalityTraitContainer.style.display = "block"
          )

    Builder.nodes.printButton.onclick = ->
      Builder.printWindow = window.open()

      Builder.nodes.printWindow = Object()
      Builder.nodes.printWindow.head = Builder.printWindow.document.getElementsByTagName("head")[0]
      Builder.nodes.printWindow.main = Builder.printWindow.document.getElementsByTagName("body")[0]
      Builder.nodes.printContainer = Builder.partials.div({class:"tf-results-prop"})
      Builder.nodes.printContainer.appendChild(Builder.nodes.stylesheet.cloneNode(true))

      Builder.nodes.printContainer.appendChild(Builder.nodes.personalityTypesContainer.cloneNode(true))
      if Builder.nodes.personalityTraitContainer
        Builder.nodes.printContainer.appendChild(Builder.nodes.personalityTraitContainer.cloneNode(true))

      Builder.nodes.printWindow.main.appendChild(Builder.nodes.printContainer)
      title = Builder.partials.make("title")
      title.innerHTML = "PERSONALITY TO PRINT"
      Builder.nodes.printWindow.head.appendChild(title)

  Builder.initialized = false
  Builder.initialize = ->
    Builder.nodes.main.innerHTML = ""
    Traitify.getPersonalityTypes(assessmentId, (data)->
      Builder.data.personalityTypes = data.personality_types

      style = Builder.partials.make("link", {href:"https://s3.amazonaws.com/traitify-cdn/assets/stylesheets/results_prop.css", type:'text/css', rel:"stylesheet"})
      Builder.nodes.stylesheet = style

      Builder.nodes.main.appendChild(style)

      Builder.nodes.container = Builder.partials.div({class:"tf-results-prop"})

      toolsContainer = Builder.partials.div({class:"tools"})

      Builder.nodes.toolsContainer = toolsContainer

      if options && options.traits
        toolsContainer.appendChild(Builder.partials.toggleTraits())

      toolsContainer.appendChild(Builder.partials.printButton())
        
      Builder.nodes.container.appendChild(toolsContainer)

      Builder.nodes.personalityTypesContainer = Builder.partials.div({class:"personality-types"})
      Builder.nodes.container.appendChild(Builder.nodes.personalityTypesContainer)

      for personalityType in Builder.data.personalityTypes
        Builder.nodes.personalityTypesContainer.appendChild(Builder.partials.personalityType(personalityType))

      Builder.nodes.main.appendChild(Builder.nodes.container)

      Builder.actions()

      if Builder.callbacks.initialize
        Builder.callbacks.initialize(Builder)
      else
        Builder.initialized = true
    )
  
  Builder.callbacks = Object()
  Builder.onInitialize = (callBack)->
    if Builder.initialized == true
      callBack()
    else
      Builder.callbacks.initialize = callBack

    Builder

  Builder.initialize()

  Builder