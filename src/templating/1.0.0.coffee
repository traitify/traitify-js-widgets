Templating = ->
    Builder = Object()
    Builder.nodes = Object()
    Builder.query = (query)->
      document.querySelectorAll(query)


    # Templates
    Builder.templates = Object()
    Builder.templates.results = ->

    Builder.templates.personalityTypes = ->
        

    Builder.templates.setup = ()->
        Builder.templates.personalityTypes = Builder.query("template[name=tf-personality-types]")

    Builder.helpers = Object()
    Builder.helpers.onload = (callBack)->
        if (window.addEventListener)
              window.addEventListener('load', callBack)
        else if (window.attachEvent)
              window.attachEvent('onload', callBack)

    Builder.templates.render = (assessmentId, personalityType)->
        if Builder.templates[personalityType]
            for oldPersonalityTypes in Builder.templates[personalityType]
                personalityType.parentNode.removeChild(oldPersonalityTypes)
        Builder.templates[personalityType] = Array()
        Traitify.getPersonalityTypes(assessmentId, (data)->
            for personalityTypeData in data.personality_types
                personalityTypesNode = document.createElement("div")
                personalityTypesNode.innerHTML = personalityType.innerHTML

                Builder.bindings.names(personalityTypeData, personalityTypesNode.getElementsByTagName("name"))
                Builder.bindings.badges(personalityTypeData, personalityTypesNode.getElementsByTagName("badge-image"))
                Builder.bindings.scores(personalityTypeData, personalityTypesNode.getElementsByTagName("score"))

                color_1 = personalityTypeData.personality_type.badge.color_1
                color_2 = personalityTypeData.personality_type.badge.color_2
                color_3 = personalityTypeData.personality_type.badge.color_3

                innerHTML = personalityTypesNode.innerHTML
                innerHTML = innerHTML.replace(/{{score}}/g, personalityTypeData.score)
                innerHTML = innerHTML.replace(/{{name}}/g, personalityTypeData.personality_type.name)
                innerHTML = innerHTML.replace(/{{badgeUrl}}/g, personalityTypeData.personality_type.badge.image_large)
                innerHTML = innerHTML.replace(/{{colorLight}}/g, color_1)
                innerHTML = innerHTML.replace(/{{colorMedium}}/g, color_2)
                innerHTML = innerHTML.replace(/{{colorDark}}/g, color_3)

                personalityTypesNode.innerHTML = innerHTML
                personalityType.parentNode.insertBefore(personalityTypesNode, personalityType)
                Builder.templates[personalityType].push(personalityTypesNode)

                for attribute in personalityType.attributes
                    if attribute.name != "name"
                        attributeValue = attribute.value
                        attributeValue = attributeValue.replace(/{{colorLight}}/g, color_1)
                        attributeValue = attributeValue.replace(/{{colorMedium}}/g, color_2)
                        attributeValue = attributeValue.replace(/{{colorDark}}/g, color_3)

                        personalityTypesNode.setAttribute(attribute.name, attributeValue)
        )


    # Bindings
    Builder.bindings = Object()
    Builder.bindings.personalityTypes = ->

            for personalityType in Builder.templates.personalityTypes
                assessmentId = personalityType.getAttribute("assessment-id")
                Builder.templates.render(assessmentId, personalityType)

    Builder.bindings.names = (personalityType, names)->
        for name in names
            name.innerHTML = personalityType.personality_type.name

    Builder.bindings.badges = (personalityType, badges)->
        for badge in badges
            image = document.createElement("img")
            image.src = personalityType.personality_type.badge.image_large
            image.style.width="100%"
            badge.appendChild(image)

    Builder.bindings.scores = (personalityType, scores)->
        for score in scores
            if personalityType.score > 0
                scoreValue = Math.round(personalityType.score)
            else
                scoreValue = "(#{Math.abs(Math.round(personalityType.score))})"

            score.innerHTML = scoreValue


    # Initialize
    Builder.initialize = ->
      Builder.templates.setup()
      Builder.bindings.personalityTypes()
      if Builder.callbacks.initialized
        Builder.callbacks.initialized()
      else
        Builder.initialized = true


    Builder.helpers.onload(->
        Builder.initialize()
    )

    Builder.callbacks = Object()
    Builder.onInitialize = (callBack)->
        if Builder.initialized == true
            callBack()

        Builder.callbacks.initialized = callBack

    Builder


window.Traitify.templating = Templating()

