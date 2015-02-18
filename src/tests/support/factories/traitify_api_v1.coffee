class ApiFactory extends FactoryBoy
  factories: ->
    @factory("badge", (factory)->
      {
        color_1: "a1887f",
        color_2: "",
        color_3: "",
        font_color: "fffff9",
        image_large: "../assets/images/cities.jpg",
        image_medium: "../assets/images/cities.jpg",
        image_small: "../assets/images/cities.jpg"
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
        image_desktop: "../assets/images/cities.jpg",
        image_desktop_retina: "../assets/images/cities.jpg",
        image_phone_landscape: "../assets/images/cities.jpg",
        image_phone_portrait: "../assets/images/cities.jpg",
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

    @factory("career", (factory)->
      {
        career: {
          bright_outlooks: null
          description: "Operate computer-controlled machines or robots to perform one or more machine functions on metal or plastic work pieces."
          employment_projection: {
            annual_salary_median_2012: 35580
            new_openings_2022: 20400
            new_openings_and_replacement_2022: 59600
            percent_growth_2022: 14.5
            source: "Bureau Of Labor Statistics - 2012"
            total_employees_2012: 140300
            total_employees_2022: 160700
          }
          experience_level: {
            education: "Most occupations in this zone require training in vocational schools, related on-the-job experience, or an associate's degree."
            examples: "These occupations usually involve using communication and organizational skills to coordinate, supervise, manage, or train others to accomplish goals. Examples include food service managers, electricians, agricultural technicians, legal secretaries, occupational therapy assistants, and medical assistants."
            experience: "Previous work-related skill, knowledge, or experience is required for these occupations. For example, an electrician must have completed three or four years of apprenticeship or several years of vocational training, and often must have passed a licensing exam, in order to perform the job."
            id: 3
            job_training: "Employees in these occupations usually need one or two years of training involving both on-the-job experience and informal training with experienced workers. A recognized apprenticeship program may be associated with these occupations."
            name: "Medium Preparation Needed"
            svp_range: "(6.0 to < 7.0)"
          }
          id: "51-4011.00"
          image: null
          majors: [{
            description: "A program that prepares individuals to apply technical knowledge and skills to operate computer numerically controlled (CNC) machine tools, such as lathes, mills, precision measuring tools, and related attachments and accessories, to perform machining functions, such as cutting, drilling, shaping, and finishing products and component parts. Includes instruction in CNC terminology, setup, programming, operations, and troubleshooting; blueprint reading; machining; lathe and mill operations; technical mathematics; computer literacy; CAD/CAM systems; shop and safety practices; equipment capabilities; and regulations and laws."
            group_id: "48"
            id: "48.0510"
            title: "Computer Numerically Controlled (CNC) Machinist Technology/CNC Machinist."
          }]
          salary_projection: {
            annual_salary_10_percentile: 23690
            annual_salary_25_percentile: 28590
            annual_salary_75_percentile: 44530
            annual_salary_90_percentile: 54100
            annual_salary_mean: 37310
            annual_salary_median: 35900
            hourly_rate_10_percentile: 11.39
            hourly_rate_25_percentile: 13.75
            hourly_rate_75_percentile: 21.41
            hourly_rate_90_percentile: 26.01
            hourly_rate_mean: 17.94
            hourly_rate_median: 17.26
            source: "Bureau Of Labor Statistics - May 2013"
            total_employees: 139930
          }
          title: "Computer-Controlled Machine Tool Operators, Metal and Plastic"
        },
        score: 97.58137007726197
      }
    )
    @factory("careers", (factory, options)->
      careers = Array()
      (options.number - 1).times((i)->
        careers.push(factory.build("career"))
      )
      careers
    )

apiFactory = new ApiFactory()
