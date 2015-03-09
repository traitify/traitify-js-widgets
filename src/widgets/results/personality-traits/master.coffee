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

    traits = @data.get("PersonalityTraits").slice(0, 8)
    index = 0
    while index < traits.length

      trait = traits[index].personality_trait

      personalityType = trait.personality_type

      @tags.div(["personalityTraits.trait"], {style: {borderColor: "##{personalityType.badge.color_1}"}}).appendTo("personalityTraits")
      @tags.div(["personalityTraits.trait.name"], trait.name).appendTo(["personalityTraits.trait", index])

      if Traitify.oldIE
          @tags.img(["personalityTraits.trait.background"], personalityType.badge.image_medium).appendTo(["personalityTraits.trait", index])
      else
          @tags.div(["personalityTraits.trait.background"], {style: {
            backgroundImage: "url('#{personalityType.badge.image_medium}')"
          }}).appendTo(["personalityTraits.trait", index])
      @tags.div(["personalityTraits.trait.definition"], trait.definition).appendTo(["personalityTraits.trait", index])
      index++
    personalityTraitsWidgetContainer
  )
)
