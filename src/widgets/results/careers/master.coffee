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

    columns = 4
    for column in [0..columns-1]
      column = @tags.div("column-" + column)
      column.className += " column"
      column.appendTo("tfCareers")

    tags = @tags
    if widget.options && widget.options.careers
      options = { number_of_matches: widget.options.careers.number_of_matches }
      if widget.options.careers.details
        showDetails = widget.options.careers.details.show
        detailsTarget = widget.options.careers.details.target
    Traitify.getCareers(widget.assessmentId, options, (careers) ->
      for career, i in careers
        score = career.score
        career = career.career
        column = i % columns
        index = Math.floor(i / columns)
        classBase = "column-" + column + ".career"

        careerContainer = tags.div([classBase])
        careerContainer.appendTo("column-" + column)
        tags.img([classBase + ".image"], career.picture).appendTo([classBase, index])
        tags.div([classBase + ".title"], career.title).appendTo([classBase, index])
        description = tags.div([classBase + ".description"], career.description.substring(0, 100))
        if career.description.length > 100
          description.className += " fade"
        description.appendTo([classBase, index])
        tags.hr([classBase + ".hr"]).appendTo([classBase, index])
        tags.div([classBase + ".experience"], "Experience Level " + career.experience_level.id).appendTo([classBase, index])
        scoreBox = tags.div([classBase + ".score"])
        scoreBox.appendChild(tags.span("percent", Math.round(score) + "%"))
        scoreBox.appendChild(tags.span("", "match"))
        scoreBox.appendTo([classBase, index])
        experienceBoxes = tags.div([classBase + ".experience-boxes"])
        for level in [1..career.experience_level.id]
          experienceBox = tags.div("experience-box")
          experienceBox.className += " highlighted-box"
          experienceBoxes.appendChild(experienceBox)
        for level in [1..(5-career.experience_level.id)]
          experienceBoxes.appendChild(tags.div("experience-box"))
        experienceBoxes.appendTo([classBase, index])
        education = tags.div([classBase + ".education"])
        education.appendChild(tags.span("", "Education: "))
        education.appendChild(tags.span("education-text", career.experience_level.degree))
        education.appendTo([classBase, index])
        if showDetails
          careerContainer.className += " show-details"
          do (career, detailsTarget) ->
            careerContainer.onclick = (event)->
              # Trigger before event (pass career)
              if detailsTarget
                target = detailsTarget
              else
                details = document.createElement("div")
                details.className = "popout-career"
                document.body.className += " tf-popout-open"
                document.body.appendChild(details)
                target = ".popout-career"
              careerDetailsWidget = Traitify.ui.widgets["careerDetails"](null, target, { careerDetails: { career: career, score: score }})
              careerDetailsWidget.run()
              # Trigger after event (pass career)
    )

    careersWidgetContainer
  )
)
