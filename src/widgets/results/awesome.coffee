Traitify.ui.styles = ""
Traitify.ui.widget("Awesome", (widget, options)->
	widget.dataDependency("PersonalityTraits")
	widget.views.add("theBest", ->
		name = widget.data.get("PersonalityTraits")[0].personality_trait.name
		@tags.div("firstTrait", name)
	)
	widget.initialization.events.add("In the Beginning", ->
		widget.views.render("theBest").appendTo("main")
	)
)