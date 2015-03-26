QUnit.module( "Testing Results Careers", {
  setup: ->
    Traitify.XHR = MockRequest
    Traitify.setVersion("v1")
    Traitify.setHost("api-sandbox.traitify.com")
    Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

    unless document.querySelector(".widget")
      widget = document.createElement("div")
      widget.setAttribute("class", "widget")
      body.appendChild(widget)
    document.getElementsByClassName("widget")[0].innerHTML = ""
  ,
  teardown: ->
    Traitify.XHR = XMLHttpRequest
})

QUnit.asyncTest("Results Careers Widget Appears with load('careers'...)", (assert)->
  careers = Traitify.ui.load("careers", playedAssessment, ".widget")

  careers.onInitialize(->
    careers = document.querySelector(".tf-careers")
    assert.ok(careers, "Careers container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results Careers", (assert)->
  unless document.querySelector(".careers")
    careers = document.createElement("div")
    careers.setAttribute("class", "careers")
    body.appendChild(careers)

  options = {
    careers: {
      target: ".careers"
    }
  }

  builder = Traitify.ui.load(playedAssessment, ".widget", options)

  builder.careers.onInitialize(->
    assert.equal(!document.querySelector(".tf-careers"), false, "Career container exists")
    QUnit.start()
  )
)
