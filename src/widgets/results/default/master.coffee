Traitify.ui.loaders ?= Object()
Traitify.ui.loaders.results = (assessmentId, target, options)->
  options ?= Object()
  if Traitify.ui.widgets.results
    results = Traitify.ui.widgets.results(new Widget(target), options)
    results.nodes().main.innerHTML = Traitify.ui.styles
    Traitify.getPersonalityTypes(assessmentId, options.params || Object()).then((data)->
      results.data = data
      results.run()
    )
    results

Traitify.ui.widgets ?= Object()
Traitify.ui.widgets.results = (Widget, options)->
  Widget.states.add("initialized")
  Widget.callbacks.add("Initialize")
  
  ########################
  # INITIALIZE
  ########################
  Widget.initialization.events.add("Setup Data", ->
    Widget.views.render("Results").appendTo("main")
    Widget.callbacks.trigger("Initialize")
  )

  #########################
  # PARTIALS
  #########################
  Widget.views.add("Results", ->
    @tags.div("tfResults")
    @render("Personality Blend").appendTo("tfResults")
    @tags.library.get("tfResults")
  )

  Widget.views.add("Personality Blend", ->
    if Widget.data.personality_blend

      @tags.div("personalityBlend")
      personalityBlendData = Widget.data.personality_blend
      @render("Personality Blend Badges").appendTo("personalityBlend")
      @tags.div("name", personalityBlendData.name).appendTo("personalityBlend")
      @tags.div("blendDescription", personalityBlendData.description).appendTo("personalityBlend")
    else
      @tags.div("personalityType")
      personalityTypeData = Widget.data.personality_types[0].personality_type

      @render("Personality Type Badge").appendTo("personalityType")
      @tags.div("name", personalityTypeData.name).appendTo("personalityType")
      @tags.div("typeDescription", personalityTypeData.description).appendTo("personalityType")
    
    @tags.library.get("personalityBlend") or @tags.library.get("personalityType")
  )

  Widget.views.add("Personality Blend Badges", ->
    personalityBlendData = Widget.data.personality_blend
    typeOneData = personalityBlendData.personality_type_1
    hexColorOne = Widget.helpers.hexToRGB(typeOneData.badge.color_1)
    @tags.div("badgesContainer")

    @tags.div("leftBadge", {style: {
      backgroundColor: "rgba(#{hexColorOne.join(', ')}, .07)",
      borderColor: "##{personalityBlendData.personality_type_1.badge.color_1}"
    }}).appendTo("badgesContainer")
    @tags.img("leftBadgeImage", typeOneData.badge.image_medium).appendTo("leftBadge")
    
    
    typeTwoData = personalityBlendData.personality_type_2
    hexColorTwo = Widget.helpers.hexToRGB(typeTwoData.badge.color_1)
    @tags.div("rightBadge", {style:{
      "background-color":"rgba(#{hexColorTwo.join(', ')}, .07)",
      "border-color": "##{typeTwoData.badge.color_1}"
    }}).appendTo("badgesContainer")
    @tags.img("leftBadgeImage", typeTwoData.badge.image_medium).appendTo("rightBadge")

    @tags.library.get("badgesContainer")
  )

  Widget.views.add("Personality Type Badge", ->
    personalityTypeData = Widget.data.personality_types[0].personality_type

    @tags.div("badgesContainer")

    hexColor = Widget.helpers.hexToRGB(personalityTypeData.badge.color_1)
    badge = @tags.div("badge").appendTo("badgesContainer")

    image = @tags.img("badgeImage", personalityTypeData.badge.image_medium, {style:{
      backgroundColor: "rgba(#{hexColor.join(', ')}, .07)"
      borderColor: "##{personalityTypeData.badge.color_1}"
    }}).appendTo("badge")

    @tags.library.get("badgesContainer")
  )
  Widget
