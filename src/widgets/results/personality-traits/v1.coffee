Traitify.ui.widget("personalityTraits", (widget, options)->
  widget.states.add("initialized")
  widget.callbacks.add("Initialize")
  widget.dataDependency("PersonalityTraits")
  widget.styleDependency("all")
  widget.styleDependency("results/personality-traits")
  
  ########################
  # INITIALIZE
  ########################
  widget.initialization.events.add("Setup Data", ->
    widget.views.render("Personality Traits Container").appendTo("main")
    widget.callbacks.trigger("Initialize")
  )

  #########################
  # PARTIALS
  #########################
  widget.views.add("Personality Traits Container", ->
    personalityTraitsWidgetContainer = @tags.div("tfPersonalityTraits")
    if Traitify.oldIE
        personalityTraitsWidgetContainer.className += " ie"
    @tags.div("personalityTraits").appendTo("tfPersonalityTraits")
    _i = 0
    for trait in @data.get("PersonalityTraits").slice(0, 8)
      trait = trait.personality_trait
      personalityType = trait.personality_type

      @tags.div(["personalityTraits.trait"], {style: {borderColor: "##{personalityType.badge.color_1}"}}).appendTo("personalityTraits")
      @tags.div(["personalityTraits.trait.name"], trait.name).appendTo(["personalityTraits.trait", _i])

      if Traitify.oldIE
          @tags.img(["personalityTraits.trait.background"], personalityType.badge.image_medium).appendTo(["personalityTraits.trait", _i])
      else
          @tags.div(["personalityTraits.trait.background"], {style: {
            backgroundImage: "url('#{personalityType.badge.image_medium}')"
          }}).appendTo(["personalityTraits.trait", _i])
      @tags.div(["personalityTraits.trait.definition"], trait.definition).appendTo(["personalityTraits.trait", _i])
      _i++
    personalityTraitsWidgetContainer
  )
)
