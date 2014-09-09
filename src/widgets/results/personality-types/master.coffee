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
    personalityTypesWidgetContainer = @addDiv("tfPersonalityTypes", Object())
    personalityTypesContainer = @addDiv("personalityTypesContainer", Object())
    
    personalityTypes = @render("Personality Types")
    description = @addDiv("description")
    description.innerHTML = Widget.data.personality_types[0].personality_type.description
    
    Widget.callbacks.trigger("Initialize")
    personalityTypesContainer.appendChild(personalityTypes)

    personalityTypesWidgetContainer.appendChild(personalityTypesContainer)
    
    personalityTypesWidgetContainer.appendChild(description)
    personalityTypesWidgetContainer
  )

  Widget.partials.add("Personality Types", ->
    personalityTypes = @addDiv("personalityTypes", Object())
    pts = Array()
    @addDiv("arrow").appendTo("personalityTypes")
    @addDiv("icon").appendTo("arrow")
    
    
    for index of Widget.data.personality_types
      pt = Widget.data.personality_types[index]
      @addDiv("personalityType", {"data-index":index}).appendTo("personalityTypes")
      name = @addDiv("name", Object(), pt.personality_type.name).appendTo("personalityType")
      name.style.color = "##{pt.personality_type.badge.color_1}"
      
      @addImg("badge", {src: pt.personality_type.badge.image_medium}).appendTo("personalityType")
      
      score = @addDiv("score", Object(), "#{Math.round(pt.score)} / 100").appendTo("personalityType")
      
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