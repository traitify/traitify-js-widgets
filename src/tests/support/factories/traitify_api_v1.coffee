class ApiFactory extends FactoryBoy
  factories: ->
    @factory("badge", (factory)->
      {
        color_1: "a1887f",
        color_2: "",
        color_3: "",
        font_color: "fffff9",
        image_large: "#/badges/charmer/linear/large",
        image_medium: "#/badges/charmer/linear/medium",
        image_small: "#/badges/charmer/linear/small"
      }
    )

    @factory("personalityType", (factory, options, index)->
      name = ["Charmer", "Inventor"][index % 6]
      {
        badge: factory.build("badge")
        description: "A #{name} and can draw people in like flies to honey."
        details: [{body:"", title: "Complimentary"}, {body:"", title: "Conflict"}, {body:"", title: "Application"}]
        id: "dc3bb0a3-72da-44f5-9cf9-b5cbb186bda8"
        keywords: "relationships, listener, compassionate, sweet"
        name: name
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

    @factory("slide", (factory, options, index)->
      name = ["Navigating", "Paddling", "None of Your Business", "Really?"][ index - 1 % 3]

      slide  = {
        caption: name,
        focus_x: 50,
        focus_y: 50,
        id: UUID(),
        image_desktop: "#/sample",
        image_desktop_retina: "#/desktop_retina",
        image_phone_landscape: "#/sample",
        image_phone_portrait: "#/sample",
        completed_at: null,
        position: index + 1
      }

      if options && options.played
        slide.completed_at = new Date().getMilliseconds()
      slide
    )

    @factory("slides", (factory, options)->
      slides = Array()
      (options.number - 1).times((i)->
        slides.push(factory.build("slide", options))
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
    @factory("detail", (factory, options)->
      {
        body: "You like things running smoothly.",
        title: "Complement"
      }
    )
    @factory("details", (factory, options)->
      details = Array()
      3.times(->
        details.push(factory.build("detail"))
      )
      details
    )
    @factory("environment", (factory, options)->
      {
        active: true,
        created_at: 1409256158085,
        description: "",
        id: UUID(),
        name: "Allows for work to be done in an organized fashion"
      }
    )
    @factory("environments", (factory, options)->
      environments = Array()
      3.times(->
        environments.push(factory.build("environment"))
      )
      environments
    )
    @factory("personalityWithBlend", (factory, options)->
      types = Array()
      5.times(->
        types.push({score:10, personality_type: factory.build("personalityType")})
      )

      {
        personality_blend: {
          description: "You are invested in the people around there.",
          details: factory.build("details"),
          environments: factory.build("environments"),
          famous_people: Array(),
          keywords: null,
          nullname: "Planners/Mentors",
          personality_group: null,
          personality_type_1: factory.build("personalityType"),
          personality_type_2: factory.build("personalityType")
        },
        personality_types: types
      }
    )

apiFactory = new ApiFactory()