testSuite.add("master", ->
  ###############################
  # External Libraries
  ###############################
  require("../compiled/tests/factories/traitify_api_v1")
  require("../compiled/tests/mocks/traitify_mocks_v1")

  ###############################
  # Libraries
  ###############################
  require("../compiled/api/master", cover: true)
  require("../compiled/ui/master", cover: true)
  require("../compiled/builder/master", cover: true)
  require("../compiled/widgets/slide_deck/master", cover: true)
  require("../compiled/widgets/results/default/master", cover: true)
  require("../compiled/widgets/results/personality-traits/master", cover: true)
  require("../compiled/widgets/results/personality-types/master", cover: true)
  require("../assets/widgets/slide_deck/master", "css")

  ###############################
  # Tests
  ###############################
  require("../compiled/tests/builder_spec")
  require("../compiled/tests/api_spec")
  require("../compiled/tests/slide_deck_spec")
  require("../compiled/tests/results_spec")
  require("../compiled/tests/loader_spec")
  require("../compiled/tests/results_traits_spec")
  require("../compiled/tests/results_personality_types_spec")

  div(id: "test-case-container")
)


testSuite.add("api", ->
  ###############################
  # External Libraries
  ###############################

  require("../compiled/tests/support/factories_v1")
  require("../compiled/tests/support/mocks_v1")

  ###############################
  # Libraries To Test
  ###############################
  require("../compiled/api/master", cover: true)


  ###############################
  # Tests
  ###############################
  require("../compiled/tests/api")
)

testSuite.run()