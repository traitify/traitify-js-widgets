Traitify.ui.widget("famousPeople", (widget, options)->
  widget.callbacks.add("Initialize")
  widget.dataDependency("PersonalityTypes")
  widget.styleDependency("all")
  widget.styleDependency("results/famous-people")

  
  ########################
  # INITIALIZE
  ########################
  widget.initialization.events.add("Setup Data", ->
    widget.views.render("Famous People").appendTo("main")

    widget.callbacks.trigger("Initialize")
  )

  #########################
  # PARTIALS
  #########################
  widget.views.add("Famous People", ->
    personality_blend = widget.data.get("PersonalityTypes").personality_blend
    people = personality_blend.famous_people.sort(-> 0.5 - Math.random())[0..4]

    @tags.div("tfFamousPeopleContainerScroller")

    @tags.div("personalityTypesContainer").appendTo("tfFamousPeopleContainerScroller")
    @tags.div("tfFamousPeople").appendTo("personalityTypesContainer")
    index = 0
    for person in people
        @tags.div(["tfFamousPerson"]).appendTo("tfFamousPeople")
        @tags.img(["tfImage"], person.picture).appendTo(["tfFamousPerson", index])
        @tags.div(["tfName"], Object(), person.name).appendTo(["tfFamousPerson", index])

        index++

    @tags.get("tfFamousPeopleContainerScroller")


  )

)
