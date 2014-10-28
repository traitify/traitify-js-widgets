###############################
# Preparation
###############################
unPlayedAssessment = "unplayed"
playedAssessment = "played"
playedWithBlend = "played_with_blend"

document.write("
  <style>
    .phone.tf-slide-deck-container .slide{
      -moz-transition: none !important;
      -webkit-transition: none !important;
      -o-transition: color 0 ease-in !important;
      transition: none !important;
    }
  </style>
")

body = document.getElementsByTagName("body")[0]

link("./support/qunit-1.14.0.css")
div(id: "qunit")
div(id: "qunit-fixture")

require("../compiled/tests/support/mocker")
testSuite.add("edge", ->
  ###############################
  # External Libraries
  ###############################
  require("../compiled/tests/support/factories/traitify_api_v1")
  require("../compiled/tests/support/mocks/traitify_mocks_v1")

  ###############################
  # Libraries
  ###############################
  require("../compiled/api/master", cover: true)
  require("../compiled/ui/master", cover: true)
  require("../compiled/builder/master", cover: true)
  require("../compiled/widgets/slide-deck/master", cover: true)
  require("../compiled/widgets/results/default/master", cover: true)
  require("../compiled/widgets/results/personality-traits/master", cover: true)
  require("../compiled/widgets/results/personality-types/master", cover: true)
  require("../assets/widgets/slide-deck/master", "css")

  ###############################
  # Tests
  ###############################
  require("../compiled/tests/edge/builder_spec")
  #require("../compiled/tests/edge/slide_deck_spec")
  require("../compiled/tests/edge/results_spec")
  require("../compiled/tests/edge/loader_spec")
  require("../compiled/tests/edge/results_traits_spec")
  require("../compiled/tests/edge/results_personality_types_spec")

  div(id: "test-case-container")
)

testSuite.add("v1", ->
  ###############################
  # External Libraries
  ###############################
  require("../compiled/tests/support/factories/traitify_api_v1")
  require("../compiled/tests/support/mocks/traitify_mocks_v1")

  ###############################
  # Libraries
  ###############################
  require("../compiled/api/v1", cover: true)
  require("../compiled/ui/v1", cover: true)
  require("../compiled/builder/v1", cover: true)
  require("../compiled/widgets/slide-deck/v1", cover: true)
  require("../compiled/widgets/results/default/v1", cover: true)
  require("../compiled/widgets/results/personality-traits/v1", cover: true)
  require("../compiled/widgets/results/personality-types/v1", cover: true)
  require("../assets/widgets/slide-deck/v1", "css")

  ###############################
  # Tests
  ###############################
  require("../compiled/tests/v1/builder_spec")
  #require("../compiled/tests/v1/slide_deck_spec")
  require("../compiled/tests/v1/results_spec")
  require("../compiled/tests/v1/loader_spec")
  require("../compiled/tests/v1/results_traits_spec")
  require("../compiled/tests/v1/results_personality_types_spec")

  div(id: "test-case-container")
)


testSuite.add("api", ->
  ###############################
  # External Libraries
  ###############################

  require("../compiled/tests/support/factories/traitify_api_v1")
  require("../compiled/tests/support/mocks/traitify_mocks_v1")

  ###############################
  # Libraries To Test
  ###############################
  require("../compiled/api/master", cover: true)


  ###############################
  # Tests
  ###############################
  require("../compiled/tests/api/api_spec")
)

testSuite.run()