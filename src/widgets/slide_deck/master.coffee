Traitify.ui.loaders ?= Object()
Traitify.ui.loaders.slideDeck = (assessmentId, target, options)->
  slideDeck = Traitify.ui.widgets.slideDeck(new Widget(target), options)
  Traitify.getSlides(assessmentId, (data)->

    slides = Object()
    
    slides.notCompleted = data.filter((slide)->
      !slide.completed_at
    )

    slideDeck.data.assessmentId = assessmentId
    slideDeck.data.slides = Object()
    slideDeck.data.slides.notCompleted = slides.notCompleted
    slideDeck.data.slides.completed = data.filter((slide)->
      slide.completed_at
    )
    
    slideDeck.run()
  )

  slideDeck

Traitify.ui.widgets ?= Object()    
Traitify.ui.widgets.slideDeck = (widget, options)->
  widget.data.slideResponses = Object()
  widget.states.add("animating")
  widget.states.add("finished")
  widget.states.add("initialized")
  widget.states.add("transitionEndListens")
  widget.callbacks.add("Initialize")
  widget.callbacks.add("Finished")
  widget.callbacks.add("AddSlide")
  widget.callbacks.add("Me")
  widget.callbacks.add("NotMe")
  widget.callbacks.add("AdvanceSlide")


  #######################
  # DATA
  #######################

  widget.data.slideValues = Array()
  
  widget.data.addSlide = (id, value)->
    widget.data.lastSlideTime = widget.data.currentSlideTime
    widget.data.currentSlideTime = new Date().getTime()
    widget.data.slideValues.push({
      id: id, 
      response: value, 
      time_taken: widget.data.currentSlideTime - widget.data.lastSlideTime
    })
    widget.data.sentSlides += 1
    if widget.data.slideValues.length % 10 == 0 || widget.data.sentSlides == widget.data.slidesToPlayLength
      Traitify.addSlides(widget.data.assessmentId, widget.data.slideValues, (response)->
        if widget.callbacks.addSlide
          widget.callbacks.addSlide(widget)
        if widget.data.sentSlides == widget.data.slidesToPlayLength
          widget.nodes().main.innerHTML = ""
          if options.showResults != false
            widget.nodes().main.innerHTML = Traitify.ui.styles
            Traitify.getPersonalityTypes(widget.data.assessmentId).then((data)->
              widget.Widgets().results.data = data
              widget.Widgets().results.run()
              if widget.Widgets().personalityTypes
                widget.Widgets().personalityTypes.data = data
                widget.Widgets().personalityTypes.run()
              if widget.Widgets().personalityTraits
                Traitify.getPersonalityTraits(widget.data.assessmentId).then((data)->  
                  widget.Widgets().personalityTraits.data.traits = data
                  widget.Widgets().personalityTraits.run()
                )
            )
          widget.callbacks.trigger("Finished")
      )


  widget.data.getProgressBarNumbers = (initialize)->
    slideLength = widget.data.slides.all.length
    currentLength = widget.data.slides.notCompleted.length 
    currentPosition = currentLength - widget.data.sentSlides
    if !initialize
      currentPosition += 1
    (1 - (currentPosition / slideLength)) * 100

  #########################  
  # PARTIALS
  #########################
  widget.views.add("slideDeckContainer", ->
    slidesContainer = @tags.div("tfSlideDeckContainer")
    cover = @tags.div("cover")
    cover.innerHTML = "Landscape mode is not currently supported"
    slidesContainer.appendChild(cover)
    
    slidesLeft = widget.data.getProgressBarNumbers("initializing")

    slidesContainer.appendChild(widget.views.render("progressBar", slidesLeft))

    slidesContainer.appendChild(@render("slides", widget.data.slides.all))

    slidesContainer.appendChild(@render("meNotMe"))
    slidesContainer
  )

  widget.views.add("meNotMe", ->
    meNotMeContainer = @tags.div("meNotMeContainer")
    widget.nodes().me = @tags.div("me")
    widget.nodes().notMe = @tags.div("notMe")
    widget.nodes().notMe.innerHTML = "NOT ME"
    widget.nodes().me.innerHTML = "ME"
    meNotMeContainer.appendChild(widget.nodes().me)
    meNotMeContainer.appendChild(widget.nodes().notMe)
    widget.nodes().meNotMeContainer = meNotMeContainer
    
    meNotMeContainer
  )
  widget.views.add("slides", (slidesData)->
    slides = @tags.div("slides")
    placeHolderSlide = widget.views.render("slide", slidesData[0])
    placeHolderSlide.className += " placeholder"
    slides.appendChild(placeHolderSlide)

    widget.nodes().currentSlide = widget.views.render("slide", slidesData[0])
    widget.nodes().currentSlide.className += " active"
    slides.appendChild(widget.nodes().currentSlide)

    if slidesData[1]
      widget.nodes().nextSlide = widget.views.render("slide", slidesData[1])
      slides.appendChild(widget.nodes().nextSlide)
    else
      widget.nodes().nextSlide = false

    widget.nodes().slides = slides

    slides
  )
  widget.views.add("slide", (slideData)->
    slide = @tags.div("slide")
    slideCaption = @tags.div("caption")
    slideCaption.innerHTML = slideData.caption

    slideImg = @tags.div(["slide.image"], {
      style:{
        backgroundImage: "url('#{slideData.image_desktop_retina}')",
        backgroundPosition:"#{slideData.focus_x}% #{slideData.focus_y}%;"
      } 
    })
    slideImg.appendChild(slideCaption)

    slide.appendChild(slideImg)

    slide
  )

  widget.views.add("progressBar", (percentFinished)->
    progressBar = @tags.div("progress-bar")
    progressBarInner = @tags.div("progress-bar-inner")
    progressBarInner.style.width = percentFinished + "%"
    progressBar.appendChild(progressBarInner)

    widget.nodes().progressBar = progressBar
    widget.nodes().progressBarInner = progressBarInner

    progressBar
  )

  widget.views.add("loadingAnimation", ->
    @tags.div("loading")
    @tags.div("symbol").appendTo("loading")
    @tags.i("leftDot").appendTo("symbol")
    @tags.i("rightDot").appendTo("symbol")
    
    @tags.get("loading")
  )

    
  ##########################
  # HELPERS
  ##########################
  touched = Object()
  widget.helpers.add("touch", (touchNode, callBack)->
    touchNode.addEventListener('touchstart', (event)->
      touchobj = event.changedTouches[0]
      touched.startx = parseInt(touchobj.clientX)
      touched.starty = parseInt(touchobj.clientY)
      
    )
    touchNode.addEventListener('touchend', (event)->
      debugger
      touchobj = event.changedTouches[0]
      touchDifferenceX = Math.abs(touched.startx - parseInt(touchobj.clientX))
      touchDifferenceY = Math.abs(touched.starty - parseInt(touchobj.clientY))
      if (touchDifferenceX < 2 && touchDifferenceX < 2)   
        callBack()
    )
  )
  widget.helpers.add("onload", (callBack)->
    if (window.addEventListener)
        window.addEventListener('load', callBack)
    else if (window.attachEvent)
        window.attachEvent('onload', callBack)
  )
    
  ###########################
  # EVENTS
  ###########################
  widget.actions.add("me", ->
    if !widget.states.get("animating") && widget.nodes().nextSlide
      if !widget.data.slides.all[widget.data.currentSlide] 
        widget.actions.trigger("loadingAnimation")
      widget.states.set("animating", true)

      widget.actions.trigger("advanceSlide")

      currentSlide = widget.data.slides.all[widget.data.currentSlide - 1]

      widget.data.addSlide(currentSlide.id, true)

      widget.data.currentSlide += 1

      widget.callbacks.trigger("Me")
  )

  widget.actions.add("notMe", ->
    if !widget.states.get("animating") && widget.nodes().nextSlide

      if !widget.data.slides.all[widget.data.currentSlide] 

        widget.actions.trigger("loadingAnimation")

      widget.states.set("animating", true)
      widget.actions.trigger("advanceSlide")

      currentSlide = widget.data.slides.all[widget.data.currentSlide - 1]

      widget.data.addSlide(currentSlide.id, false)

      widget.data.currentSlide += 1

      widget.callbacks.trigger("notMe")
  )

  widget.actions.add("advanceSlide", ->
    widget.prefetchSlides()
    widget.nodes().progressBarInner.style.width = widget.data.getProgressBarNumbers() + "%"

    if widget.nodes().playedSlide
      # REMOVE NODE
      widget.nodes().slides.removeChild(widget.nodes().playedSlide)

    widget.nodes().playedSlide = widget.nodes().currentSlide

    widget.nodes().currentSlide = widget.nodes().nextSlide
    
    widget.nodes().currentSlide.addEventListener('webkitTransitionEnd', (event)-> 
      widget.actions.trigger("advancedSlide")
      widget.states.set("animating", false)
      widget.states.set("transitionEndListens", true)
    , false )

    widget.nodes().currentSlide.addEventListener('transitionend', (event)-> 
      widget.actions.trigger("advancedSlide")
      widget.states.set("animating", false)
    , false )
  
    widget.nodes().currentSlide.addEventListener('oTransitionEnd', (event)-> 
      widget.events.trigger("advancedSlide")
      widget.states.set("animating", false)
    , false )
  
    widget.nodes().currentSlide.addEventListener('otransitionend', (event)-> 
      widget.actions.trigger("advancedSlide")
      widget.states.set("animating", false)
    , false )
  
    widget.nodes().playedSlide.className += " played"
    widget.nodes().currentSlide.className += " active"
    # NEW NEXT SLIDE
    nextSlideData = widget.data.slides.all[widget.data.currentSlide + 1]
    if nextSlideData
      widget.nodes().nextSlide = widget.views.render("slide", nextSlideData)
      widget.nodes().slides.appendChild(widget.nodes().nextSlide)

    if widget.callbacks.advanceSlide
      widget.callbacks.advanceSlide(widget)
  )

  widget.actions.add("loadingAnimation", ->
    widget.nodes().meNotMeContainer.className += " hide"
    widget.nodes().slides.removeChild(widget.nodes().currentSlide)
    widget.nodes().slides.insertBefore(widget.views.render("loadingAnimation"), widget.nodes().slides.firstChild)
  )

  widget.imageCache = Object()
  widget.prefetchSlides = (count)->
    start = widget.data.currentSlide - 1
    end = widget.data.currentSlide + 9

    for slide in widget.data.slides.all.slice(start, end)
      unless widget.imageCache[slide.image_desktop_retina]
        widget.imageCache[slide.image_desktop_retina] = new Image()
        widget.imageCache[slide.image_desktop_retina].src = slide.image_desktop_retina

  widget.actions.add("setContainerSize", ->
      width = widget.nodes().main.scrollWidth
      widget.nodes().container.className = widget.nodes().container.className.replace(" medium", "")
      widget.nodes().container.className = widget.nodes().container.className.replace(" large", "")
      widget.nodes().container.className = widget.nodes().container.className.replace(" small", "")
      if width < 480
        widget.nodes().container.className += " small"
      else if width < 768
        widget.nodes().container.className += " medium"
  )

  widget.actions.add("onRotate", (rotateEvent)->
    supportsOrientationChange = "onorientationchange" of window
    orientationEvent = (if supportsOrientationChange then "orientationchange" else "resize")
    window.addEventListener(orientationEvent, (event)->
      rotateEvent(event)
    , false)
  )  

  widget.initialization.events.add("Setup Data", ->
    widget.data.currentSlide = 1

    widget.data.slides.all = widget.data.slides.notCompleted.concat(widget.data.slides.completed)
    widget.data.sentSlides = 0

    widget.data.slidesToPlayLength = widget.data.slides.notCompleted.length

  )
      
  widget.initialization.events.add("Handle device type", ->
    widget.nodes().container = widget.views.render("slideDeckContainer")
    if widget.device
      widget.nodes().container.className += " #{widget.device}"
      widget.nodes().container.className += " mobile phone"
      widget.nodes().container.className += " non-touch"

    if options && options.size
      widget.nodes().container.className += " #{options.size}"
    widget.nodes().main.appendChild(widget.nodes().container)
  )

  widget.initialization.events.add("Actions", ->
    if widget.device == "iphone"  ||  widget.device == "ipad" 
      widget.helpers.touch(widget.nodes().notMe, ->
        widget.events.trigger("notMe")
      )
      widget.helpers.touch(widget.nodes().me, ->
        widget.events.trigger("me")
      )
    else
      widget.nodes().notMe.onclick = ->
        widget.actions.trigger("notMe")

      widget.nodes().me.onclick = ->
        widget.actions.trigger("me")
  )


  widget.initialization.events.add("Prefetch Slides", ->
    widget.prefetchSlides()
  )


  widget.initialization.events.add("Setup Screen", ->
    widget.actions.trigger("setContainerSize")

    window.onresize = ->
      if !widget.device
        widget.actions.trigger("setContainerSize")

    if widget.device && widget.device
      setupScreen = ->
        windowOrienter = ->
            widget.nodes().main.style.height = window.innerHeight + "px"
        windowOrienter()

      widget.actions.trigger("onRotate", (event)->
        windowOrienter()
      )

      widget.helpers.onload( ->
        setupScreen()
      )

      setupScreen()
  )

  widget.initialization.events.add("initialized", ->
    widget.states.set("initialized", true)
    widget.callbacks.trigger("Initialize")
    widget.data.currentSlideTime = new Date().getTime()
  )

  widget