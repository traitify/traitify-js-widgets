      
QUnit.asyncTest("Results Loader works", (assert)->
  builder = Traitify.ui.load("results", playedAssessment, ".widget")

  builder.onInitialize(->
    badge = document.querySelector(".widget .badges-container .badge")
    badge.innerHTML = ""
    assert.equal(badge.outerHTML, '<div class=\"badge\"></div>', "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results prints Styles", (assert)->
  Traitify.ui.styles = ""

  builder = Traitify.ui.load(playedAssessment, ".widget")
  builder.results.onInitialize(->
    badge = document.querySelector(".widget .badges-container .badge")
    badge.innerHTML = ""
    assert.equal(badge.outerHTML, '<div class=\"badge\"></div>', "Personality types container exists")
    QUnit.start()
  )
)

