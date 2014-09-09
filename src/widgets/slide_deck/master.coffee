Traitify.ui.slideDeck = (Widget, options)->
  Widget.data.slideResponses = Object()
  Widget.states.add("animating")
  Widget.states.add("finished")
  Widget.states.add("initialized")
  
  Widget.callbacks.add("Initialize")
  Widget.callbacks.add("Finished")
  Widget.callbacks.add("AddSlide")
  Widget.callbacks.add("Me")
  Widget.callbacks.add("NotMe")
  Widget.callbacks.add("AdvanceSlide")
  Widget.callbacks.add("finished")

  #######################
  # DATA
  #######################
  Widget.data.slidesLeft = ->
    Widget.data.slides.all.length - Widget.data.currentSlide

  Widget.data.slideValues = Array()
  
  Widget.data.addSlide = (id, value)->
    Widget.data.lastSlideTime = Widget.data.currentSlideTime
    Widget.data.currentSlideTime = new Date().getTime()
    Widget.data.slideValues.push({
      id: id, 
      response: value, 
      time_taken: Widget.data.currentSlideTime - Widget.data.lastSlideTime
    })
    Widget.data.sentSlides += 1
    if Widget.data.slideValues.length % 10 == 0 || Widget.data.sentSlides == Widget.data.slidesToPlayLength
      Traitify.addSlides(Widget.data.assessmentId, Widget.data.slideValues, (response)->
        if Widget.callbacks.addSlide
          Widget.callbacks.addSlide(Widget)
        if Widget.data.sentSlides == Widget.data.slidesToPlayLength
          Widget.nodes.main.innerHTML = ""
          if options.showResults != false
            Widget.nodes.main.innerHTML = Traitify.ui.styles
            Traitify.getPersonalityTypes(Widget.data.assessmentId).then((data)->
              Widget.Widgets().results.data = data
              Widget.Widgets().results.initialize()
            )
            
            if options.personalityTypes
              Traitify.ui.loadPersonalityTypes(Widget.data.assessmentId, options.personalityTypes.target, options.personalityTypes)
          if Widget.callbacks.finished
            Widget.callbacks.finished(Widget)
      )


  Widget.data.getProgressBarNumbers = (initialize)->
    slideLength = Widget.data.slides.all.length
    currentLength = Widget.data.slides.notCompleted.length 
    currentPosition = Widget.data.sentSlides
    if !initialize
      currentPosition +=1
    (currentPosition / slideLength) * 100
    
  #########################  
  # PARTIALS
  #########################
  Widget.partials.slideDeckContainer = ->
    slidesContainer = @div({class:"tf-slide-deck-container"})
    cover = @div({class:"cover"})
    cover.innerHTML = "Landscape mode is not currently supported"
    slidesContainer.appendChild(cover)
    
    slidesLeft = Widget.data.getProgressBarNumbers("initializing")

    slidesContainer.appendChild(Widget.partials.progressBar(slidesLeft))

    slidesContainer.appendChild(@slides(Widget.data.slides.all))

    slidesContainer.appendChild(@meNotMe())
    slidesContainer

  Widget.partials.meNotMe = ->
    meNotMeContainer = @div({class:"me-not-me-container"})
    Widget.nodes.me = @div({class:"me"})
    Widget.nodes.notMe = @div({class:"not-me"})
    Widget.nodes.notMe.innerHTML = "Not Me"
    Widget.nodes.me.innerHTML = "Me"
    meNotMeContainer.appendChild(Widget.nodes.me)
    meNotMeContainer.appendChild(Widget.nodes.notMe)
    Widget.nodes.meNotMeContainer = meNotMeContainer

    meNotMeContainer

  Widget.partials.slides = (slidesData)->
    slides = @div({class:"slides"})
    placeHolderSlide = Widget.partials.slide(slidesData[0])
    placeHolderSlide.className += " placeholder"
    slides.appendChild(placeHolderSlide)

    Widget.nodes.currentSlide = Widget.partials.slide(slidesData[0])
    Widget.nodes.currentSlide.className += " active"
    slides.appendChild(Widget.nodes.currentSlide)

    if slidesData[1]
      Widget.nodes.nextSlide = Widget.partials.slide(slidesData[1])
      slides.appendChild(Widget.nodes.nextSlide)
    else
      Widget.nodes.nextSlide = false

    Widget.nodes.slides = slides

    slides

  Widget.partials.slide = (slideData)->
    slide = @div({class:"slide"})
    slideCaption = @div({class:"caption"})
    slideCaption.innerHTML = slideData.caption

    if Widget.device
        slideImg = @div({
          style:"background-image:url('#{slideData.image_desktop_retina}'); background-position:#{slideData.focus_x}% #{slideData.focus_y}%;'", 
          class:"image"
        })
        slideImg.appendChild(slideCaption)
    else
        slideImg = @img({src:slideData.image_desktop_retina})
        slide.appendChild(slideCaption)

    slide.appendChild(slideImg)
    slide

  Widget.partials.progressBar = (percentFinished)->
    progressBar = @div({class:"progress-bar"})
    progressBarInner = @div({class:"progress-bar-inner"})
    progressBarInner.style.width = percentFinished + "%"
    progressBar.appendChild(progressBarInner)

    Widget.nodes.progressBar = progressBar
    Widget.nodes.progressBarInner = progressBarInner

    progressBar

  Widget.partials.loadingAnimation = ()->
    loadingContainer = @div({class:"loading"})
    leftDot = @i(Object())
    rightDot = @i(Object())
    loadingSymbol = @div({class:"symbol"})
    loadingSymbol.appendChild(leftDot)
    loadingSymbol.appendChild(rightDot)
    loadingContainer.appendChild(loadingSymbol)

    loadingContainer

    
  ##########################
  # HELPERS
  ##########################
  touched = Object()
  Widget.helpers.touch = (touchNode, callBack)->
    touchNode.addEventListener('touchstart', (event)->
      touchobj = event.changedTouches[0]
      touched.startx = parseInt(touchobj.clientX)
      touched.starty = parseInt(touchobj.clientY)
      
    )
    touchNode.addEventListener('touchend', (event)->
      touchobj = event.changedTouches[0]
      touchDifferenceX = Math.abs(touched.startx - parseInt(touchobj.clientX))
      touchDifferenceY = Math.abs(touched.starty - parseInt(touchobj.clientY))
      if (touchDifferenceX < 2 && touchDifferenceX < 2)   
        callBack()
    )
  Widget.helpers.onload = (callBack)->
    if (window.addEventListener)
        window.addEventListener('load', callBack)
    else if (window.attachEvent)
        window.attachEvent('onload', callBack)

    
  ###########################
  # EVENTS
  ###########################

  Widget.events.me = ->
    if !Widget.states.animating() && !Widget.data.slidesLeft() != 1
      if !Widget.data.slides.all[Widget.data.currentSlide] 
        Widget.events.loadingAnimation()
      Widget.states.animating(true)
      Widget.events.advanceSlide()

      currentSlide = Widget.data.slides.all[Widget.data.currentSlide - 1]

      Widget.data.addSlide(currentSlide.id, true)

      Widget.data.currentSlide += 1

      if Widget.callbacks.me
        Widget.callbacks.me(Widget)

  Widget.events.notMe = ->
    if !Widget.states.animating() && Widget.nodes.nextSlide
      if !Widget.data.slides.all[Widget.data.currentSlide] 
        Widget.events.loadingAnimation()

      Widget.states.animating(true)
      Widget.events.advanceSlide()

      currentSlide = Widget.data.slides.all[Widget.data.currentSlide - 1]

      Widget.data.addSlide(currentSlide.id, false)

      Widget.data.currentSlide += 1

      if Widget.callbacks.notMe
        Widget.callbacks.notMe(Widget)

  Widget.events.advanceSlide = ->
    Widget.prefetchSlides()
    Widget.nodes.progressBarInner.style.width = Widget.data.getProgressBarNumbers() + "%"


    if Widget.nodes.playedSlide
      # REMOVE NODE
      Widget.nodes.slides.removeChild(Widget.nodes.playedSlide)

    Widget.nodes.playedSlide = Widget.nodes.currentSlide

    Widget.nodes.currentSlide = Widget.nodes.nextSlide

    Widget.nodes.currentSlide.addEventListener('webkitTransitionEnd', (event)-> 
      if Widget.events.advancedSlide
        Widget.events.advancedSlide()
      Widget.states.animating(false)
    , false )

    Widget.nodes.currentSlide.addEventListener('transitionend', (event)-> 
      if Widget.events.advancedSlide
        Widget.events.advancedSlide()
      Widget.states.animating(false)
    , false )
  
    Widget.nodes.currentSlide.addEventListener('oTransitionEnd', (event)-> 
      if Widget.events.advancedSlide
        Widget.events.advancedSlide()
      Widget.states.animating(false)
    , false )
  
    Widget.nodes.currentSlide.addEventListener('otransitionend', (event)-> 
      if Widget.events.advancedSlide
        Widget.events.advancedSlide()
      Widget.states.animating(false)
    , false )
  
    Widget.nodes.playedSlide.className += " played"
    Widget.nodes.currentSlide.className += " active"

    
    # NEW NEXT SLIDE
    nextSlideData = Widget.data.slides.all[Widget.data.currentSlide + 1]
    if nextSlideData
      Widget.nodes.nextSlide = Widget.partials.slide(nextSlideData)
      Widget.nodes.slides.appendChild(Widget.nodes.nextSlide)

    if Widget.callbacks.advanceSlide
      Widget.callbacks.advanceSlide(Widget)

  Widget.events.loadingAnimation = ->
    Widget.nodes.meNotMeContainer.className += " hide"
    Widget.nodes.slides.removeChild(Widget.nodes.currentSlide)
    Widget.nodes.slides.insertBefore(Widget.partials.loadingAnimation(), Widget.nodes.slides.firstChild)

  Widget.imageCache = Object()
  Widget.prefetchSlides = (count)->
    start = Widget.data.currentSlide - 1
    end = Widget.data.currentSlide + 9

    for slide in Widget.data.slides.all.slice(start, end)
      unless Widget.imageCache[slide.image_desktop_retina]
        Widget.imageCache[slide.image_desktop_retina] = new Image()
        Widget.imageCache[slide.image_desktop_retina].src = slide.image_desktop_retina

  Widget.events.setContainerSize = ->
      width = Widget.nodes.main.scrollWidth
      Widget.nodes.container.className = Widget.nodes.container.className.replace(" medium", "")
      Widget.nodes.container.className = Widget.nodes.container.className.replace(" large", "")
      Widget.nodes.container.className = Widget.nodes.container.className.replace(" small", "")
      if width < 480
        Widget.nodes.container.className += " small"
      else if width < 768
        Widget.nodes.container.className += " medium"
      
  Widget.events.onRotate = (rotateEvent)->
    supportsOrientationChange = "onorientationchange" of window
    orientationEvent = (if supportsOrientationChange then "orientationchange" else "resize")
    window.addEventListener(orientationEvent, (event)->
      rotateEvent(event)
    , false)
          

    
    

  Widget.initialization.events.add("Setup Data", ->
    Widget.data.currentSlide = 1

    Widget.data.slides.all = Widget.data.slides.notCompleted.concat(Widget.data.slides.completed)
    Widget.data.sentSlides = 0

    Widget.data.slidesToPlayLength = Widget.data.slides.all.length
  )
  
      
      
  Widget.initialization.events.add("Handle device type", ->
    Widget.nodes.container = Widget.partials.slideDeckContainer()
    if Widget.device
      Widget.nodes.container.className += " #{Widget.device}"
      Widget.nodes.container.className += " mobile phone"
      if options && options.nonTouch
        Widget.nodes.container.className += " non-touch"

    if options && options.size
      Widget.nodes.container.className += " #{options.size}"

    Widget.nodes.main.appendChild(Widget.nodes.container)
  )

  Widget.initialization.events.add("Actions", ->
    if Widget.device == "iphone"  ||  Widget.device == "ipad" 
      Widget.helpers.touch(Widget.nodes.notMe, ->
        Widget.events.notMe()
      )
      Widget.helpers.touch(Widget.nodes.me, ->
        Widget.events.me()
      )
    else
      Widget.nodes.notMe.onclick = ->
        Widget.events.notMe()

      Widget.nodes.me.onclick = ->
        Widget.events.me()
  )


  Widget.initialization.events.add("Prefetch Slides", ->
      Widget.prefetchSlides()
  )


  Widget.initialization.events.add("Setup Screen", ->
      Widget.events.setContainerSize()

      window.onresize = ->
        if !Widget.device
          Widget.events.setContainerSize()

      if Widget.device && Widget.device
        setupScreen = ->
          windowOrienter = ->
              Widget.nodes.main.style.height = window.innerHeight + "px"
          windowOrienter()

        Widget.events.onRotate((event)->
          windowOrienter()
        )

        Widget.helpers.onload( ->
          setupScreen()
        )

        setupScreen()
  )

  Widget.initialization.events.add("initializated", ->
    Widget.states.initialized(true)
      
    Widget.data.currentSlideTime = new Date().getTime()
  )

  Widget