Traitify.ui.loaders ?= Object()
Traitify.ui.loaders.personalityTraits = (assessmentId, target, options)->
  options ?= Object()
  results = Traitify.ui.widgets.personalityTraits(new Widget(target), options)
  results.nodes().main.innerHTML = Traitify.ui.styles
  Traitify.getPersonalityTraits(assessmentId, options.params || Object()).then((data)->
    results.data.traits = data
    results.run()
  )
  results

Traitify.ui.widgets ?= Object()
Traitify.ui.widgets.personalityTraits = (widget, options)->
  widget.states.add("initialized")
  widget.callbacks.add("Initialize")
  
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
    @tags.div("personalityTraits").appendTo("tfPersonalityTraits")
    for trait in @data.traits.slice(0, 8)
      trait = trait.personality_trait
      personalityType = trait.personality_type
      @tags.div(["personalityTraits.trait"], {style: {borderColor: personalityType.badge.color_1}}).appendTo("personalityTraits")
      @tags.div(["personalityTraits.trait.name"], trait.name).appendTo(["personalityTraits.trait", _i])

      @tags.div(["personalityTraits.trait.background"], {style: {
        backgroundImage: "url('#{personalityType.badge.image_medium}')"
      }}).appendTo(["personalityTraits.trait", _i])
      @tags.div(["personalityTraits.trait.definition"], trait.definition).appendTo(["personalityTraits.trait", _i])
      
    personalityTraitsWidgetContainer
  )

  widget