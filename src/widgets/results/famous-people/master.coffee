Traitify.ui.widget("famousPeople", (widget, options)->
  widget.callbacks.add("Initialize")
  widget.dataDependency("PersonalityTypes")
  widget.styleDependency("all")
  widget.styleDependency("results/famous-people")

  widget.initialization.events.add("Setup Data", ->
    personality_blend = widget.data.get("PersonalityTypes").personality_blend
    peopleTag = riot.mountTo(widget.views.tags.get("main"), 'famouspeople')
    people = personality_blend.famous_people
    peopleTag.famousPeople = people
    peopleTag.update()

    widget.callbacks.trigger("Initialize")
  )
)
