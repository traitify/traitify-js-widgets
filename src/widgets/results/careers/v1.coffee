Traitify.ui.widget("careers", (widget, options)->
  widget.states.add("initialized")
  widget.callbacks.add("Initialize")
  widget.dataDependency("Careers")
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

    for career in @data.get("Careers")
      career = career.career

      @tags.div(["careers.career"]).appendTo("careers")
      @tags.img(["careers.career.image"], career.image).appendTo(["careers.career", _i])
      @tags.div(["careers.career.title"], career.title).appendTo(["careers.career", _i])
      description = @tags.div(["careers.career.description"], career.description.substring(0, 220))
      if career.description.length > 300
        description.className += " fade"
      description.appendTo(["careers.career", _i])
      @tags.hr(["careers.career.hr"]).appendTo(["careers.career", _i])
      @tags.div(["careers.career.experience"], "Experience Level " + career.experience_level.id).appendTo(["careers.career", _i])
      experienceBoxes = @tags.div(["careers.career.experience-boxes"])
      for level in [1..career.experience_level.id]
        experienceBox = @tags.div("experience-box")
        experienceBox.className += " highlighted-box"
        experienceBoxes.appendChild(experienceBox)
      for level in [1..(5-career.experience_level.id)]
        experienceBoxes.appendChild(@tags.div("experience-box"))
      experienceBoxes.appendTo(["careers.career", _i])
      @tags.div(["careers.career.education"], career.experience_level.education).appendTo(["careers.career", _i])

    careersWidgetContainer
  )
)
