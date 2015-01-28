Traitify.ui.widget("careers", (widget, options)->
  widget.states.add("initialized")
  widget.callbacks.add("Initialize")
  widget.styleDependency("all")
  widget.styleDependency("results/careers")

  ########################
  # INITIALIZE
  ########################
  widget.initialization.events.add("Setup Data", ->
    widget.views.render("Careers Container").appendTo("main")
    widget.callbacks.trigger("Initialize")
  )

  #########################
  # PARTIALS
  #########################
  widget.views.add("Careers Container", ->
    careersWidgetContainer = @tags.div("tfCareers")
    if Traitify.oldIE
      careersWidgetContainer.className += " ie"

    @tags.div("careers").appendTo("tfCareers")
    columns = 4
    for column in [0..columns-1]
      column = @tags.div("column-" + column)
      column.className += " column"
      column.appendTo("careers")

    tags = @tags
    if widget.options && widget.options.careers
      options = { number_of_matches: widget.options.careers.number_of_matches }
    Traitify.getCareers(widget.assessmentId, options, (careers) ->
      for career, i in careers
        career = career.career
        column = i % columns
        index = Math.floor(i / columns)
        classBase = "column-" + column + ".career"

        tags.div([classBase]).appendTo("column-" + column)
        tags.img([classBase + ".image"], career.picture).appendTo([classBase, index])
        tags.div([classBase + ".title"], career.title).appendTo([classBase, index])
        description = tags.div([classBase + ".description"], career.description.substring(0, 220))
        if career.description.length > 300
          description.className += " fade"
        description.appendTo([classBase, index])
        tags.hr([classBase + ".hr"]).appendTo([classBase, index])
        tags.div([classBase + ".experience"], "Experience Level " + career.experience_level.id).appendTo([classBase, index])
        experienceBoxes = tags.div([classBase + ".experience-boxes"])
        for level in [1..career.experience_level.id]
          experienceBox = tags.div("experience-box")
          experienceBox.className += " highlighted-box"
          experienceBoxes.appendChild(experienceBox)
        for level in [1..(5-career.experience_level.id)]
          experienceBoxes.appendChild(tags.div("experience-box"))
        experienceBoxes.appendTo([classBase, index])
        tags.div([classBase + ".education"], career.experience_level.education).appendTo([classBase, index])
    )

    careersWidgetContainer
  )
)