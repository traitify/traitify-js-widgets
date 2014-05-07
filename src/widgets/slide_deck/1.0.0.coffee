window.Traitify.ui.slideDeck = (assessmentId, selector, slideDeckCallBack)->
  slideLock = false

  orientation = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
  ipad = /iPad/.test(navigator.userAgent)

  slideDeck = Object()

  unless @host
    @host = "https://api-staging.traitify.com"

  ###
  HELPERS
  ###
  tag = (type, attributes, content) ->

    #prepare tag attributes
    preparedAttributes = Array()
    for key of attributes
      value = attributes[key]
      preparedAttributes.push key + "=\"" + value + "\""
    attributes = attributes or Array()
    if content is false
      "<" + type + " " + preparedAttributes.join(" ") + " />"
    else
      "<" + type + " " + preparedAttributes.join(" ") + ">\n" + content + "\n</" + type + ">"
  div = (attributes, content) ->
    tag "div", attributes, content
  image = (src, attributes) ->
    attributes["src"] = src
    tag "img", attributes, false
  link = (href, attributes, content) ->
    attributes["href"] = href
    tag "a", attributes, content
  style = (content) ->
    tag "style", {}, content
  styling = (selector, content) ->
    formattedContent = Array()
    for key of content
      formattedContent.push key + ":" + content[key] + ";"
    if selector.indexOf('&') != -1
      selector = slideDeck.classes() + selector.replace("&", "")
    else
      selector = slideDeck.classes() + " " + selector  
    selector + "{\n" + formattedContent.join("\n") + "}"
  media = (arg, content) ->
    for i of arg
      arg = i + ":" + arg[i]
    "@media screen and (" + arg + ")"
  fetch = (className) ->
    slideDeck.element.getElementsByClassName className

  ###
  MAIN
  ###

  ###
  Styles
  ###
  styles = () ->
    slideHeight = if orientation then  "40em" else "22.5em"
    styles = Array()

    styles.push styling("", 
      "font-family": '"Helvetica Neue", Helvetica,Arial, sans-serif',
      "text-align":"center",
      "margin":"1em"
    )
    styles.push styling(".slide-deck",
      "text-align":"center"
      "padding":"1em",
      "margin": "0px auto",
      "display": "inline-block",
      "border": "1px solid #dcdcdc",
      "background-color":"#fff",
      "border-radius":".5em",
    )
    styles.push styling(".slide .image",
      width: "40em"
      height: slideHeight
      "line-height":"1em"
    )

    styles.push styling(".slide .caption",
      "text-align": "center"
      "background-color": "#1b1b1b"
      color: "#fff"
      padding: ".8em 0px"
    )
    styles.push styling(".slide",
      display: "inline-block"
    )
    styles.push styling(".slide-container",
      width: "40em"
      overflow: "hidden"
      position: "relative"
      display: "inline-block"
      "vertical-align":"middle"
      "float":"left"
    )
    styles.push styling(".me, .not-me",
      width: "50%"
      display: "inline-block"
      padding: "1em 0em"
      "text-align": "center"
      color: "#fff"
      "text-decoration": "none"
    )
    styles.push styling(".me:hover, .not-me:hover",
      "text-decoration": "none"
      color: "#fff"
    )
    styles.push styling(".me",
      "background-color": "#3f6fef"
    )
    styles.push styling(".not-me",
      "background-color": "#ef3f2f"
    )
    styles.push styling(".slides",
      display: "inline-block"
      "text-align": "left"
      width: (slideDeck.fetch("slide").length * 40) + "em"
    )
    styles.push styling(".progress-bar",
      "height": ".5em",
      "width": "40em",
      "font-size":"inherit",
      "display": "inline-block",
      "background-color":"#f0f0f0",
      "box-shadow":".1em .1em .2em .01em #ccc inset",
      "overflow": "hidden",
      "text-align":"left",
      "transition":"none",
      "-webkit-transition":"none"
    )
    styles.push styling(".inner-progress-bar",
      "height": ".5em",
      "width": "0%",
      "display": "inline-block",
      "background-color":"#888",
      "float":"left"
    )
    styles.push styling(".me.side",
      "position": "relative",
      "width":"3.6em",
      "height":"16.1em",
      "float":"left",
      "margin-top":".4em",
      "display":"none"
    )
    styles.push styling(".not-me.side",
      "position": "relati ve",
      "width":"3.6em",
      "height":"16.1em",
      "float":"left",
      "margin-top":".4em",
      "display":"none",
      "text-align":"center"
    )
    styles.push styling(".me.side .text",
      "margin-top":"6em"
    )
    styles.push styling(".not-me.side .text", 
      "margin-top":"5.7em"
    )


    # PHONE
    styles.push styling("&.phone .me.bottom",
      "display": "inline-block" 
    )
    styles.push styling("&.phone .not-me.bottom",
      "display": "inline-block"
    )
    styles.push styling("&.phone .me.side",
      "display": "none"
    )
    styles.push styling("&.phone .not-me.side",
      "display": "none" 
    )
    styles.push styling("&.phone .slide .caption",
      "font-size": "1.6em"
    )

    styles.push styling("&.phone .me.bottom",
      "font-size": "1.6em"
    )

    styles.push styling("&.phone .not-me.bottom",
      "font-size": "1.6em"
    )

    # PHONE ROTATED ME NOT ME
    styles.push styling("&.phone.rotated .me.side",
     "display": "inline-block"
    )
    styles.push styling("&.phone.rotated .not-me.side",
      "display": "inline-block"
    )
    styles.push styling("&.phone.rotated .me.bottom",
     "display": "none"
    )
    styles.push styling("&.phone.rotated .not-me.bottom",
      "display": "none"
    )

    # PHONE ROTATED PROGRESS BAR
    styles.push styling("&.phone.rotated .progress-bar",
     "width": "16.5em",
     "height":".4em",
     "background-color":"#cfcfcf",
     "border-radius":"0em"
    )

    # PHONE ROTATED SLIDES
    styles.push styling("&.phone.rotated .slide",
     "width": "16.5em",
     "height": "16.5em"
    )
    styles.push styling("&.phone.rotated .slide-container",
     "width": "16.5em",
     "height": "16.5em"
    )
    styles.push styling("&.phone.rotated .slide img",
     "width": "16.5em",
     "height": "16.5em"
    )
    styles.push styling("&.phone.rotated .slide .caption",
     "width": "16.5em",
     "font-size": "1em",
     "padding": ".2em"
    )
    # PHONE ROTATED SLIDE DECK
    styles.push styling("&.phone.rotated .slide-deck",
     "width": "26em",
     "height":"18.5em",
     "margin":"0px auto",
    )
    styles.push styling("&.ipad",
      "font-weight": "100"
    )
    styles.push styling("&.ipad.rotated .slide-deck",
      "font-size": "1.6em"
    )

    style styles.join("")

  ###
  Views
  ###
  partial = (partialName, args) ->
    partials[partialName] args

  ###
  CONTROLLER
  ###

  slideDeck.setProgressBar = ->
    slideDeck.fetch("inner-progress-bar")[0].style.width = (((slideDeck.slideLength - slideDeck.fetch("slide").length) / slideDeck.slideLength + 1) * 100) + "%"

  ###
  Events
  ###
  Actions = ->
    addSlideTimer = new Date()
    addSlide = (value) ->
      
      slideTime = new Date() - addSlideTimer
      slideId = slideDeck.currentSlide.getAttribute("data-id")
      Traitify.addSlide(assessmentId, slideId, value, slideTime, ->
        slideDeck.setProgressBar()
        if slideDeck.fetch("slide").length is 1 
          slideDeckCallBack()
          slideDeckCallBack = function(){}


        addSlideTimer = new Date()
      )


    advanceSlide = ->
      return false  if slideDeck.fetch("slide").length is 1
      left = -10
      ease = 20
      width = slideDeck.currentSlide.offsetWidth
      slideLeftAnimation = setInterval(->
        if left > -(width / 2) + 30
          ease = ease * 1.2
        else ease = ease / 1.17  if left < -(width / 2) - 30
        left = left - ease
        slideDeck.currentSlide.style["margin-left"] = left + "px"
        if left < -width
          slide = slideDeck.currentSlide
          slideDeck.fetch("slides")[0].removeChild slideDeck.currentSlide
          slideDeck.currentSlide = slideDeck.fetch("slide")[0]
          slideLock = false
          clearInterval slideLeftAnimation
        return
      , 40)
      false
    slideDeck.currentSlide = slideDeck.fetch("slide")[0]
    slideLock = false
    mes = slideDeck.fetch("me")
    for me in mes
      me.onclick = (event)->
        unless slideLock
          slideLock = true
          unless slideDeck.fetch("slide").length is 1
            advanceSlide()
            addSlide "true"
          else
            slideDeck.fetch("inner-progress-bar")[0].style.width = "100%"

        if event.preventDefault  then event.preventDefault() else event.returnValue = false

    slideDeck.resizeToFit = ->
      widthOfContainer = slideDeck.element.offsetWidth
      if slideDeck.element.offsetWidth == 0
        itm=slideDeck.element
        cln=itm.cloneNode(true)
        while cln.firstChild
            cln.removeChild(cln.firstChild);

        cln.style.visibility="hidden"
        document.body.appendChild(cln);

        widthOfContainer = cln.offsetWidth

        document.body.removeChild(cln);

      slideDeck.element.style.fontSize = widthOfContainer / 42 + "px"

    slideDeck.resizeToFit()
    

    oldOnResize = window.onresize
    window.onresize = (event) ->
      slideDeck.resizeToFit()
      oldOnResize.call window, event  if oldOnResize

      return

    notMes = slideDeck.fetch("not-me")
    for notMe in notMes
      notMe.onclick = (event)->
        unless slideLock
          slideLock = true
          advanceSlide()
          addSlide "false"
        if event.preventDefault  then event.preventDefault() else event.returnValue = false

    return




  #Phone
  phoneSetup = ->
    supportsOrientationChange = "onorientationchange" of window
    orientationEvent = (if supportsOrientationChange then "orientationchange" else "resize")

    if orientation
      classes = slideDeck.element.getAttribute("class") + if ipad then " ipad" else ""
      slideDeck.element.setAttribute("class", classes + " phone")

    window.addEventListener orientationEvent, (->
      setSlideDeckOrientation()
    )

    setSlideDeckOrientation = ->
      textSize = "1.2em"
      if orientation
        if window.orientation != 0
          classes = slideDeck.element.getAttribute("class")
          slideDeck.element.setAttribute("class", classes + " rotated")
        else
          classes = slideDeck.element.getAttribute("class")
          slideDeck.element.setAttribute("class", classes.replace(" rotated", ""))

        captions = slideDeck.fetch("caption")
    setSlideDeckOrientation()

  selector = (if selector then selector else @selector)
  unless selector.indexOf("#") is -1
    slideDeck.element = document.getElementById(selector.replace("#", ""))
  else
    slideDeck.element = document.getElementsByClassName(selector.replace(".", ""))[0]

  slideDeck.retina = window.devicePixelRatio > 1
  data = (attr) ->
    @element.getAttribute "data-" + attr

  html = (setter) ->
    slideDeck.element.innerHTML = setter  if setter
    slideDeck.element.innerHTML

  classes = ->
    classes = slideDeck.element.className.split(" ")
    for key of classes
      classes[key] = "." + classes[key]
    classes.join ""


  slideDeck.a = link
  slideDeck.div = div
  slideDeck.image = image
  slideDeck.fetch = fetch
  slideDeck.data = data
  slideDeck.html = html
  slideDeck.classes = classes
  slideDeck.slidesUrl = ->
    slideDeck.host + "/v1/assessments/" + assessmentId + "/slides"


  partials = Array()
  partials["slide"] = (args) ->
    caption = args.caption
    imageUrl = args.imageUrl
    id = args.id
    div
      class: "slide"
      "data-id": id
    , [
      div(
        class: "caption"
      , caption)
      image(imageUrl,
        class: "image"
      , imageUrl)
    ].join("")

  partials["slides"] = (data) ->

    slides = Array()
    for key of data
      if orientation
        imageSrc = data[key]["image_phone_landscape"]
      else
        imageSrc = data[key]["image_desktop"]

      if data[key].completed_at == null
        slides.push partial("slide",
          caption: data[key]["caption"]
          imageUrl: imageSrc
          id: data[key].id
        )

    slides.push partial("slide",
      caption: "&nbsp;"
      imageUrl: "https://s3.amazonaws.com/traitify-cdn/images/black_transparent/10.png"
      id: ""
    )
        

    slides = slides.join("")
    div
      class: "slides"
    , slides

  partials["me-not-me"] = ->
    link("#",
      class: "me bottom"
    , "Me") + link("#",
      class: "not-me bottom"
    , "Not Me")

  partials["slide-container"] = (data)->
    progressBar = div({class:"progress-bar"}, div(class:"inner-progress-bar", ""))
    slideContainer = div class: "slide-container", progressBar + partial("slides", data) + partial("me-not-me")
    link("#", {class: "me side"}, div({class:"text"}, "Me")) + slideContainer +  link("#", {class: "not-me side"}, div({class:"text"}, "Not<br />Me") ) + div({style:"clear:both"}, "")  

  Traitify.getSlides(assessmentId, (data)->
    slideDeck.slideLength = data.length
    slides = partial("slide-container", data)
    slideDeck.html div({class: "slide-deck"}, slides)

    slideDeck.html slideDeck.html() + styles()
    Actions()
    phoneSetup()

    slideDeck.setProgressBar()
    return
  )
  this
