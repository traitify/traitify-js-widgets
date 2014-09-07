Traitify.ui.load = (assessmentId, target, options)->  
  Widgets = Object()
  options ?= Object()
  slideDeck = Bldr(target)
  Widgets.slideDeck = Traitify.ui.slideDeck(slideDeck, options)
  Widgets.slideDeck.data.assessmentId = assessmentId
  
  if Traitify.ui.results
    Widgets.results = Traitify.ui.results(Bldr(target), options.results)
  
  personalityTypesTarget = if options.personalityTypes then options.personalityTypes.target else Object()
  if Traitify.ui.resultsPersonalityTypes
    Widgets.resultsPersonalityTypes = Traitify.ui.resultsPersonalityTypes(Bldr(personalityTypesTarget), options.personalityTypes)
  
  options.personalityTypes ?= Object()
  
  Widgets.slideDeck.nodes.main.innerHTML = Traitify.ui.styles
  
  options ?= Object()
  options.results ?= Object()
  options.slideDeck ?= Object()
  options.personalityTypes ?= Object()
  if options.results.logging
    Widgets.results.states.logging(true)
  if options.slideDeck.logging
    Widgets.slideDeck.states.logging(true)
  
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
      Traitify.getPersonalityTypes(assessmentId, options.results.params || {image_pack: "linear"}).then((data)->
        Widgets.slideDeck.callbacks.trigger("Finished")
        
        if Widgets.results
          Widgets.results.data = data
          Widgets.results.initialize()
        
        if Widgets.resultsPersonalityTypes
          Widgets.resultsPersonalityTypes.data = data
          Widgets.resultsPersonalityTypes.initialize()
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
  else
    console.log("BAD BUNDLE, RESULTS AREN'T AVAILABLE")

Traitify.ui.loadPersonalityTypes = (assessmentId, target, options)->
  options ?= Object()
  if Traitify.ui.resultsPersonalityTypes
    Results = Traitify.ui.resultsPersonalityTypes(Bldr(target), options)
    Results.nodes.main.innerHTML = Traitify.ui.styles
    Traitify.getPersonalityTypes(assessmentId, options.params || {image_pack: "linear"}).then((data)->
      Results.data = data
      Results.initialize()
    )
  else
    console.log("BAD BUNDLE, RESULTS AREN'T AVAILABLE")
    
Traitify.ui.loadResults = (assessmentId, target, options)->
  options ?= Object()
  if Traitify.ui.results
    Results = Traitify.ui.results(Bldr(target), options)
    Results.nodes.main.innerHTML = Traitify.ui.styles
    Traitify.getPersonalityTypes(assessmentId, options.params || {image_pack: "linear"}).then((data)->
      Results.data = data
      Results.initialize()
    )
  else
    console.log("BAD BUNDLE, RESULTS AREN'T AVAILABLE")