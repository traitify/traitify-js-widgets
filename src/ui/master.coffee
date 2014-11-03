# Base class for Traitify User Interfaces (All widgets).
#
# @example How to create A widget
#   ui = new Ui
#     ui.widget("name", ->
#       console.log(@) 
#     )
#
class Ui
  constructor: ->
    @widgets = Object()
    @userAgent = navigator.userAgent
    @runningWidgets = Object()

  # Load Appropriate Widgets for the Current State / Load a Specified Widget.
  #
  # @example load(assessmentId, target, options)
  #   options = {personalityTypes: {target:".personalityType"}}
  #   widgets = Traitify.ui.load("assessmentId", ".target-element", options)
  #
  #   personalityTraits = Traitify.ui.load("PersonalityTraits", "assessmentId", ".target-element")
  #
  # @param [String] Widget Name
  # @param [Function] Callback for Widget Specifications
  #
  load: (assessmentId, target, options = Object(), shiftedOptions)->
    nonSlideWidgets = Object()
    slideWidgets = Object()
    if widget = @widgets[assessmentId]
      assessmentId = target
      target = options
      options = shiftedOptions

      widget = widget(assessmentId, target, options)
      Traitify.ui.loadResults({slideDeck: widget})
      return widget
    else
      allWidgets = Object()
      for widgetName in Object.keys(@widgets)
        if options[widgetName] && options[widgetName]["target"]
          currentTarget = options[widgetName]["target"]
        else
          currentTarget = target
        @runningWidgets[widgetName] = @widgets[widgetName](assessmentId, currentTarget, options)
        dataDependencies = @runningWidgets[widgetName].dataDependencies
        if dataDependencies.indexOf("Slides") != -1
          slideWidgets[widgetName] = @runningWidgets[widgetName]
          slideWidgets[widgetName].widgets = allWidgets
        else
          nonSlideWidgets[widgetName] = @runningWidgets[widgetName]
          nonSlideWidgets[widgetName].widgets = allWidgets
      if Object.keys(slideWidgets).length != 0
        Traitify.getSlides(assessmentId).then((slides)->
          playedSlides = slides.filter( (slide)-> 
            slide.completed_at != null 
          )

          showResults = Object.keys(options).filter((widgetName)-> options[widgetName].showResults == false ).length != 0

          if playedSlides.length != slides.length || showResults
            for slideWidgetName in Object.keys(slideWidgets)
              slideWidget = slideWidgets[slideWidgetName]
              slideWidget.data.add("Slides", slides)
              if playedSlides.length == slides.length && showResults
                slideWidget.callbacks.trigger("Finished")
              else
                slideWidget.run()
          else
            Traitify.ui.loadResults(nonSlideWidgets)
        )

        for widgetName in Object.keys(nonSlideWidgets)
          allWidgets[widgetName] = nonSlideWidgets[widgetName]
        for widgetName in Object.keys(slideWidgets)
          allWidgets[widgetName] = slideWidgets[widgetName]
        allWidgets
      
  loadResults: (widgets)->
    dependencies = Object()
    for widgetName in Object.keys(widgets)
      widget = widgets[widgetName]
      widget.widgets = widgets
      for dependency in widget.dataDependencies
        if dependencies[dependency] != true
          dependencies[dependency] = true
          results = Traitify["get#{dependency}"](widget.assessmentId)
          results.cleanName = dependency

          results.then((data)->
            dependency = @cleanName
            dependentWidgetNames = Object.keys(widgets).filter((widgetName)-> 
              widgets[widgetName]
              widgets[widgetName].dataDependencies.indexOf(dependency) != -1
            )
            for widgetName in dependentWidgetNames
              widget = widgets[widgetName] 
              widget.data.add(dependency, data)
              dependencyCheck = true
              for dependency in widget.dataDependencies
                if !widget.data.get(dependency)
                  dependencyCheck == false

              if dependencyCheck
                widget.run()
          )


  # Build a New Widget.
  #
  # @example widget(widgetName, callback)
  #   Traitify.ui.widget("yourWidgetName", (widget)->
  #   widget.dataDependency("PersonalityTraits")
  # )
  # @param [String] Widget Name
  # @param [String] callback Widget Specifications
  #
  widget: (widgetName, callback)->
    styles = @styles
    Traitify.ui.widgets[widgetName] = (assessmentId, target, options)->
      localWidget = new Widget(target)
      localWidget.data.cookies.scope = assessmentId
      localWidget.build = callback
      localWidget.assessmentId = assessmentId
      localWidget.options = options
      localWidget.build(localWidget)
      localWidget

Traitify.ui = new Ui
Traitify.ui.styles = Object()
