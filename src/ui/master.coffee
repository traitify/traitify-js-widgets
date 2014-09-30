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
  load: (assessmentId, target, options, shiftedOptions)->
    nonSlideWidgets = Object()
    slideWidgets = Object()
    if widget = @widgets[assessmentId]
      assessmentId = target
      target = options
      options = shiftedOptions

      widget = widget(assessmentId, target, options)
      Traitify.ui.loadResults([widget])
      return slideWidgets
    else
      for widgetName in Object.keys(@widgets)
        if options[widgetName] && options[widgetName]["target"]
          currentTarget = options[widgetName]["target"]
        else
          currentTarget = target
        @runningWidgets[widgetName] = @widgets[widgetName](assessmentId, currentTarget, options)
        dataDependencies = @runningWidgets[widgetName].dataDependencies
        if dataDependencies.indexOf("Slides") != -1
          slideWidgets[widgetName] = @runningWidgets[widgetName]
        else
          nonSlideWidgets[widgetName] = @runningWidgets[widgetName]
      if Object.keys(slideWidgets).length != 0
        Traitify.getSlides(assessmentId).then((slides)->
          if slides.filter( (slide)-> typeof slide.completed_at == "number" ).length != 0
            Traitify.ui.loadResults(nonSlideWidgets)
          else
            for slideWidgetName in Object.keys(slideWidgets)
              slideWidget = slideWidgets[slideWidgetName]
              slideWidget.data.add("Slides", slides)
              slideWidget.run()
        )

        allWidgets = Object()
        console.log("RUN")
        for widgetName in Object.keys(nonSlideWidgets)
          allWidgets[widgetName] = nonSlideWidgets[widgetName]
        for widgetName in Object.keys(slideWidgets)
          allWidgets[widgetName] = slideWidgets[widgetName]
        allWidgets
      
  loadResults: (widgets)->
    dependencies = Object()
    for widgetName in Object.keys(widgets)
      widget = widgets[widgetName]
      for dependency in widget.dataDependencies
        if dependencies[dependency] != true
          dependencies[dependency] = true
          console.log(dependency)
          results = Traitify["get#{dependency}"](widget.assessmentId)
          results.cleanName = dependency

          results.then((data)->
            dependency = @cleanName
            dependentWidgetNames = Object.keys(widgets).filter((widgetName)-> 
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
    Traitify.ui.widgets[widgetName] = (assessmentId, target, options)->
      localWidget = new Widget(target)
      localWidget.build = callback
      localWidget.assessmentId = assessmentId
      localWidget.options = options  
      localWidget.build(localWidget)
      localWidget

Traitify.ui = new Ui
