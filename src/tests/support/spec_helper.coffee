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

