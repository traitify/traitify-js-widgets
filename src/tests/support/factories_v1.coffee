class FactoryBoy
  constructor: ->
    @factoryStore = Object()
    @factories() if @factories
    @
  factory: (key, hash)->
    @factoryStore[key] = hash
  build: (key, options)->
    if @factoryStore[key]
      @factoryStore[key](@, options)
    else
      console.log("Your Factory #{key} Doesn't Exist")

class ApiFactory extends FactoryBoy
  factories: ->
    @factory("badge", (factory)->
      {
        color_1: "a1887f",
        color_2: "",
        color_3: "",
        font_color: "fffff9",
        image_large: "https://traitify-api.s3.amazonaws.com/badges/charmer/linear/large",
        image_medium: "https://traitify-api.s3.amazonaws.com/badges/charmer/linear/medium",
        image_small: "https://traitify-api.s3.amazonaws.com/badges/charmer/linear/small"
      }
    )

    @factory("personalityType", (factory)->
      {
        badge: factory.build("badge")
        description: "A people-person who connects deeply with others, the Charmer’s power is derived from   the capacity for and strength of relationships.  The Charmer is attuned to the emotional needs of others and can draw people in like flies to honey. "
        details: [{body:"", title: "Complimentary"}, {body:"", title: "Conflict"}, {body:"", title: "Application"}]
        id: "dc3bb0a3-72da-44f5-9cf9-b5cbb186bda8"
        keywords: "relationships, listener, compassionate, sweet"
        name: "Charmer"
      }
    )
    @factory("personalityTypes", (factory, options)->
      personalityTypes = Array()
      (options.number - 1).times((i)->
        personalityTypes.push(factory.build("personalityType"))
      )

      personalityTypes
    )
    @factory("personalityTrait", (factory)->
      {
        personality_trait: {
          definition: "Feeling deep sympathy and sorrow for another stricken by misfortune"
          description: ""
          name: "Compassionate"
          personality_type: factory.build("personalityType")
        }
        score: 100
      }
    )

    @factory("personalityTraits", (factory, options)->
      traits = Array()
      (options.number - 1).times((i)->
        traits.push(factory.build("personalityTrait"))
      )
      traits
    )

    @factory("slide", (factory, options)->
      {id: UUID(), caption: "Navigating"}
    )

    @factory("slides", (factory, options)->
      slides = Array()
      (options.number - 1).times((i)->
        slides.push(factory.build("slide"))
      )
      slides
    )
    @factory("personality", (factory, options)->
      types = Array()
      5.times(->
        types.push({score:10, personality_type: factory.build("personalityType")})
      )

      {
        personality_blend: "", 
        personality_types: types
      }
    )

apiFactory = new ApiFactory()