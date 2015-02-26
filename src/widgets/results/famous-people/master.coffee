Traitify.ui.widget("famousPeople", (widget, options)->
  widget.callbacks.add("Initialize")
  widget.dataDependency("PersonalityTypes")
  widget.styleDependency("all")
  widget.styleDependency("results/famous-people")

  widget.initialization.events.add("Setup Data", ->
    personality_type = widget.data.get("PersonalityTypes").personality_types[0].personality_type
    peopleTag = riot.mountTo(widget.views.tags.get("main"), 'famouspeople')
    person = ->
      {
        picture: "http://traitify-api.s3.amazonaws.com/famous_people/6adc1b25-491c-4d4a-8ad0-298f6c71da28.jpeg",
        name: "Arnold Schwartzeneger"
      }
    people = personality_type.famous_people
    people = [person(), person(), person()]
    peopleTag.famousPeople = people
    peopleTag.update()

    widget.callbacks.trigger("Initialize")
  )
)
