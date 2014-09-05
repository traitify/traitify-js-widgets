Traitify.ui.resultsPersonalityTypes = (Widget, options)->
  Widget.states.add("initialized")
  
  Widget.callbacks.add("Initialize")
  
  ########################
  # INITIALIZE
  ########################
  Widget.initialization.events.add("Setup Data", ->
    tfPersonalityTypes = Widget.partials.render("Personality Types Container")
    Widget.nodes.main.appendChild(tfPersonalityTypes)
  )

  #########################
  # PARTIALS
  #########################
  Widget.partials.add("Personality Types Container", ->
    personalityTypesWidgetContainer = Widget.nodes.addDiv("tfPersonalityTypes", Object())
    personalityTypesContainer = Widget.nodes.addDiv("personalityTypesContainer", Object())
    
    personalityTypes = @render("Personality Types")
    description = Widget.nodes.addDiv("description")
    description.innerHTML = Widget.data.personality_types[0].personality_type.description
    
    Widget.callbacks.trigger("Initialize")
    personalityTypesContainer.appendChild(personalityTypes)

    personalityTypesWidgetContainer.appendChild(personalityTypesContainer)
    
    personalityTypesWidgetContainer.appendChild(description)
    personalityTypesWidgetContainer
  )

  Widget.partials.add("Personality Types", ->
    personalityTypes = Widget.nodes.addDiv("personalityTypes", Object())
    pts = Array()
    
    arrowIcon = Widget.nodes.addDiv("icon")
    arrow = Widget.nodes.addDiv("arrow")
    arrow.appendChild(arrowIcon)
    personalityTypes.appendChild(arrow)
    
    for index of Widget.data.personality_types
      pt = Widget.data.personality_types[index]
      personalityType = Widget.nodes.addDiv("personalityType", {"data-index":index})
      name = Widget.nodes.addDiv("name", Object(), pt.personality_type.name)
      name.style.color = "##{pt.personality_type.badge.color_1}"
      personalityType.appendChild(name)
      
      badge = Widget.nodes.addImg("badge", {src: pt.personality_type.badge.image_medium})
      personalityType.appendChild(badge)
      
      score = Widget.nodes.addDiv("score", Object(), "#{Math.round(pt.score)} / 100")
      personalityType.appendChild(score)
      
      personalityTypes.appendChild(personalityType)
    
    personalityTypes
  )
  
  Widget.events.add(->
    personalityTypes = document.querySelectorAll(".tf-personality-types .personality-type")
    for personalityType in personalityTypes
      personalityType.onclick = ()->
        description = document.querySelector(".tf-personality-types .description")
        index = this.getAttribute("data-index")
        arrow = document.querySelector(".tf-personality-types .arrow")

        arrow.style.left = (index * 130) + "px"
        descriptionData = Widget.data.personality_types[index].personality_type.description
        description.innerHTML = descriptionData
  )
  
  Widget