###############################
# Preparation
###############################
link("./support/qunit-1.14.0.css")
div(id: "qunit")
div(id: "qunit-fixture")

testSuite.defaultSuite("master")

################################
# Global
################################
require("./support/qunit-1.14.0.js")
require("./support/blanket.min.js")
require("../compiled/tests/support/helpers.js")
require("../compiled/tests/support/mocker.js")
  

testSuite.add("master", ->
  ###############################
  # External Libraries
  ###############################
  require("../compiled/tests/support/factories_v1.js")
  require("../compiled/tests/support/mocks_v1.js")

  ###############################
  # Libraries To Test
  ###############################
  require("../compiled/api/master.js", cover: true)
  require("../compiled/builder/master.js", cover: true)
  require("../compiled/loader/master.js", cover: true)
  require("../compiled/widgets/slide_deck/master.js", cover: true)
  require("../compiled/widgets/results/default/master.js", cover: true)
  require("../compiled/templating/master.js", cover: true)


  ###############################
  # Tests
  ###############################
  require("../compiled/tests/builder/hildigrim-noakes.js")
  require("../compiled/tests/api.js")
  require("../compiled/tests/slide_deck.js")

  div(id: "test-case-container")
)


testSuite.add("api", ->
  ###############################
  # External Libraries
  ###############################

  require("../compiled/tests/support/factories_v1.js")
  require("../compiled/tests/support/mocks_v1.js")

  ###############################
  # Libraries To Test
  ###############################
  require("../compiled/api/master.js", cover: true)


  ###############################
  # Tests
  ###############################
  require("../compiled/tests/api.js")
)

testSuite.run()