Traitify.ui.widget("results", (widget, options)->
  widget.states.add("initialized")
  widget.callbacks.add("Initialize")
  widget.dataDependency("PersonalityTypes")
  widget.styleDependency("all")
  widget.styleDependency("results/default")
  
  ########################
  # INITIALIZE
  ########################
  widget.initialization.events.add("Setup Data", ->
    widget.views.render("Results").appendTo("main")
    widget.callbacks.trigger("Initialize")
  )

  #########################
  # PARTIALS
  #########################
  widget.views.add("Results", ->
    @tags.div("tfResults")
    @render("Personality Blend").appendTo("tfResults")
    @tags.library.get("tfResults")
  )

  widget.views.add("Personality Blend", ->
    if widget.data.get("PersonalityTypes").personality_blend

      @tags.div("personalityBlend")
      personalityBlendData = widget.data.get("PersonalityTypes").personality_blend
      @render("Personality Blend Badges").appendTo("personalityBlend")
      @tags.div("name", personalityBlendData.name).appendTo("personalityBlend")
      @tags.div("blendDescription", personalityBlendData.description).appendTo("personalityBlend")
    else
      @tags.div("personalityType")
      personalityTypeData = widget.data.get("PersonalityTypes").personality_types[0].personality_type

      @render("Personality Type Badge").appendTo("personalityType")
      @tags.div("name", personalityTypeData.name).appendTo("personalityType")
      @tags.div("typeDescription", personalityTypeData.description).appendTo("personalityType")
    
    @tags.library.get("personalityBlend") or @tags.library.get("personalityType")
  )

  widget.views.add("Personality Blend Badges", ->
    personalityBlendData = widget.data.get("PersonalityTypes").personality_blend
    typeOneData = personalityBlendData.personality_type_1
    hexColorOne = widget.helpers.hexToRGB(typeOneData.badge.color_1)
    @tags.div("badgesContainer")

    @tags.div("leftBadge", {style: {
      backgroundColor: "rgba(#{hexColorOne.join(', ')}, .07)",
      borderColor: "##{typeOneData.badge.color_1}"
    }}).appendTo("badgesContainer")
    @tags.img("leftBadgeImage", typeOneData.badge.image_medium).appendTo("leftBadge")
    
    
    typeTwoData = personalityBlendData.personality_type_2
    hexColorTwo = widget.helpers.hexToRGB(typeTwoData.badge.color_1)
    @tags.div("rightBadge", {style:{
      "background-color":"rgba(#{hexColorTwo.join(', ')}, .07)",
      "border-color": "##{typeTwoData.badge.color_1}"
    }}).appendTo("badgesContainer")
    @tags.img("leftBadgeImage", typeTwoData.badge.image_medium).appendTo("rightBadge")

    @tags.library.get("badgesContainer")
  )

  widget.views.add("Personality Type Badge", ->
    personalityTypeData = widget.data.get("PersonalityTypes").personality_types[0].personality_type

    @tags.div("badgesContainer")

    hexColor = widget.helpers.hexToRGB(personalityTypeData.badge.color_1)
    badge = @tags.div("badge", {style:{
      backgroundColor: "rgba(#{hexColor.join(', ')}, .07)"
      borderColor: "##{personalityTypeData.badge.color_1}"
    }}).appendTo("badgesContainer")

    image = @tags.img("badgeImage", personalityTypeData.badge.image_medium).appendTo("badge")

    @tags.library.get("badgesContainer")
  )
)
