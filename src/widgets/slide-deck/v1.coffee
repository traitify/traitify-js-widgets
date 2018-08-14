Traitify.ui.widget("slideDeck", (widget, options = Object())->
  widget.data.add("slideResponses", Object())
  widget.states.add("animating")
  widget.states.add("finished")
  widget.states.add("initialized")
  widget.states.add("transitionEndListens")
  widget.states.add("imageWaiting")
  widget.callbacks.add("Initialize")
  widget.callbacks.add("Finished")
  widget.callbacks.add("AddSlide")
  widget.callbacks.add("Me")
  widget.callbacks.add("NotMe")
  widget.callbacks.add("AdvanceSlide")
  widget.data.persist("slideValues")
  widget.data.add("imageCache", Array())
  widget.data.add("fetchErroring")
  widget.styleDependency("all")
  widget.styleDependency("slide-deck")
  widget.states.add("trying", true)

  #######################
  # DATA DEPENDENCIES
  #######################
  widget.dataDependency("Slides")

  #######################
  # DATA
  #######################
  if !widget.data.get("slideValues")
    widget.data.add("slideValues", Array())

  widget.actions.add("processSlide", (options)->
    widget.data.set("lastSlideTime", widget.data.get("currentSlideTime"))
    widget.data.set("currentSlideTime", new Date().getTime())
    slideValues = widget.data.get("slideValues")
    slideValues.push({
      id: options.id,
      response: options.value,
      time_taken: widget.data.get("currentSlideTime") - widget.data.get("lastSlideTime")
    })
    widget.data.set("slideValues", slideValues)


    widgets = widget.widgets
    widget.data.counter("sentSlides").up()
    sentSlides = widget.data.get("sentSlides")

    if widget.data.get("slideValues").length % 10 == 0 || sentSlides == widget.data.get("slidesToPlayLength")
      addSlide = Traitify.addSlides(widget.assessmentId, widget.data.get("slideValues"))

      currentSlides = widget.data.get("slideValues")
      widget.data.set("slideValues", Array())
      addSlide.then((response)->
        widget.callbacks.trigger("addSlide")
        if sentSlides == widget.data.get("slidesToPlayLength")
          widget.nodes.get("main").innerHTML = ""
          widget.options ?= Object()
          widget.options.slideDeck ?= Object()
          if widget.options && widget.options.slideDeck.showResults != false
            widgets = widget.widgets

            if widgets.personalityTypes
              callbacks = widgets.personalityTypes.callbacks
              widgets.personalityTypes = Traitify.ui.load("personalityTypes", widget.assessmentId, widgets.personalityTypes.target || widget.target, widgets.personalityTypes.options)
              widgets.personalityTypes.callbacks = callbacks
            if widgets.personalityTraits
              callbacks = widgets.personalityTraits.callbacks
              widgets.personalityTraits = Traitify.ui.load("personalityTraits", widget.assessmentId, widgets.personalityTraits.target || widget.target, widgets.personalityTraits.options)
              callbacks = widgets.personalityTraits.callbacks
              widgets. personalityTraits.callbacks = callbacks
            if widgets.results
              callbacks = widgets.results.callbacks
              widgets.results = Traitify.ui.load("results", widget.assessmentId, widgets.results.target || widget.target, widgets.results.options)
              widgets.results.callbacks = callbacks
            if widgets.famousPeople
              callbacks = widgets.famousPeople.callbacks
              widgets.famousPeople = Traitify.ui.load("famousPeople", widget.assessmentId, widgets.famousPeople.target || widget.target, widgets.famousPeople.options)
              widgets.famousPeople.callbacks = callbacks

          widget.callbacks.trigger("Finished")
      ).catch(->
        console.log("internet offline")
        widget.data.set("slideValues", widget.data.get("slideValues").concat(currentSlides))
      )
  )

  widget.helpers.add("getProgressBarNumbers", (initialize)->
    slideLength = widget.data.get("Slides").length
    completed = widget.data.get("SlidesCompleted").length 
    notCompleted = widget.data.get("SlidesNotCompleted").length 
    currentPosition = completed + widget.data.get("sentSlides")
    if !initialize
      currentPosition += 1

    Math.round((currentPosition / slideLength) * 100)
  )

  widget.views.add("internetFailure", ->
    widget.views.render("wifiLoading")
    loadingInner = @tags.get("loading").innerHTML
    @tags.get("loading").innerHTML = ""
    @tags.div("refreshButton", "Refresh").appendTo("loading")
    @tags.get("refreshButton").onclick = ->
      widget.views.tags.get("loading").innerHTML = loadingInner
      widget.actions.trigger("fetchNext")
    @tags.get("wifiLoading")
  )

  widget.views.add("wifiLoading", ->
    unless @tags.get("wifiLoading")
      @tags.div("wifiLoading")
      @tags.div("loading").appendTo("wifiLoading")
      @tags.div("loadingText", "Loading").appendTo("loading")
    @tags.get("wifiLoading")
  )

  #########################
  # PARTIALS
  #########################
  widget.views.add("slideDeckContainer", ->
    slidesContainer = @tags.div("tfSlideDeckContainer")
    cover = @tags.div("cover")
    @tags.tag("rotateBack", "object", {"data":"https://cdn.traitify.com/assets/images/js/landscape-phone.svg",type:"image/svg+xml" }).appendTo("cover")
    slidesContainer.appendChild(cover)

    slidesLeft = widget.helpers.getProgressBarNumbers("initializing")

    slidesContainer.appendChild(widget.views.render("progressBar", slidesLeft))

    slidesContainer.appendChild(@render("slides", widget.data.get("SlidesNotCompleted")))

    slidesContainer.appendChild(@render("meNotMe"))

    slidesContainer
  )

  widget.views.add("meNotMe", ->
    @tags.div("meNotMeContainerAttachment")
    @tags.div("meNotMeContainer").appendTo("meNotMeContainerAttachment")
    @tags.div("me").appendTo("meNotMeContainer")
    @tags.div("notMe").appendTo("meNotMeContainer")
    widget.nodes.get("notMe").innerHTML = "NOT ME"
    widget.nodes.get("me").innerHTML = "ME"

    @tags.get("meNotMeContainerAttachment")
  )

  widget.views.add("slides", (slidesData)->
    slides = @tags.div("slides")
    placeHolderSlide = widget.views.render("slide", slidesData[0])
    placeHolderSlide.appendTo("slides")
    placeHolderSlide.className += " placeholder"

    widget.nodes.set("currentSlide", widget.views.render("slide", slidesData[0]))
    widget.nodes.get("currentSlide").className += " active"
    widget.nodes.get("currentSlide").appendTo("slides")

    if slidesData[1]
      widget.nodes.set("nextSlide", widget.views.render("slide", slidesData[1]))
      widget.nodes.get("nextSlide").appendTo("slides")

    widget.nodes.set("slides", slides)

    slides
  )

  widget.views.add("slide", (slideData)->
    slide = @tags.div("slide")

    slideCaption = @tags.div("caption")
    slideCaption.innerHTML = slideData.caption || ""
    image = slideData.image_desktop_retina || ""
    slideImg = @tags.div(["slide.image"], {
      style:{
        backgroundImage: "url('#{image}')",
        backgroundPosition:"#{slideData.focus_x || ""}% #{slideData.focus_y || ""}%"
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

    widget.nodes.set("progressBar", progressBar)
    widget.nodes.set("progressBarInner", progressBarInner)

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
  widget.data.add("touched", Object())
  widget.helpers.add("touch", (touchNode, callBack)->
    touched = widget.data.get("touched")
    touchNode.addEventListener('touchstart', (event)->
      touchobj = event.changedTouches[0]
      touched.startx = parseInt(touchobj.clientX)
      touched.starty = parseInt(touchobj.clientY)

    )
    touchNode.addEventListener('touchend', (event)->
      touchobj = event.changedTouches[0]
      touchDifferenceX = Math.abs(touched.startx - parseInt(touchobj.clientX))
      touchDifferenceY = Math.abs(touched.starty - parseInt(touchobj.clientY))
      if (touchDifferenceX < 60 && touchDifferenceX < 60)   
        callBack()
    )
  )

  widget.helpers.add("onload", (callBack)->
    if (window.addEventListener)
      window.addEventListener('load', callBack)
  )

  ###########################
  # EVENTS
  ###########################
  widget.actions.add("me", ->
    currentSlide = widget.data.get("SlidesNotCompleted")[widget.data.get("currentSlide") - 1]
    afterNextSlide = widget.data.get("SlidesNotCompleted")[widget.data.get("currentSlide") + 1]

    if !widget.states.get("animating") && widget.nodes.get("nextSlide") && currentSlide && widget.actions.trigger("cacheCheck?")
      if !widget.data.get("SlidesNotCompleted")[widget.data.get("currentSlide")]
        widget.actions.trigger("loadingAnimation")
      widget.states.set("animating", true)
      widget.actions.trigger("advanceSlide")

      widget.actions.trigger("processSlide", id: currentSlide.id, value: true)

      widget.data.counter("currentSlide").up()

      widget.callbacks.trigger("Me")
    else if !widget.states.get("animating") && widget.nodes.get().nextSlide && currentSlide
      widget.actions.trigger("setWifiLoading", true)
      widget.actions.trigger("failSlideAnimation")
  )

  widget.actions.add("notMe", ->
    currentSlide = widget.data.get("SlidesNotCompleted")[widget.data.get("currentSlide") - 1]
    afterNextSlide = widget.data.get("SlidesNotCompleted")[widget.data.get("currentSlide") + 1]

    if !widget.states.get("animating") && widget.nodes.get("nextSlide") && currentSlide && widget.actions.trigger("cacheCheck?")
      if !widget.data.get("SlidesNotCompleted")[widget.data.get("currentSlide")] 
        widget.actions.trigger("loadingAnimation")

      widget.states.set("animating", true)
      widget.actions.trigger("advanceSlide")

      currentSlide = widget.data.get("SlidesNotCompleted")[widget.data.get("currentSlide") - 1]

      widget.actions.trigger("processSlide", id: currentSlide.id, value: false)

      widget.data.counter("currentSlide").up()

      widget.callbacks.trigger("notMe")
    else if !widget.states.get("animating") && widget.nodes.get().nextSlide && currentSlide
      widget.actions.trigger("setWifiLoading", true)
      widget.actions.trigger("failSlideAnimation")
  )

  widget.actions.add("advanceSlide", ->
    widget.nodes.get("progressBarInner").style.width = widget.helpers.getProgressBarNumbers() + "%"

    if widget.nodes.get("playedSlide")
      # REMOVE NODE
      widget.nodes.get("slides").removeChild(widget.nodes.get("playedSlide"))

    widget.nodes.set("playedSlide", widget.nodes.get("currentSlide"))

    widget.nodes.set("currentSlide", widget.nodes.get("nextSlide"))

    callback = (event)->
      widget.actions.trigger("advancedSlide")
      widget.states.set("animating", false)
    if !Traitify.oldIE
        widget.nodes.get("currentSlide").addEventListener('webkitTransitionEnd', callback, false)
        widget.nodes.get("currentSlide").addEventListener('transitionend', callback, false)
        widget.nodes.get("currentSlide").addEventListener('oTransitionEnd', callback, false)
        widget.nodes.get("currentSlide").addEventListener('otransitionend', callback, false )

    if Traitify.oldIE
        callback()

    widget.nodes.get("playedSlide").className += " played"
    widget.nodes.get("currentSlide").className += " active"
    # NEW NEXT SLIDE
    nextSlideData = widget.data.get("SlidesNotCompleted")[widget.data.get("currentSlide") + 1]
    if nextSlideData
      widget.nodes.set("nextSlide", widget.views.render("slide", nextSlideData))
      widget.nodes.get("slides").appendChild(widget.nodes.get().nextSlide)

      widget.callbacks.trigger("AdvanceSlide")
  )

  widget.actions.add("loadingAnimation", ->
    widget.nodes.get("meNotMeContainer").className += " hide"
    widget.nodes.get("slides").removeChild(widget.nodes.get("currentSlide"))
    widget.nodes.get("slides").insertBefore(widget.views.render("loadingAnimation"), widget.nodes.get("slides").firstChild)
  )

  widget.data.add("imageCache", Object())
  widget.actions.add("prefetchSlides", ->
    widget.data.add("slideIndex", 0)
    widget.actions.trigger("fetchNext")
  )

  widget.actions.add("fetchNext", ->
      widget.data.set("fetchErroring", false)
      slides = widget.data.get("SlidesNotCompleted")

      slide = slides[widget.data.get("slideIndex")]
      image = new Image()
      image.id = slide.id

      image.onerror = ->
        unless widget.data.get("fetchErroring")
          widget.data.set("fetchSlides", true)
          widget.data.set("fetchErroring", true)
          setTimeout(->
            unless  widget.actions.trigger("cacheCheck?")
                widget.data.set("fetchSlides", false)
                widget.actions.trigger("setWifiLoading", false)
                widget.views.render("internetFailure").appendTo("meNotMeContainer")
          , 30000)
        onload = @onload
        onerror = @onerror
        src = @src
        if widget.data.get("fetchSlides")
          setTimeout(->
            errorImage = new Image()
            errorImage.onload = onload
            errorImage.onerror = onerror
            errorImage.src = src
          , 1000)

      image.onload = ->
        widget.data.get("imageCache")[@src] = true
        widget.data.counter("slideIndex").up()

        if widget.data.get("SlidesNotCompleted")[widget.data.get("slideIndex")]
          widget.actions.trigger("fetchNext")
        if widget.actions.trigger("cacheCheck?")
          widget.actions.trigger("setWifiLoading", false)

      image.src = slide.image_desktop_retina
  )

  widget.actions.add("cacheCheck?", ->
    currentSlide = widget.data.get("SlidesNotCompleted")[widget.data.get("currentSlide") + 1]
    if currentSlide
      widget.data.get("imageCache")[currentSlide.image_desktop_retina]
    else if widget.data.get("currentSlide") + 1 >= widget.data.get("SlidesNotCompleted").length
      true
  )

  widget.actions.add("setWifiLoading", (value)->
    if value
      wifiLoading = widget.views.render("wifiLoading")
      wifiLoading.className += " fade-in"
      wifiLoading.appendTo("meNotMeContainer")
      
    else if widget.views.tags.get("wifiLoading")
      widget.views.tags.get("wifiLoading").parentNode.removeChild(widget.views.tags.get("wifiLoading"))
      widget.views.tags.library.set("wifiLoading", null)
  )
  widget.actions.add("failSlideAnimation", ->
    widget.nodes.get("currentSlide").className = widget.nodes.get("currentSlide").className + " not-ready-animation"
  )
  widget.actions.add("setContainerSize", ->
      width = widget.nodes.get("main").scrollWidth
      widget.nodes.get("container").className = widget.nodes.get("container").className.replace(" medium", "")
      widget.nodes.get("container").className = widget.nodes.get("container").className.replace(" large", "")
      widget.nodes.get("container").className = widget.nodes.get("container").className.replace(" small", "")
      if width < 480
        widget.nodes.get("container").className += " small"
      else if width < 768
        widget.nodes.get("container").className += " medium"
  )

  widget.actions.add("onRotate", (rotateEvent)->
    supportsOrientationChange = "onorientationchange" of window
    orientationEvent = (if supportsOrientationChange then "orientationchange" else "resize")
    window.addEventListener(orientationEvent, (event)->
      rotateEvent(event)
    , false)
  )  

  widget.initialization.events.add("Setup Data", ->
    slides = widget.data.get("Slides")


    playedSlideIds = widget.data.get("slideValues").map((slide)-> slide.id)
    
    widget.data.add("currentSlide", 1)

    completed = widget.data.get("Slides").filter((slide)-> 
      slide.response || playedSlideIds.indexOf(slide.id) != -1
    )
    uncompleted = widget.data.get("Slides").filter((slide)-> 
      !slide.response && playedSlideIds.indexOf(slide.id) == -1
    )

    widget.data.add("SlidesCompleted", completed)
    widget.data.add("SlidesNotCompleted", uncompleted)
    widget.data.add("sentSlides", 0)

    widget.data.add("slidesToPlayLength", widget.data.get("SlidesNotCompleted").length)

  )
      
  widget.initialization.events.add("Handle device type", ->
    widget.nodes.set("container", widget.views.render("slideDeckContainer"))
    if widget.device
      widget.nodes.get("container").className += " #{widget.device}"
      widget.nodes.get("container").className += " mobile phone"
      widget.nodes.get("container").className += " non-touch"

    if options && options.size
      widget.nodes.get("container").className += " #{options.size}"

    widget.nodes.get("main").appendChild(widget.nodes.get().container)

    unless widget.actions.trigger("cacheCheck?")
      widget.actions.trigger("setWifiLoading", true)
  )

  widget.initialization.events.add("Actions", ->
    if widget.device == "iphone"  ||  widget.device == "ipad" 
      widget.helpers.touch(widget.nodes.get("notMe"), ->
        widget.actions.trigger("notMe")
      )
      widget.helpers.touch(widget.nodes.get("me"), ->
        widget.actions.trigger("me")
      )
    else
      widget.nodes.get("notMe").onclick = ->
        widget.actions.trigger("notMe")

      widget.nodes.get("me").onclick = ->
        widget.actions.trigger("me")
  )


  widget.initialization.events.add("Prefetch Slides", ->
    widget.actions.trigger("prefetchSlides")
  )


  widget.initialization.events.add("Setup Screen", ->
    widget.actions.trigger("setContainerSize")
  
    window.onresize = ->
      if !widget.device
        widget.actions.trigger("setContainerSize")

    if widget.device && widget.device
      setupScreen = ->
        widget.helpers.add("windowOrienter", ->
          widget.nodes.get("main").style.height = window.innerHeight + "px"
        )
        widget.helpers.windowOrienter()

      widget.actions.trigger("onRotate", (event)->
        widget.helpers.windowOrienter()
      )

      widget.helpers.onload( ->
        setupScreen()
      )

      setupScreen()
  )

  widget.initialization.events.add("initialized", ->
    widget.states.set("initialized", true)
    widget.callbacks.trigger("Initialize")

    widget.data.add("currentSlideTime", new Date().getTime())
  )

)
