Traitify.ui.load = (assessmentId, target, options, specificOptions)->
  Widgets = Object()
  options ?= Object()
  if Traitify.ui.loaders[assessmentId]
    return Traitify.ui.loaders[assessmentId](target, options, specificOptions)
  options.slideDeck ?= Object()
  options.results ?= Object()
  options.personalityTypes ?= Object()
  options.personalityTraits ?= Object()

  slideDeck = new Widget(target)
  Widgets.slideDeck = Traitify.ui.widgets.slideDeck(slideDeck, options)
  Widgets.slideDeck.data.assessmentId = assessmentId
  Widgets.slideDeck.Widgets = ->
    Widgets

  if Traitify.ui.widgets.results
    Widgets.results = Traitify.ui.widgets.results(new Widget(target), options.results)

  personalityTypesTarget = if options.personalityTypes then options.personalityTypes.target else null
  if Traitify.ui.widgets.personalityTypes && personalityTypesTarget
    Widgets.personalityTypes = Traitify.ui.widgets.personalityTypes(new Widget(personalityTypesTarget), options.personalityTypes)

  personalityTraitsTarget = if options.personalityTraits then options.personalityTraits.target else null
  if Traitify.ui.widgets.personalityTraits && personalityTraitsTarget
      Widgets.personalityTraits = Traitify.ui.widgets.personalityTraits(new Widget(personalityTraitsTarget), options)

  if Traitify.ui.styles
    Widgets.slideDeck.nodes().main.innerHTML = Traitify.ui.styles

  Traitify.getSlides(assessmentId).then((data)->
    slides = Object()

    slides.notCompleted = data.filter((slide)->
      !slide.completed_at
    )

    if slides.notCompleted.length != 0
      Widgets.slideDeck.data.assessmentId = assessmentId
      Widgets.slideDeck.data.slides = Object()
      Widgets.slideDeck.data.slides.notCompleted = slides.notCompleted
      Widgets.slideDeck.data.slides.completed = data.filter((slide)->
        slide.completed_at
      )

      Widgets.slideDeck.run()
    else
      Widgets.loaded = 0
      traits = Object()
      Traitify.getPersonalityTypes(assessmentId, options.params || Object()).then((data)->
        Widgets.slideDeck.callbacks.trigger("Finished")

        if Widgets.results
          Widgets.results.data = data
          Widgets.results.run()

        if Widgets.personalityTypes
          Widgets.personalityTypes.data = data
          Widgets.personalityTypes.run()

        Widgets.loaded += 1
        if Widgets.personalityTraits && Widgets.loaded == 2
          typesLength = data.personality_types.length
          Widgets.personalityTraits.run()
      )
      if Widgets.personalityTraits
        Traitify.getPersonalityTraits(assessmentId,options.params).then((data)->
          Widgets.loaded += 1 
          Widgets.personalityTraits.data.traits = data
          if Widgets.personalityTraits && Widgets.loaded == 2
              Widgets.personalityTraits.run()

        )
  )
  Widgets
