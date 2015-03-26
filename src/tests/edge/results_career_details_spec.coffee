QUnit.module( "Testing Results Career Details", {
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

QUnit.asyncTest("Results Career Details", (assert)->
  unless document.querySelector(".careers")
    careers = document.createElement("div")
    careers.setAttribute("class", "careers")
    body.appendChild(careers)

  options = {
    careers: {
      target: ".careers",
      details: {
        show: true
      }
    }
  }

  builder = Traitify.ui.load(playedAssessment, ".widget", options)
  
  builder.careers.onInitialize(->
    clickEvent = document.createEvent("MouseEvent")
    clickEvent.initMouseEvent("click", true, true, window,
      0, 0, 0, 0, 0, false, false, false, false, 0, null)
    document.querySelector(".tf-career").dispatchEvent(clickEvent)

    assert.equal(!document.querySelector(".tf-popout-career"), false, "Career Details container exists")
    QUnit.start()
  )
)
