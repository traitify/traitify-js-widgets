Traitify.ui.results = (Widget, options)->
  Widget.states.add("initialized")
  
  Widget.callbacks.add("Initialize")
  
  ########################
  # INITIALIZE
  ########################
  Widget.initialization.events.add("Setup Data", ->
    Widget.nodes.main.appendChild(Widget.partials.render("Results"))
    Widget.callbacks.trigger("Initialize")
  )

  #########################
  # PARTIALS
  #########################
  Widget.partials.add("Results", ->
    results = @addDiv("tf-results", Object())
    results.appendChild(@render("Personality Blend"))
    results
  )

  Widget.partials.add("Personality Blend", ->
    personalityBlendData = Widget.data.personality_blend
    personalityBlend = @addDiv("personalityBlend", Object())
    personalityBlend.appendChild(@render("Personality Blend Badges"))
    personalityBlend.appendChild(@addDiv("name", Object(), personalityBlendData.name))
    personalityBlend.appendChild(@addDiv("blendDescription", Object(), personalityBlendData.description))
    personalityBlend
  )

  Widget.partials.add("Personality Blend Badges", ->
    personalityBlendData = Widget.data.personality_blend
    typeOneData = personalityBlendData.personality_type_1
    hexColorOne = Widget.helpers.hexToRGB(typeOneData.badge.color_1)
    leftBadge = @addDiv("leftBadge")
    leftImage = @addImg("leftBadgeImage", {src: typeOneData.badge.image_medium})
    leftBadge.appendChild(leftImage)
    leftBadge.style.backgroundColor = "rgba(#{hexColorOne.join(', ')}, .07)"
    leftBadge.style.borderColor = "##{personalityBlendData.personality_type_1.badge.color_1}"
    
    typeTwoData = personalityBlendData.personality_type_2
    hexColorTwo = Widget.helpers.hexToRGB(typeTwoData.badge.color_1)
    rightBadge = @addDiv("rightBadge")
    rightImage = @addImg("leftBadgeImage", {src: typeTwoData.badge.image_medium})
    rightBadge.appendChild(rightImage)
    rightBadge.style.backgroundColor = "rgba(#{hexColorTwo.join(', ')}, .07)"
    rightBadge.style.borderColor = "##{typeTwoData.badge.color_1}"
    
    
    badgesContainer = @addDiv("badgesContainer", Object())
    badgesContainer.appendChild(leftBadge)
    badgesContainer.appendChild(rightBadge)
    badgesContainer
  )
  
  Widget