Traitify.ui.widget("famousPeople", (widget, options)->
  widget.callbacks.add("Initialize")
  widget.dataDependency("PersonalityTypes")
  widget.styleDependency("all")
  widget.styleDependency("results/famous-people")

  widget.initialization.events.add("Setup Data", ->
    personality_type = widget.data.get("PersonalityTypes").personality_types[0].personality_type
    peopleTag = riot.mountTo(widget.views.tags.get("main"), 'famouspeople')
    people = personality_type.famous_people
    peopleTag.famousPeople = people
    peopleTag.update()

    widget.callbacks.trigger("Initialize")
  )
)
