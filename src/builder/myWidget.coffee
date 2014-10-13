Traitify.ui.widget("myWidget", (widget, options = Object())->
  widget.callbacks.add("Initialize")
  widget.dataDepends("PersonalityTypes")
  widget.views.add("personalityTypes", ->
    @tags.div("types", type.personality_type.name)
    for type in widget.data.get("PersonalityTypes").personality_types
      @tags.div(["type.name"], type.personality_type.name).appendTo("types")
    @tage.get("types")
  )
  widget.initialization.events.add("Setup Data", ->
    widget.views.render("personalityTypes").appendTo("main")
    widget.callbacks.trigger("Initialize")
  )
)