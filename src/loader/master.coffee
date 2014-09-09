Traitify.ui.load = (assessmentId, target, options)->  
  Widgets = Object()
  options ?= Object()
  slideDeck = Bldr(target)
  Widgets.slideDeck = Traitify.ui.slideDeck(slideDeck, options)
  Widgets.slideDeck.data.assessmentId = assessmentId
  Widgets.slideDeck.Widgets = ->
    Widgets
  if Traitify.ui.results
    Widgets.results = Traitify.ui.results(Bldr(target), options.results)
  
  personalityTypesTarget = if options.personalityTypes then options.personalityTypes.target else null
  if Traitify.ui.resultsPersonalityTypes && personalityTypesTarget
    Widgets.resultsPersonalityTypes = Traitify.ui.resultsPersonalityTypes(Bldr(personalityTypesTarget), options.personalityTypes)
  
  personalityTraitsTarget = if options.personalityTraits then options.personalityTraits.target else null
  if Traitify.ui.resultsPersonalityTraits && personalityTraitsTarget
      Widgets.resultsPersonalityTraits = Traitify.ui.resultsPersonalityTraits(Bldr(personalityTraitsTarget), options)
  
  if Traitify.ui.styles
    Widgets.slideDeck.nodes.main.innerHTML = Traitify.ui.styles
  
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
      Widgets.slideDeck.initialize()
    else
      Widgets.loaded = 0
      traits = Object()
      Traitify.getPersonalityTypes(assessmentId, options.results.params || Object()).then((data)->
        Widgets.slideDeck.callbacks.trigger("Finished")
        
        
        if Widgets.results
          Widgets.results.data = data
          Widgets.results.initialize()
        
        if Widgets.resultsPersonalityTypes
          Widgets.resultsPersonalityTypes.data = data
          Widgets.resultsPersonalityTypes.initialize()
        
        Widgets.loaded += 1
        if Widgets.resultsPersonalityTraits
          typesLength = data.personality_types.length
          currentLength = 1
          
          for personalityType in data.personality_types
            
            personalityType = personalityType.personality_type
            personalityTraits = Traitify.getPersonalityTypesTraits(assessmentId, personalityType.id)
            personalityTraits.personalityType = personalityType
            personalityTraits.then((data)->
              
              for trait in data
                traits[trait.personality_trait.name] = this.personalityType
                
                currentLength += 1

                if Object.keys(traits).length == (Widgets.resultsPersonalityTraits.data || {traits: []}).traits.length
                  mapedTraits = Widgets.resultsPersonalityTraits.data.traits.map((i)->
                    i.personalityType = traits[i.personality_trait.name]
                    i
                  )

                  Widgets.resultsPersonalityTraits.data.traits = mapedTraits
                  Widgets.resultsPersonalityTraits.initialize()

            )

      )
      if Widgets.resultsPersonalityTraits
        Traitify.getPersonalityTraits(assessmentId,options.results.params).then((data)->
          if Widgets.resultsPersonalityTraits
            Widgets.loaded += 1
            Widgets.resultsPersonalityTraits.data.traits = data
            if Object.keys(traits).length == data.length
              mapedTraits = Widgets.resultsPersonalityTraits.data.traits.map((i)->   
                i.personalityType = traits[i.personality_trait.name]
                i
              )
              Widgets.resultsPersonalityTraits.data.traits = mapedTraits
              Widgets.resultsPersonalityTraits.initialize()
              
        )
  )
  Widgets
  
Traitify.ui.loadSlideDeck = (assessmentId, target, options)->
  Widget = Bldr(target)
  options ?= Object()
  if Traitify.ui.slideDeck
    results = Traitify.ui.results(Bldr(target), options)
    Traitify.getSlides(assessmentId, (data)->
      results.data = data
      results.initialize()
    )
    Results
  else
    console.log("BAD BUNDLE, RESULTS AREN'T AVAILABLE")

Traitify.ui.loadPersonalityTypes = (assessmentId, target, options)->
  options ?= Object()
  if Traitify.ui.resultsPersonalityTypes
    Results = Traitify.ui.resultsPersonalityTypes(Bldr(target), options)
    Results.nodes.main.innerHTML = Traitify.ui.styles
    Traitify.getPersonalityTypes(assessmentId, options.params || Object()).then((data)->
      Results.data = data
      Results.initialize()
    )
    Results
  else
    console.log("BAD BUNDLE, RESULTS AREN'T AVAILABLE")

Traitify.ui.loadPersonalityTraits = (assessmentId, target, options)->
  options ?= Object()
  if Traitify.ui.resultsPersonalityTypes
    Results = Traitify.ui.resultsPersonalityTraits(Bldr(target), options)
    Results.nodes.main.innerHTML = Traitify.ui.styles
    Traitify.getPersonalityTraits(assessmentId, options.params || Object()).then((data)->
      Results.data.traits = data
      Results.initialize()
    )
    Results
  else
    console.log("BAD BUNDLE, RESULTS AREN'T AVAILABLE")
    
Traitify.ui.loadResults = (assessmentId, target, options)->
  options ?= Object()
  if Traitify.ui.results
    Results = Traitify.ui.results(Bldr(target), options)
    Results.nodes.main.innerHTML = Traitify.ui.styles
    Traitify.getPersonalityTypes(assessmentId, options.params || Object()).then((data)->
      Results.data = data
      Results.initialize()
    )
    Results
  else
    console.log("BAD BUNDLE, RESULTS AREN'T AVAILABLE")