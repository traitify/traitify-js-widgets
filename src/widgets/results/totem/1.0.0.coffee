window.Traitify.ui.resultsTotem = (assessmentId, selector, options)->
  partials = Array()

  totem = Object()
  
  # Select Canvas Object
  selector = (if selector then selector else @selector)

  unless selector.indexOf("#") is -1
    totem.element = document.getElementById(selector.replace("#", ""))
  else
    totem.element = document.getElementsByClassName(selector.replace(".", ""))[0]

  #retina settings
  totem.retina = window.devicePixelRatio > 1

  totem.data = (attr) ->
    totem.element.getAttribute "data-" + attr

  totem.html = (setter) ->
    console.log(totem.element)
    totem.element.innerHTML = setter  if setter
    totem.element.innerHTML


  totem.classes = ->
    classes = totem.element.className.split(" ")
    for key of classes
      if classes[key]
        classes[key] = "." + classes[key]
      else
        delete classes[key]

    classes.join ""











  ###################################
  # HELPERS
  ###################################
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
    totem.classes() + " " + selector + "{\n" + formattedContent.join("\n") + "}"
  media = (arg, content) ->
    for i of arg
      arg = i + ":" + arg[i]
    "@media screen and (" + arg + ")"
  fetch = (className) ->
    totem.element.getElementsByClassName className

  forEach = (iterator, callBack)->
    for key of itorator
      callBack(itorator[key])


























  ##############################
  # Styles
  ##############################
  styles = () ->
    style [
      styling(".badge",
        "width": "5em",
        "display": "inline-block",
        "vertical-align": "middle",
        "background-color":"transparent",
        "padding": "0px",
        "width":"3em",
        "height":"3em",
        "display": "inline-block",
        "position":"relative",
        "z-index":"1",
        "vertical-align": "middle",
        "margin":".5em 0em",
        "background-position":"center",
        "font-size":"1em"
      ),
      styling(".panels-container",
        "height": "6em",
        "width": "11.6em",
        "display": "inline-block",
        "vertical-align": "middle",
        "background-color":"transparent",
      ),
      styling(".panels-container:hover",
        "font-weight":"200",
        "font-size":"1.1em",
        "position":"relative",
        "z-index":"2"
      ),
      styling(".panels-container.active",
        "font-weight":"200",
        "font-size":"1.1em",
        "position":"relative",
        "z-index":"3"
      ),
      styling(".left-panel",
        "height": "6em",
        "width": "5.8em",
        "display": "inline-block",
        "vertical-align": "middle",
        "background-color":"transparent"
      ),
      styling(".right-panel",
        "height": "6em",
        "width": "5.8em",
        "display": "inline-block",
        "vertical-align": "middle",
        "background-color":"transparent",
        "text-align":"right"
      ),
      styling(".positive-bar",
        "height": "1em",
        "width": "12em",
        "display": "inline-block",
        "overflow": "hidden",
        "margin-top":"2.5em"
      ),
      styling(".negative-bar",
        "height": "1em",
        "width": "12em",
        "display": "inline-block",
        "overflow": "hidden"
      ),
      styling(".personality",
        "display": "inline-block",
        "font-weight":"100",
        "height":"6em"
      ),
      styling(".totem-results",
        "line-height":"1em",
        "width": "41em",
        "padding": "1em 0em",
        "padding-bottom": "1.8em",
        "display": "inline-block",
        "background-color":"#fff",
        "border-radius":".5em",
        "font-family":'"Helvetica Neue", Helvetica,Arial, sans-serif'
        "background-color": "transparent",
        "box-sizing":"initial"
      ),
      styling("",
        "text-align":"center"

      ),
      styling(".negative-bar .bar-tip",
        "height": "1em",
        "display":"inline-block",
        "float":"left"
      ),
      styling(".positive-bar .bar-tip",
        "height": "1em",
        "display":"inline-block",
        "float":"right"
      ),
      styling(".negative-bar .inner",
        "height": "1em",
        "float":"right"
      ),
      styling(".positive-bar .inner",
        "height": "1em",
        "float":"left"
      ),
      styling(".labels",
        "clear":"both"
      ),
      styling(".not-me-label",
        "float":"left",
        "margin-left": ".9em"
      ),
      styling(".me-label",
        "float":"right",
        "margin-right": ".9em"
      ),
      styling(".score",
        "color":"#fff",
        "display":"inline-block",
        "font-size":"2.4em",
        "margin":"0em .2em",
        "float":"right",
        "line-height":"1em"
      ),
      styling(".name",
        "float":"left",
        "z-index":"1",
        "position":"relative",
        "margin-top":"-1.5em",
        "margin-left":"1em",
        "color":"#fff",
        "font-size":"1.2em",
        "letter-spacing":".1em",
        "text-transform":"uppercase"
      ),
      styling(".personality-traits-container",
        "position":"absolute",
      ),
      styling(".personality-traits .name",
        "font-size":"1.2em",
        "line-height":"1em",
        "text-transform":"none",
        "float":"none",
        "margin":"0em",
        "padding":".2em 0em",
        "display":"inline-block",
        "width":"10.3em",
        "text-align":"left"
      ),
      styling(".personality-traits .score",
        "margin-right":"3em",
        "margin-top":".5em",
        "margin-bottom":"0em",
        "line-height":"1em",
        "display":"inline-block",
        "font-size":"1.2em",
        "float":"none",
        "width":"2.7em",
        "margin":"0em",
        "text-align":"right",
      ),
      styling(".personality-traits .row",
        "margin":"0px",
        "margin-right":"-.1em",
        "position":"relative",
        "font-size":".68em",
        "text-align":"left"
      ),
      styling(".negative-bar .line", 
        "border-top": "solid 1px #d3d3d3",
        "width": "12em",  
        "height": "50%",
        "position": "absolute",
        "margin-top":".5em",
        "z-index":"-1"
      ),
      styling(".positive-bar .line", 
        "border-top": "solid 1px #d3d3d3",
        "width": "12em",  
        "height": "50%",
        "position": "absolute",
        "margin-top":".5em",
        "z-index":"-1"
      ),
      styling(".clear"
        "clear":"both"
      ),
      styling(".personality-traits",
        "width":"11.6em",
        "overflow":"hidden",
        "background-color":"#ccc",
        "position":"absolute",
        "bottom":"0px",
        "display":"inline-block",
        "z-index":2,
        "float":"left",
        "font-weight":"100"
      ),
      styling(".personality.up .personality-traits",
        "bottom":"0px",
      ),
      styling(".personality.down .personality-traits",
        "top":"0px",
      ),
      styling(".personality-traits .inner-container",
        "margin":".5em",
        "position":"relative"
      ),
      styling(".totem-results.phone .negative-bar",
        "display":"none",
      ),
      styling(".totem-results.phone",
        "width":"13em"
      )
      styling(".totem-results.phone .positive-bar",
        "display":"none",
      ),
      styling(".totem-results.phone .panels-container:hover",
        "font-weight":"100",
        "font-size":"1em",
        "position":"relative"
      ),
       styling(".totem-results.phone .panels-container.active",
        "font-weight":"200",
        "font-size":"1.1em",
        "position":"relative"
      ),
    ].join("")























  ###########################################
  # Partials
  ###########################################
  # initialization
  partials = Array()

  partial = (name, data)->
    partials[name](data)

  partials["bar"] = (data)->
    data.color = if data.score < 0 then "not-me" else "me"

    div({style: "clear:both"}, "") + partial("negative-bar", data) + partial("panels-container", data) + partial("positive-bar", data)

  partials["negative-bar"] = (data)->
    barTip = div({class:"bar-tip", style:"border-left: 2.5em solid ##{data.personality_type.badge.color_2};"}, "") 
    innerBar = div({style:"background-color:##{data.personality_type.badge.color_2}; width:#{data.negativeScore}%", class:"inner"}, barTip)
    line = div({class:"line"}, "")
    div({class: "negative-bar"}, innerBar + line)

  partials["positive-bar"] = (data)->
    barTip = div({class:"bar-tip", style:"border-left: 2.5em solid ##{data.personality_type.badge.color_1};"}, "") 
    innerBar = div({style:"background-color:##{data.personality_type.badge.color_1}; width:#{data.positiveScore}%", class:"inner"}, barTip)
    line = div({class:"line"}, "")
    div({class: "positive-bar"}, innerBar + line)

  partials["panels-container"] = (data)->
    name = div({class:"name"}, data.personality_type.name)
    div({class:"panels-container"}, [partial("panel-left", data),
    partial("panel-right", data)].join("") + name)

  partials["panel-left"] = (data)->
    badge = image(data.personality_type.badge.image_small, {class: "badge"})
    div({class:"left-panel", style: "background-color:#"+data.personality_type.badge.color_1}, badge)

  partials["panel-right"] = (data)->
    score = if data.score >= 0  then Math.round(data.positiveScore) else "(#{Math.round(data.negativeScore)})"
    score = div({class: "score #{data.color}"}, score)
    div({class:"right-panel", style: "background-color:#"+data.personality_type.badge.color_2}, score)

  partials["trait-bar"] = (data)->
    color = if data.score < 0 then "not-me" else "me"
    scoreData = if data.score < 0 then "(#{Math.round(data.negativeScore)})" else Math.round(data.positiveScore)
    
    name = div({class:"name"}, data.personality_trait.name)
    score = div({class:'score'}, scoreData)
    div({class:"row"}, "#{name}#{score}")
      

  partials["chart"] = (data)->
    personality_types = data.personality_types

    for key of personality_types
      if personality_types[key].score > 0 
        personality_types[key].positiveScore =  personality_types[key].score 
        personality_types[key].negativeScore = 0
      else
        personality_types[key].negativeScore = Math.abs(personality_types[key].score)
        personality_types[key].positiveScore = 0

    for key of personality_types
      badge = personality_types[key].personality_type.badge
     
      dataDirection = if key < personality_types.length / 2  then "down" else "up"
      personality_types[key] = div({
          "class": "personality #{dataDirection}", 
          "data-id":personality_types[key].personality_type.id, 
          "data-color-1":badge.color_1, 
          "data-color-2":badge.color_2, 
          "data-color-3":badge.color_3
        }, 
        partial("bar", personality_types[key])
      )

    return personality_types.join("")

  render = (data)->
    styles = styles()
    if options && options["styles"] == false
      styles = ""

    totem.html(
      div({class: "totem-results"}, [
        partial("chart", data), styles
        ].join("")
      )
    )

  totem.fetchPersonalityTraitResults = (id)->
    @PersonalityResultsTraits(id)

















  ########################################
  # Actions
  ########################################
  Actions = ->
    if options && options["showTraits"] == true
      personalityTypes =  fetch("personality")

      animatePersonalityTraitsDiv = (personalityTraitsDiv)->
          hidden = if personalityTraitsDiv.style.height == "0px" then true else false
          height = 0
          scrollHeight = personalityTraitsDiv.scrollHeight
          if hidden   
            fontHeight = fetch("totem-results")[0].style.fontSize.replace("px", "")
            classes = personalityTraitsDiv.parentNode.parentNode.getAttribute("class")
            personalityTraitsDiv.parentNode.parentNode.setAttribute("class", classes + " active")
            animateTraitsDiv = setInterval(->
              height += 20
              if height < scrollHeight
                personalityTraitsDiv.style.height = height / fontHeight + "em"
              else
                clearInterval(animateTraitsDiv)
                innerHeight = personalityTraitsDiv.getElementsByClassName("inner-container")[0].scrollHeight / fontHeight
                personalityTraitsDiv.style.height = (innerHeight - .1) + "em"
            , 10)
          else
            classes = personalityTraitsDiv.parentNode.parentNode.getAttribute("class")
            personalityTraitsDiv.parentNode.parentNode.setAttribute("class", classes.replace(" active", ""))
            animateTraitsDiv = setInterval(->
              height -= 70
              if height > 0
                personalityTraitsDiv.style.height = height + "px"
              else
                personalityTraitsDiv.style.height = "0px"
                clearInterval(animateTraitsDiv)
            , 10)

      for personalityType in personalityTypes
        personalityTraitsDiv = Object()

        personalityType.onclick = ()->
          localPersonalityType = this
          color_1 = @getAttribute("data-color-1")
          color_2 = @getAttribute("data-color-2")
          color_3 = @getAttribute("data-color-3")

          animationDirection = @getAttribute("class").indexOf("down") != -1

          totem.PersonalityResultsTraits(@getAttribute("data-id"), (data)->

            personalityTraitsDiv = String()
            for personalityTrait in data
              personalityTrait.color_1 = color_1
              personalityTrait.color_2 = color_2
              personalityTrait.color_3 = color_3
              personalityTraitsDiv += partial("trait-bar", personalityTrait)

            personalityTraitsContainer = div({"class":"personality-traits-container"}, div({"class":"personality-traits"}, div({class:"inner-container"}, personalityTraitsDiv)))

            if animationDirection
              localPersonalityType.getElementsByClassName("panels-container")[0].innerHTML += (personalityTraitsContainer)
            else
              localPersonalityType.getElementsByClassName("panels-container")[0].innerHTML = personalityTraitsContainer + localPersonalityType.getElementsByClassName("panels-container")[0].innerHTML

            personalityTraitsDiv = localPersonalityType.getElementsByClassName("personality-traits")[0]
            personalityTraitsDiv.style.backgroundColor = "##{color_3}"
            personalityTraitsDiv.style.color = "#fff"
            personalityTraitsDiv.style.height = "0px"

            animatePersonalityTraitsDiv(personalityTraitsDiv)
            elements = totem.element.getElementsByClassName("personality-traits")
            for element in elements
              if element != personalityTraitsDiv && element.style.height != "0px"
                animatePersonalityTraitsDiv(element)   
          )

          @onclick = ()->
            elements = totem.element.getElementsByClassName("personality-traits")
            animateDirection = @getAttribute("data-animate-direction")
            for element in elements
              if element != @getElementsByClassName("personality-traits")[0] && element.style.height != "0px"
                animatePersonalityTraitsDiv(element)    
            animatePersonalityTraitsDiv(@getElementsByClassName("personality-traits")[0], animateDirection)
            


          



















  ########################################
  # Model
  ########################################
  totem.PersonalityResultsTraits = (personalityTypeId, callBack)->
    Traitify.getPersonalityTypesTraits(assessmentId, personalityTypeId, (personalityTraits)->
      for personalityTrait in personalityTraits
        if personalityTrait.score < 0 
          personalityTrait.negativeScore = Math.abs(personalityTrait.score)
          personalityTrait.positiveScore = 0
        else
          personalityTrait.positiveScore = personalityTrait.score
          personalityTrait.negativeScore = 0

      callBack(personalityTraits)
    )


  @PersonalityResults = (callBack)->
    Traitify.getPersonalityTypes(assessmentId, (data) ->

      data.getBadges = ->
        if data.personality_blend
          return [data.personality_blend.personality_type_1.badge, data.personality_blend.personality_type_2.badge]
        else
          return [data.personality_types[0].personality_type.badge]

      callBack(data)
    )

  @PersonalityResults((data)->
    phone = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    stretchSize = if phone then 15 else 47.80

    render(data)
    if totem.element.parentNode.offsetWidth < 568
      fetch("totem-results")[0].style.fontSize =  totem.element.parentNode.offsetWidth / stretchSize + "px"
    else
      fetch("totem-results")[0].style.fontSize =  "16px"
    
    if phone
      fetch("totem-results")[0].className += " phone"
    Actions()

    oldOnResize = window.onresize
    window.onresize = (event)->
      if totem.element.parentNode.offsetWidth >= 568 && !phone
        fetch("totem-results")[0].style.fontSize =  "16px"
      else
        fetch("totem-results")[0].style.fontSize =  totem.element.parentNode.offsetWidth / stretchSize + "px"

    supportsOrientationChange = "onorientationchange" of window
    orientationEvent = (if supportsOrientationChange then "orientationchange" else "resize")
    window.addEventListener orientationEvent, (->
      if phone
        oldOnResize.call window, event  if oldOnResize
        newWidth = totem.element.offsetWidth / 15
        fetch("totem-results")[0].style.fontSize = newWidth + "px"
      
    ), false
  )

  return totem