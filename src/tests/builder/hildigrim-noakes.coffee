QUnit.module( "Testing Builder Version 2", {setup: ->
  @testDiv = document.createElement("div")
  @testDiv.className = "builder-test-initialization"
  testCaseContainer = document.querySelector("#test-case-container")
  testCaseContainer.innerHTML = ""
  testCaseContainer.appendChild(@testDiv)
  @widget = new Widget(".builder-test-initialization")
});
QUnit.test("Builder Version", (assert)->
  assert.equal(@widget.version, "2.0.0 HN", "passed!")
)
QUnit.test("Builder Main Node", (assert)->
  assert.equal(@widget.views.tags.library.get("main"), @testDiv, "passed!")
)
QUnit.test("Has View class Attached", (assert)->
  assert.equal(JSON.stringify(@widget.views), JSON.stringify(new Views()), "passed!")
)
QUnit.test("Has View class Library", (assert)->
  assert.equal(JSON.stringify(@widget.library), JSON.stringify(new Library()), "passed!")
)
QUnit.test("Tags addTag Works", (assert)->
  targetDiv = (new Tags()).div("awesome").outerHTML
  div = @widget.views.tags.div("awesome").outerHTML
  assert.equal(div, targetDiv, "passed!")
)
QUnit.test("Has Tags addTag works", (assert)->
  targetDiv = (new Tags()).div("awesome", {"data-awesome": "here"}).outerHTML
  div = @widget.views.tags.div("awesome", {"data-awesome": "here"}).outerHTML
  assert.equal(div, targetDiv, "passed!")
)
QUnit.test("Has Tags addTag works", (assert)->
  targetDiv = (new Tags()).div("awesome", "content").outerHTML
  div = @widget.views.tags.div("awesome", "inner content").outerHTML
  assert.equal(div, targetDiv, "passed!")
)
QUnit.test("Has Tags ", (assert)->
  div = @widget.views.tags.div("awesome").outerHTML
  assert.ok(div.indexOf('class="awesome"') != -1,"contains class")
)
QUnit.test("Has Tags addTag works", (assert)->
  div = @widget.views.tags.div("awesomeName").outerHTML
  assert.ok(div.indexOf('class="awesome-name"') != -1,"contains class")
)