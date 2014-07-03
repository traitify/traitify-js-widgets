window.Traitify.ui.resultsProp = (assessmentId, selector, options)->
  Builder = Object()
  Builder.nodes = Object()
  Builder.states = Object()
  Builder.data = Object()

  if selector.indexOf("#") != -1
    selector = selector.replace("#", "")
    Builder.nodes.main = document.getElementById(selector)
  else
    selector = selector.replace(".", "")
    selectedObject = document.getElementsByClassName(selector)
    Builder.nodes.main = if selectedObject then selectedObject[0] else null

  if !Builder.nodes.main
    console.log("YOU MUST HAVE A TAG WITH A SELECTOR FOR THIS TO WORK")
    return false

  Builder.classes = ->
    classes = Builder.main.className.split(" ")
    for key of classes
      classes[key] = "." + classes[key]
    classes.join ""

  # VIEW LOGIC
  Builder.partials = Object()
  Builder.partials.make = (elementType, attributes)->
    element = document.createElement(elementType)

    for attributeName of attributes
      element.setAttribute(attributeName, attributes[attributeName])

    element

  Builder.partials.div = (attributes)->
    @make("div", attributes)

  Builder.partials.img = (attributes)->
    @make("img", attributes)

  Builder.partials.i = (attributes)->
    @make("i", attributes)

  Builder.nodes.personalityTypes = Array()
  Builder.partials.personalityType = (typeData)->
    personalityType = @div({class:"personality-type"})

    badge = Builder.partials.badge(typeData.personality_type.badge)

    if typeData.score < 0
      barLeft = Builder.partials.barLeft(Math.abs(typeData.score))
      barRight = Builder.partials.barRight(0)
    else
      barLeft = Builder.partials.barLeft(0)
      barRight = Builder.partials.barRight(Math.abs(typeData.score))

    name = @div({class:"name"})
    name.innerHTML = typeData.personality_type.name

    score = @div({class:"score"})
    score.innerHTML = if typeData.score < 0 then "(#{Math.round(Math.abs(typeData.score))})" else Math.round(typeData.score)

    nameAndScore = @div({class:"name-and-score"})

    nameAndScore.appendChild(name)
    nameAndScore.appendChild(score)
    personalityType.appendChild(nameAndScore)

    personalityType.appendChild(barLeft)
    personalityType.appendChild(badge)
    personalityType.appendChild(barRight)

    Builder.nodes.personalityTypes.push({personalityType:personalityType, badge: badge})


    personalityType

  Builder.partials.badge = (badgeData)->
    badge = @div({class:"badge"})
    badge.appendChild(@img({src:badgeData.image_large}))
    badge 

  Builder.partials.barLeft = (scoreData)->
    last = Builder.nodes.personalityTypes.length - 1
    innerBarLeft = @div({class:"bar-inner-left"})
    innerBarLeft.style.width = scoreData + "%"
    barLeft = @div({class:"bar-left"})
    barLeft.appendChild(innerBarLeft)

    barLeft

  Builder.partials.barRight = (scoreData)->
    last = Builder.nodes.personalityTypes.length - 1
    innerBarRight = @div({class:"bar-inner-right"})
    innerBarRight.style.width = scoreData + "%"
    barRight = @div({class:"bar-right"})
    barRight.appendChild(innerBarRight)
    barRight

  Builder.partials.toggleTraits = ->
    toggleTraits = @div({class:"toggle-traits"})
    toggleTraits.innerHTML = "Show / Hide Traits"
    Builder.nodes.toggleTraits = toggleTraits
    toggleTraits

  Builder.nodes.personalityTraits = Array()
  Builder.partials.personalityTrait = (personalityTraitData)->
    personalityTrait = @div({class:"personality-trait"})
    leftName = @div({class:"left-name"})
    leftName.innerHTML = personalityTraitData.left_personality_trait.name

    rightName = @div({class:"right-name"})
    rightName.innerHTML = personalityTraitData.right_personality_trait.name

    personalityTrait.appendChild(leftName)
    personalityTrait.appendChild(rightName)

    traitScorePosition = Builder.partials.traitScorePosition(personalityTraitData.score)

    personalityTrait.appendChild(traitScorePosition)
    Builder.nodes.personalityTraits.push({personalityTrait: personalityTrait, leftName: leftName, rightName: rightName, score: traitScorePosition})

    personalityTrait

  Builder.partials.traitScorePosition = (score)->
    personalityTraitScoreContainer = @div({class:"score-container"})
    personalityTraitScoreWrapper = @div({class:"score-wrapper"})
    personalityTraitScoreContainer.appendChild(personalityTraitScoreWrapper)

    personalityTraitScore = @div({class:"score"})
    personalityTraitScore.style.left = score + "%"
    personalityTraitScoreWrapper.appendChild(personalityTraitScore)

    personalityTraitLine = @div({class:"line"})
    personalityTraitScoreContainer.appendChild(personalityTraitLine)

    personalityTraitScoreContainer

  Builder.partials.printButton = ->
    printButton = @div({class:"print-button"})
    Builder.nodes.printButton = printButton
    printButton.innerHTML = "Print"
    printButton

  Builder.actions = ->
    Builder.nodes.toggleTraits.onclick = ->
      if Builder.nodes.personalityTraitContainer
        if Builder.nodes.personalityTypesContainer.style.display == "block"
          Builder.nodes.personalityTypesContainer.style.display = "none"
          Builder.nodes.personalityTraitContainer.style.display = "block"
        else
          Builder.nodes.personalityTypesContainer.style.display = "block"
          Builder.nodes.personalityTraitContainer.style.display = "none"
      else
        Traitify.getPersonalityTraits(assessmentId, (data)->
          personalityTraitContainer = Builder.partials.div({class: "personality-traits"})
          Builder.nodes.personalityTraitContainer = personalityTraitContainer 

          for personalityTrait in data
            personalityTraitContainer.appendChild(Builder.partials.personalityTrait(personalityTrait))

          Builder.nodes.container.appendChild(personalityTraitContainer)
          Builder.nodes.personalityTypesContainer.style.display = "none"
          Builder.nodes.personalityTraitContainer.style.display = "block"
        )
    Builder.nodes.printButton.onclick = ->
      Builder.printWindow = window.open()

      Builder.nodes.printWindow = Object()
      Builder.nodes.printWindow.head = Builder.printWindow.document.getElementsByTagName("head")[0]
      Builder.nodes.printWindow.main = Builder.printWindow.document.getElementsByTagName("body")[0]
      Builder.nodes.printContainer = Builder.partials.div({class:"tf-results-prop"})
      Builder.nodes.printContainer.appendChild(Builder.nodes.stylesheet.cloneNode(true))

      Builder.nodes.printContainer.appendChild(Builder.nodes.personalityTypesContainer.cloneNode(true))
      if Builder.nodes.personalityTraitContainer
        Builder.nodes.printContainer.appendChild(Builder.nodes.personalityTraitContainer.cloneNode(true))

      Builder.nodes.printWindow.main.appendChild(Builder.nodes.printContainer)
      title = Builder.partials.make("title")
      title.innerHTML = "PERSONALITY TO PRINT"
      Builder.nodes.printWindow.head.appendChild(title)

  Builder.initialize = ->
    Builder.nodes.main.innerHTML = ""
    Traitify.getPersonalityTypes(assessmentId, (data)->
      Builder.data.personalityTypes = data.personality_types

      style = Builder.partials.make("link", {href:"https://s3.amazonaws.com/traitify-cdn/assets/stylesheets/results_prop.css", type:'text/css', rel:"stylesheet"})
      
      Builder.nodes.stylesheet = style
      Builder.nodes.main.appendChild(style)


      Builder.nodes.container = Builder.partials.div({class:"tf-results-prop"})

      if options && options.traits
        toolsContainer = Builder.partials.div({class:"tools"})

        Builder.nodes.toolsContainer = toolsContainer
        toolsContainer.appendChild(Builder.partials.printButton())
        toolsContainer.appendChild(Builder.partials.toggleTraits())
        
        Builder.nodes.container.appendChild(toolsContainer)

      Builder.nodes.personalityTypesContainer = Builder.partials.div({class:"personality-types"})
      Builder.nodes.container.appendChild(Builder.nodes.personalityTypesContainer)

      for personalityType in Builder.data.personalityTypes
        Builder.nodes.personalityTypesContainer.appendChild(Builder.partials.personalityType(personalityType))

      Builder.nodes.main.appendChild(Builder.nodes.container)

      Builder.actions()
    )
  
  Builder.initialize()

  Builder