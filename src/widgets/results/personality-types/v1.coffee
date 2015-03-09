Traitify.ui.widget("personalityTypes", (widget, options)->
  widget.states.add("initialized")
  widget.dataDependency("PersonalityTypes")
  widget.styleDependency("all")
  widget.styleDependency("results/personality-types")

  widget.callbacks.add("Initialize")
  
  ########################
  # INITIALIZE
  ########################
  widget.initialization.events.add("Setup Data", ->
    widget.views.render("Personality Types Container").appendTo("main")
  )

  #########################
  # PARTIALS
  #########################
  widget.views.add("Personality Types Container", ->
    personalityTypesWidgetContainer = @tags.div("tfPersonalityTypes")
    if Traitify.oldIE
        personalityTypesWidgetContainer.className += " ie"

    @tags.div("personalityTypesContainerScroller").appendTo("tfPersonalityTypes")
    @tags.div("personalityTypesContainer").appendTo("personalityTypesContainerScroller")

    @render("Personality Types").appendTo("personalityTypesContainer")
    description = @tags.div("description").appendTo("tfPersonalityTypes")
    description.innerHTML = widget.data.get("PersonalityTypes").personality_types[0].personality_type.description

    widget.callbacks.trigger("Initialize")

    personalityTypesWidgetContainer
  )

  widget.views.add("Personality Types", ->
    personalityTypes = @tags.div("personalityTypes", Object())
    pts = Array()
    @tags.div("arrow").appendTo("personalityTypes")
    @tags.div("icon").appendTo("arrow")

    _i = 0
    for pt in widget.data.get("PersonalityTypes").personality_types
      index = _i
      @tags.div("personalityType", {"data-index": index}).appendTo("personalityTypes")
      name = @tags.div("name", Object(), pt.personality_type.name).appendTo("personalityType")
      name.style.color = "##{pt.personality_type.badge.color_1}"

      @tags.img("badge", pt.personality_type.badge.image_medium).appendTo("personalityType")

      score = @tags.div("score", Object(), "#{Math.round(pt.score)} / 100").appendTo("personalityType")
      _i++
    personalityTypes
  )

  widget.initialization.events.add("personalityTypes", ->
    personalityTypes = document.querySelectorAll(".tf-personality-types .personality-type")
    for personalityType in personalityTypes
      personalityType.onclick = ()->
        description = document.querySelector(".tf-personality-types .description")
        index = this.getAttribute("data-index")
        arrow = document.querySelector(".tf-personality-types .arrow")

        arrow.style.left = (index * 130) + "px"
        descriptionData = widget.data.get("PersonalityTypes").personality_types[index].personality_type.description
        description.innerHTML = descriptionData
  )
  
)
