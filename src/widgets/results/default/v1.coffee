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
    if Traitify.oldIE
        @tags.get("tfResults").className += " ie"
    @render("Personality Blend").appendTo("tfResults")
    @tags.library.get("tfResults")
  )

  widget.views.add("Personality Blend", ->
    if widget.data.get("PersonalityTypes").personality_blend

      @tags.div("personalityBlend")
      personalityBlendData = widget.data.get("PersonalityTypes").personality_blend
      @render("Personality Blend Badges").appendTo("personalityBlend")
      personalityName = if personalityBlendData.name then personalityBlendData.name.replace("/", "/&#8203;") else ""
      @tags.div("name", personalityName).appendTo("personalityBlend")
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

    unless Traitify.oldIE
        leftBadgeCSS = {style: {
          backgroundColor: "rgba(#{hexColorOne.join(', ')}, .07)",
          borderColor: "##{typeOneData.badge.color_1}"
        }}
    else
        leftBadgeCSS = {}
    @tags.div("leftBadge", leftBadgeCSS).appendTo("badgesContainer")
    @tags.img("leftBadgeImage", typeOneData.badge.image_medium).appendTo("leftBadge")

    typeTwoData = personalityBlendData.personality_type_2
    hexColorTwo = widget.helpers.hexToRGB(typeTwoData.badge.color_1)

    unless Traitify.oldIE
        rightBadgeCSS = {style:{
          backgroundColor: "rgba(#{hexColorTwo.join(', ')}, .07)",
          borderColor: "##{typeTwoData.badge.color_1}"
        }}
    else
        rightBadgeCSS = {}
    @tags.div("rightBadge", rightBadgeCSS).appendTo("badgesContainer")
    @tags.img("leftBadgeImage", typeTwoData.badge.image_medium).appendTo("rightBadge")

    @tags.library.get("badgesContainer")
  )

  widget.views.add("Personality Type Badge", ->
    personalityTypeData = widget.data.get("PersonalityTypes").personality_types[0].personality_type

    @tags.div("badgesContainer")

    hexColor = widget.helpers.hexToRGB(personalityTypeData.badge.color_1)
    BGColor = if Traitify.oldIE then "#{personalityTypeData.badge.color_1}" else "rgba(#{hexColor.join(', ')}, .07)"
    badge = @tags.div("badge", {style:{
      backgroundColor: BGColor
      borderColor: "##{personalityTypeData.badge.color_1}"
    }}).appendTo("badgesContainer")

    image = @tags.img("badgeImage", personalityTypeData.badge.image_medium).appendTo("badge")

    @tags.library.get("badgesContainer")
  )
)
