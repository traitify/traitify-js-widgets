widget = Object()
QUnit.module( "Testing API Version 1", { setup: ->
  Traitify.setVersion("v1")
  Traitify.setHost("api-sandbox.traitify.com")
  Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

  document.getElementsByClassName("widget")[0].innerHTML = ""
  widget = document.getElementsByClassName("widget")[0]
  unless widget
    widget = document.createElement("div")
    body = document.getElementsByTagName("body")[0]
    body.appendChild(widget)

  widget.innerHTML = '
  <template name="tf-personality-types" assessment-id="played">
      <name></name>
  </template>'

});
QUnit.asyncTest("Slide Deck Widget Initialize", (assert)->
  Traitify.templating.initialize()
  Traitify.templating.onInitialize(->
      assert.equal(!document.getElementsByClassName("widget")[0], false, "template exists")
      assert.equal(document.getElementsByTagName("name")[0].innerHTML, "Navigating", "template exists")
      QUnit.start()
  )
 )
