Traitify.ui.widget("careers", (widget, options)->
  widget.states.add("initialized")
  widget.callbacks.add("Initialize")
  widget.styleDependency("all")
  widget.styleDependency("results/careers")

  if widget.options.careers
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
      options = { number_of_matches: widget.options.careers.number_of_matches }
      if widget.options.careers.experience_levels
        options["experience_levels"] = widget.options.careers.experience_levels
      showDetails = true
      columns = widget.options.careers.columns || 4
      filter = ("filter" of widget.options.careers) && widget.options.careers.filter
      if widget.options.careers.details
        detailsTarget = widget.options.careers.details.target
        if widget.options.careers.details.show?
          showDetails = widget.options.careers.details.show

      careersWidgetContainer = @tags.div("tfCareers")
      if Traitify.oldIE
        careersWidgetContainer.className += " ie"

      if filter
        filterBoxes = @tags.div("tfExperienceFilters")
        filterBoxes.appendChild(@tags.div("tfFilterHeader", "Experience Level: "))
        for level in [0..5]
          if level == 0
            level = "All"
          filterBox = @tags.div("tfExperienceFilter", "" + level)
          previous = options["experience_levels"] || ""
          if (("" + level) in previous.split(",")) || (previous == "" && level == "All")
            filterBox.className += " tf-highlight-filter"
          do (level) ->
            filterBox.onclick = (event) ->
              event.preventDefault()
              if level != "All"
                widget.options.careers.experience_levels = "" + level
              else
                delete widget.options.careers.experience_levels
              careersWidgetContainer.parentNode.removeChild(careersWidgetContainer)
              widget.views.remove("Careers Container")
              remakeWidget = Traitify.ui.widgets["careers"](widget.assessmentId, widget.target, widget.options)
              remakeWidget.run()
              return false
          filterBoxes.appendChild(filterBox)
        filterBoxes.appendTo("tfCareers")

      for column in [0..columns-1]
        column = @tags.div("tf-column-" + column)
        column.className += " tf-column tf-columns-" + columns
        column.appendTo("tfCareers")

      tags = @tags

      displayCareers = (careers) ->
        for career, i in careers
          score = career.score
          career = career.career
          column = i % columns
          index = Math.floor(i / columns)
          classBase = "tf-column-" + column + ".tf-career"

          careerContainer = tags.div([classBase])
          careerContainer.appendTo("tf-column-" + column)
          career.picture ?= "https://cdn.traitify.com/assets/images/career-details/default-career.jpg"
          tags.img([classBase + ".tf-image"], career.picture).appendTo([classBase, index])
          tags.div([classBase + ".tf-title"], career.title).appendTo([classBase, index])
          description = tags.div([classBase + ".tf-description"], career.description)
          if career.description.length > 100
            description.className += " tf-fade"
          description.appendTo([classBase, index])
          tags.hr([classBase + ".tf-hr"]).appendTo([classBase, index])
          tags.div([classBase + ".tf-experience"], "Experience Level").appendTo([classBase, index])
          scoreBox = tags.div([classBase + ".tf-score"])
          scoreBox.appendChild(tags.span("tf-percent", Math.round(score) + "%"))
          scoreBox.appendChild(tags.span("", "match"))
          scoreBox.appendTo([classBase, index])
          experienceBoxes = tags.div([classBase + ".tf-experience-boxes"])
          for level in [0..(career.experience_level.id-1)]
            experienceBox = tags.div("tf-experience-box")
            experienceBox.className += " tf-highlighted-box"
            experienceBoxes.appendChild(experienceBox)
          if level < 5
            for level in [1..(5-career.experience_level.id)]
              experienceBoxes.appendChild(tags.div("tf-experience-box"))
          experienceBoxes.appendTo([classBase, index])
          education = tags.div([classBase + ".tf-education"])
          education.appendChild(tags.span("", "Education: "))
          education.appendChild(tags.div("tf-education-text", career.experience_level.degree))
          education.appendTo([classBase, index])
          if showDetails
            careerContainer.className += " tf-show-details"
            do (career, score, detailsTarget) ->
              careerContainer.onclick = (event)->
                event.preventDefault()
                # Trigger before event (pass career)
                if detailsTarget
                  target = detailsTarget
                else
                  details = document.createElement("div")
                  details.className = "tf-popout-career"
                  document.getElementsByTagName("html")[0].className += " tf-popout-open"
                  document.body.appendChild(details)
                  target = ".tf-popout-career"
                Traitify.ui.load("careerDetails", null, target, { careerDetails: { career: career, score: score }})
                # Trigger after event (pass career)
                return false

      if widget.options.careers.data
        displayCareers(widget.options.careers.data)
      else
        Traitify.getCareers(widget.assessmentId, options, displayCareers)

      careersWidgetContainer
    )
)
