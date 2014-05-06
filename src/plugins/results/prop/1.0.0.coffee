window.Traitify.ui.resultsProp = (assessmentId, selector, options)->
  partials = Array()
  prop = Object()
  
  # Select Canvas Object
  selector = (if selector then selector else @selector)

  unless selector.indexOf("#") is -1
    prop.element = document.getElementById(selector.replace("#", ""))
  else
    prop.element = document.getElementsByClassName(selector.replace(".", ""))[0]

  #retina settings
  prop.retina = window.devicePixelRatio > 1

  prop.data = (attr) ->
    prop.element.getAttribute "data-" + attr

  prop.html = (setter) ->
    prop.element.innerHTML = setter  if setter
    prop.element.innerHTML

  prop.classes = ->
    classes = prop.element.className.split(" ")
    for key of classes
      if classes[key]
        classes[key] = "." + classes[key]
      else
        delete classes[key]

    classes.join ""

   # Create the XHR object.
  prop.createCORSRequest = (method, url)->
    xhr = new XMLHttpRequest()
    if "withCredentials" of xhr

      # XHR for Chrome/Firefox/Opera/Safari.
      xhr.open method, url, true
    else unless typeof XDomainRequest is "undefined"

      # XDomainRequest for IE.
      xhr = new XDomainRequest()
      xhr.open method, url
    else

      # CORS not supported.
      alert "Whoops, there was an error making the request."
      xhr = null
    xhr
  prop.ajax = (url, method, callback, params)->
    xhr = @createCORSRequest(method, url)
    xhr.open method, url, true

    xhr.setRequestHeader "Authorization", "Basic " + btoa(Traitify.publicKey + ":x")

    xhr.setRequestHeader "Content-type", "application/json"
    xhr.setRequestHeader "Accept", "application/json"
    xhr.onload = ->
      data = JSON.parse(xhr.response)
      callback data
      return

    xhr.send params
    xhr
  prop.put = (url, params, callback) ->
    prop.ajax url, "PUT", callback, params

  prop.get = (url, callback) ->
    prop.ajax url, "GET", callback, ""


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
    prop.classes() + " " + selector + "{\n" + formattedContent.join("\n") + "}"
  media = (arg, content) ->
    for i of arg
      arg = i + ":" + arg[i]
    "@media screen and (" + arg + ")"
  fetch = (className) ->
    prop.element.getElementsByClassName className

  forEach = (iterator, callBack)->
    for key of itorator
      callBack(itorator[key])


  ###
  Styles
  ###
  styles = () ->
    style [
      styling(".badge",
        "width": "4em",
        "height":"4em",
        "display": "inline-block",
        "vertical-align": "middle",
        "background-color":"transparent",
        "margin": "-.1em -.5em 0em 0em",
        "padding": "0px",
        "border-radius": "50%",
        "border": ".2em solid #fff",
        "background-size":"4em 4em",
        "display": "inline-block",
        "position":"relative",
        "z-index":"1"
        "vertical-align": "middle",
        "margin": "-1.4em -.8em 0em -.8em",
        "background-position":"center",
        "font-size":"1em"
      ),
      styling(".positive-bar",
        "height": "1em",
        "width": "12em",
        "display": "inline-block",
        "background-color":"#e0e0e0",
        "border-radius":"0em .3em .3em 0em",
        "box-shadow":".1em .1em .2em .01em #ccc inset",
        "overflow": "hidden"
      ),
      styling(".negative-bar",
        "height": "1em",
        "width": "12em",
        "display": "inline-block",
        "background-color":"#e0e0e0",
        "border-radius":".3em 0em 0em .3em",
        "box-shadow":".1em .1em .2em .01em #ccc inset",
        "overflow": "hidden"
      ),
      styling(".personality",
        "padding":".3em 0em",
        "display": "inline-block",
      ),
      styling(".prop-results",
        "width": "29.5em",
        "padding":"1em",
        "margin": "0px auto",
        "display": "inline-block",
        "background-color":"#fff",
        "border-radius":".5em",
        "font-family":'"Helvetica Neue", Helvetica,Arial, sans-serif'
      ),
      styling("",
        "text-align":"center"
      )
      styling(".negative-bar .inner",
        "height": "1em",
        "background-color": "#e54435" 
      ),
      styling(".positive-bar .inner",
        "height": "1em",
        "background-color": "#0f9bd8" 
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
        "float":"right",
        "margin-top":"-.1em",
        "margin-bottom":"-.5em"
      ),
      styling(".score.me",
        "color": "#0f9bd8"
      ),
      styling(".score.not-me",
        "color": "#e54435"
      ),
      styling(".name",
        "float":"left",
        "margin-top":"-.1em",
        "margin-bottom":"-.5em"
      ),
      styling(".personality-traits .name",
        "margin-left":"3em",
        "margin-top":".5em",
        "margin-bottom":"0em",
        "line-height":"1em"
      ),
      styling(".personality-traits .score",
        "margin-right":"3em",
        "margin-top":".5em",
        "margin-bottom":"0em",
        "line-height":"1em"
      ),
      styling(".personality-traits .name-and-score",
        "display":"block",
      ),
      styling(".personality-traits .bars",
        "display":"inline-block",
        "position":"relative",
        "top":"-.4em",
        "line-height":".3em"
      ),
      styling(".personality-traits .negative-bar", 
        "width":"10em",
        "height":".3em",
        "line-height":".3em",
      ), 
      styling(".clear"
        "clear":"both"
      )
      styling(".personality-traits .positive-bar"
        "width":"10em",
        "height":".3em",
        "line-height":".3em",
      ),
      styling(".personality-traits .positive-bar .inner",
        "height":".3em"
      ),
      styling(".personality-traits .negative-bar .inner",
        "height":".3em"
      )
      styling(".personality-traits",
        "overflow":"hidden"
      )
    ].join("")



  ###########################################
  # Partials
  ###########################################
  # initialization
  partials = Array()

  partial = (name, data)->
    partials[name](data)

  partials["bar"] = (data)->
    color = if data.score < 0 then "not-me" else "me"
    score = if data.score < 0 then "(#{Math.round(data.negativeScore)})" else Math.round(data.positiveScore)
    [
      div({class:"name"}, data.personality_type.name),
      div({class:"score #{color}"}, score),
      div({style:"clear:both"}, ""),
      div({class: "negative-bar"}, div({style:"float:right; width:"+data.negativeScore+"%", class:"inner"}, "")),
      div({style:"background-image:url('"+data.personality_type.badge.image_medium+"');", class: "badge"}, ""),
      div({class: "positive-bar"}, div({style:"float:left; width:"+data.positiveScore+"%", class:"inner"}, "")),
    ].join("")

  partials["trait-bar"] = (data)->
      color = if data.score < 0 then "not-me" else "me"
      scoreData = if data.score < 0 then "(#{Math.round(data.negativeScore)})" else Math.round(data.positiveScore)
      negativeScore = div({class: "negative-bar"}, div({style:"float:right; width:"+data.negativeScore+"%", class:"inner"}, ""))
      positiveScore = div({class: "positive-bar"}, div({style:"float:left; width:"+data.positiveScore+"%", class:"inner"}, ""))
      name = div({class:"name"}, data.personality_trait.name)
      score = div({class:"score #{color}"}, scoreData)
      [
        div({class:"name-and-score"}, name + score + div({class:"clear"}, "")),
        div({class:"bars"}, negativeScore + positiveScore + div({class:"clear"}, ""))
      ].join("")

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

      personality_types[key] = div({class: "personality", "data-id":personality_types[key].personality_type.id}, [
        partial("bar", personality_types[key])].join("")
      )

    return personality_types.join("")

  render = (data)->
    prop.html(
      div({class: "prop-results"}, [
        partial("chart", data), styles()
        ].join("")
      )
    )

  prop.fetchPersonalityTraitResults = (id)->
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
            animateTraitsDiv = setInterval(->
              if height < scrollHeight
                height += 100
                personalityTraitsDiv.style.height = height + "px"
              else
                clearInterval(animateTraitsDiv)
                personalityTraitsDiv.style.height = ""
            , 10)
          else
            height = scrollHeight

            animateTraitsDiv = setInterval(->
              if height > 0
                height -= 100
                personalityTraitsDiv.style.height = height + "px"
              else
                personalityTraitsDiv.style.height = "0px"
                clearInterval(animateTraitsDiv)
            , 10)

      for personalityType in personalityTypes
        personalityTraitsDiv = Object()
        personalityType.onclick = ()->
          localPersonalityType = this
          prop.PersonalityResultsTraits(@getAttribute("data-id"), (data)->
            personalityTraitsDiv = String()
            for personalityTrait in data
              personalityTraitsDiv += partial("trait-bar", personalityTrait)
            localPersonalityType.innerHTML += div({"class":"personality-traits"}, personalityTraitsDiv)
            personalityTraitsDiv = localPersonalityType.getElementsByClassName("personality-traits")[0]
            personalityTraitsDiv.style.height = "0px"
            animatePersonalityTraitsDiv(personalityTraitsDiv)
            elements = prop.element.getElementsByClassName("personality-traits")
            for element in elements
              if element != personalityTraitsDiv && element.style.height != "0px"
                animatePersonalityTraitsDiv(element)   
          )

          @onclick = ()->
            elements = prop.element.getElementsByClassName("personality-traits")
            for element in elements
              if element != @getElementsByClassName("personality-traits")[0] && element.style.height != "0px"
                animatePersonalityTraitsDiv(element)    
            animatePersonalityTraitsDiv(@getElementsByClassName("personality-traits")[0])
            


          

  ########################################
  # Model
  ########################################
  prop.PersonalityResultsTraits = (personalityTraitId, callBack)->
    Traitify.getPersonalityTypesTraits(assessmentId, personalityTraitId, (personalityTraits)->

      for personalityTrait in personalityTraits
        if personalityTrait.score < 0 
          personalityTrait.negativeScore = Math.abs(personalityTrait.score)
          personalityTrait.positiveScore = 0
        else
          personalityTrait.positiveScore = Math.abs(personalityTrait.score)
          personalityTrait.negativeScore = 0

      callBack(personalityTraits)
  )

  @PersonalityResults = (callBack)->
    Traitify.getPersonalityTypes(assessmentId, (data) ->

      data.getMaxAndMinScore = ->
        personalityTypes = data.personality_types
        scores = Array()
        for key of personalityTypes
          scores.push(personalityTypes[key].score)

        scoreMath = Array()
        scoreMath["max"] = Math.max.apply( Math, scores )
        scoreMath["min"] = Math.abs(Math.min.apply( Math, scores ))

        if(scoreMath["max"] > scoreMath["min"])
          return 100 / scoreMath["max"]
        else
          return 100 / scoreMath["min"]

      data.getBadges = ->
        if data.personality_blend
          return [data.personality_blend.personality_type_1.badge, data.personality_blend.personality_type_2.badge]
        else
          return [data.personality_types[0].personality_type.badge]

      callBack(data)
  )

  @PersonalityResults((data)->
    render(data)
    phone = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    stretchSize = if phone then 29.5 else 31.2
    if prop.element.parentNode.offsetWidth < 568
      fetch("prop-results")[0].style.fontSize =  prop.element.parentNode.offsetWidth / stretchSize + "px"
    else
      fetch("prop-results")[0].style.fontSize =  "19px"

    Actions()

    oldOnResize = window.onresize
    window.onresize = (event)->
      if prop.element.parentNode.offsetWidth < 568
        fetch("prop-results")[0].style.fontSize =  prop.element.parentNode.offsetWidth / stretchSize + "px"
      else
        fetch("prop-results")[0].style.fontSize =  "19px"

    supportsOrientationChange = "onorientationchange" of window
    orientationEvent = (if supportsOrientationChange then "orientationchange" else "resize")
    window.addEventListener orientationEvent, (->
      if prop.element.parentNode.offsetWidth < 568
        oldOnResize.call window, event  if oldOnResize
        newWidth = prop.element.offsetWidth / 29.5
        fetch("prop-results")[0].style.fontSize = newWidth + "px"
      else
        fetch("prop-results")[0].style.fontSize =  "19px"      
    ), false
  )

  return prop
