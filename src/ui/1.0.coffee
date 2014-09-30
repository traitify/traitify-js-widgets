class Ui
  constructor: ->
    @widgets = Object()
    @data = Object()
    @registeredData = Object()
    @widgetStatuses = Object()
    @dataDependencies = Object()
    @userAgent = navigator.userAgent

  load: (assessmentId, target, options, optionsTwo)->
    options ?= Object()
    widget = @widgets[assessmentId]
    if widget
      assessmentId = @target
      target = @options
      options = @optionsTwo
      widgets = [widget(assessmentId, target, options)]
    else
      widgets = Array()
      for widgetName in Object.keys(@widgets)
        widgets.push(@widgets[widgetName](assessmentId, target, options[widgetName]))
        @widgets[widgetName].widgets = widgets

    @getData(widgets, assessmentId)
    namedWidgets = Object()
    widgetKeys = Object.keys(@widgets)
    for widget in widgets
      key = widgetKeys[_j]
      namedWidgets[key] = widget
    namedWidgets

  dependencies: (widgets, callback)->
     for widget in widgets
      for dependency in widget.dataDependencies
        callback(widget, dependency)
  runCheck: (widgets)->
    for widget in widgets
      if widget.dataDependencies.length != 0
        widgetShouldRun = true
        for dependency in widget.dataDependencies
          if widget.data.get(dependency)
            widgetShouldRun = widgetShouldRun == true
          else
            widgetShouldRun = widgetShouldRun == false
        if widgetShouldRun
          widget.run()

  getData: (widgets, assessmentId)->
    dataDependencies = @dataDependencies
    runCheck = @runCheck
    @dependencies(widgets, (widget, dependency)->
      dataDependencies[assessmentId] ?= Object()
      dataDependencies[assessmentId][dependency] ?= Array()
      dataDependencies[assessmentId][dependency].push(widget)
    )
    @dependencies(widgets, (widget, dependency)->
      Traitify["get#{dependency}"](assessmentId).then((data)->
        for widget in dataDependencies[assessmentId][dependency]
          widget.data.add(dependency, data)
        runCheck(widgets)
      )
    )
  widget: (widgetName, callback)->
    Traitify.ui.widgets[widgetName] = (assessmentId, target, options)->
      localWidget = new Widget(target)
      localWidget.build = callback
      localWidget.assessmentId = assessmentId
      localWidget.options = options  
      localWidget.build(localWidget)
      localWidget

Traitify.ui = new Ui
