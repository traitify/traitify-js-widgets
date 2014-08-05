Templating = ->
    Builder = Object()
    Builder.analytics = Object()
    Builder.analytics.startTime = new Date().getTime()
    Builder.nodes = Object()
    Builder.callbacks = Object()
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
        Builder.analytics.startTypesTime = new Date().getTime()
        Traitify.getPersonalityTypes(assessmentId, (data)->
            Builder.analytics.endTypesTime = new Date().getTime()
            Builder.analytics.afterGettingResults = new Date().getTime() 
            if personalityType.getAttribute("hero-type")
              data.personality_types = data.personality_types.slice(0, 1)
              
            if only = personalityType.getAttribute("only-types")
              only = only.split(",")
              data.personality_types = data.personality_types.filter( (tp,i)->
                only.indexOf("#{i}") != -1
              )
        
            if except = personalityType.getAttribute("except-types")
              types = data.personality_types
              except = except.split(",").map((data)->
                parseInt(data)
              )
              data.personality_types = data.personality_types.filter( (tp, i)->
                except.indexOf("#{i}") == -1
              )

            for index of data.personality_types
                personalityTypeData = data.personality_types[index]
                personalityTypesNode = document.createElement("div")

                color_1 = personalityTypeData.personality_type.badge.color_1
                color_2 = personalityTypeData.personality_type.badge.color_2
                color_3 = personalityTypeData.personality_type.badge.color_3

                innerHTML = personalityType.innerHTML
                if personalityTypeData.score > 0
                    scoreValue = Math.round(personalityTypeData.score)
                else
                    scoreValue = "(#{Math.abs(Math.round(personalityTypeData.score))})"

                innerHTML = innerHTML.replace(/{{score}}/g, scoreValue)
                innerHTML = innerHTML.replace(/{{name}}/g, personalityTypeData.personality_type.name)
                innerHTML = innerHTML.replace(/{{badge.large}}/g, personalityTypeData.personality_type.badge.image_large)
                innerHTML = innerHTML.replace(/{{badge.medium}}/g, personalityTypeData.personality_type.badge.image_medium)
                innerHTML = innerHTML.replace(/{{badge.small}}/g, personalityTypeData.personality_type.badge.image_small)
                innerHTML = innerHTML.replace(/{{color.light}}/g, color_1)
                innerHTML = innerHTML.replace(/{{color.medium}}/g, color_2)
                innerHTML = innerHTML.replace(/{{color.dark}}/g, color_3)
                innerHTML = innerHTML.replace(/{{index}}/g, index)
                innerHTML = innerHTML.replace(/{{description}}/g, personalityTypeData.personality_type.description)
                name = personalityTypeData.personality_type.name
                innerHTML = innerHTML.replace(/{{name.lowercase}}/g,  name.toLowerCase())
                    
                
                innerHTML = innerHTML.replace(/{{name.camelcase}}/g,  name)
                innerHTML = innerHTML.replace(/{{name.uppercase}}/g,  name.toUpperCase())
            
                personalityTypesNode.innerHTML = innerHTML
                personalityType.parentNode.insertBefore(personalityTypesNode, personalityType)
                Builder.templates[personalityType].push(personalityTypesNode)

                for attribute in personalityType.attributes
                    if attribute.name != "name"
                        attributeValue = attribute.value
                        attributeValue = attributeValue.replace(/{{color.light}}/g, color_1)
                        attributeValue = attributeValue.replace(/{{color.medium}}/g, color_2)
                        attributeValue = attributeValue.replace(/{{color.dark}}/g, color_3)

                        personalityTypesNode.setAttribute(attribute.name, attributeValue)
                        
            Builder.analytics.endTime = new Date().getTime()  
        )


    # Bindings
    Builder.bindings = Object()
    Builder.bindings.personalityTypes = ->
      for personalityType in Builder.templates.personalityTypes
        assessmentId = personalityType.getAttribute("assessment-id")
        if assessmentId
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
        Builder
        
    if Builder.callbacks.initialized
        Builder.callbacks.initialized()
    else
        Builder.initialized = true

    Builder.autoInitialize = ->
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

