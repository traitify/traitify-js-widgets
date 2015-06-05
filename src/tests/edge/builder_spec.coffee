QUnit.module( "Testing Builder", {
  setup: ->
    Traitify.XHR = MockRequest
    Traitify.setVersion("v1")
    Traitify.setHost("api-sandbox.traitify.com")
    Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

    @testDiv = document.createElement("div")
    @testDiv.className = "builder-test-initialization"
    testCaseContainer = document.querySelector("#test-case-container")
    testCaseContainer.innerHTML = ""

    testCaseContainer.appendChild(@testDiv)
    @widget = new TFWidget(".builder-test-initialization")

  , teardown: ->
    Traitify.XHR = XMLHttpRequest
})

QUnit.test("Builder Version", (assert)->
  assert.equal(@widget.version, "3.0.0 HNA", "passed!")
)

QUnit.test("Builder Main Node", (assert)->
  assert.equal(@widget.views.tags.library.get("main"), @testDiv, "passed!")
)




QUnit.test("Has Tags", (assert)->
  div = @widget.views.tags.div("awesome").outerHTML
  assert.ok(div.indexOf('class="awesome"') != -1,"contains class")
)

QUnit.test("Has Tags addTag works", (assert)->
  div = @widget.views.tags.div("awesomeName").outerHTML
  assert.ok(div.indexOf('class="awesome-name"') != -1,"contains class")
)

QUnit.test("Promises then works whether the Promise finishes first or not", (assert)->
  promisedData = {here: "there"}
  simplePromiseOne = new SimplePromise((resolve, reject)->
    resolverOne = resolve(promisedData)
  )
  simplePromiseOne.then((data)->
    assert.equal(JSON.stringify(data), JSON.stringify(promisedData), "contains class")
  )
  resolverTwo = null
  simplePromiseTwo = new SimplePromise((resolve, reject)->
    resolverTwo = resolve
  )
  simplePromiseTwo.then((data)->
    assert.equal(JSON.stringify(data), JSON.stringify(promisedData), "contains class")
  )
  resolverTwo(promisedData)
)

QUnit.test("Promises catch works whether the Promise errors first or not", (assert)->
  promisedData = {here: "there"}
  simplePromiseOne = new SimplePromise((resolve, reject)->
    reject(promisedData)
  )
  simplePromiseOne.catch((data)->
    assert.equal(JSON.stringify(data), JSON.stringify(promisedData), "contains class")
  )

  rejectorTwo = null
  simplePromiseTwo = new SimplePromise((resolve, reject)->
    rejectorTwo = reject
  )

  simplePromiseTwo.catch((data)->
    assert.equal(JSON.stringify(data), JSON.stringify(promisedData), "contains class")
  )
  rejectorTwo(promisedData)
)

QUnit.test("Check that the widget can render", (assert)->
  widget = new TFWidget(".builder-test-initialization")
  contentToRender = "Here it is!"
  widget.views.add("awesome", (plusExtraData)->
    contentToRender + plusExtraData
  )
  assert.equal(widget.views.render("awesome", "there"), contentToRender + "there", "rendering works")
)

QUnit.test("Initialization items can be added and run", (assert)->
  testCase = false

  @widget.initialization.events.add("Test Case Should Be True", ->
    testCase = true
  )
  @widget.run()
  assert.ok(testCase, "initializes properly")
)

QUnit.test("Can get Nodes", (assert)->
  main = document.querySelector(".builder-test-initialization")

  assert.equal(@widget.nodes.get()["main"], main, "Can get all nodes and compare")
  assert.equal(@widget.nodes.get("main"), main, "Can get single node and compare")
)

QUnit.test("Builder with Iphone Device and Ipad Device initialize correctly", (assert)->

  oldUserAgent = Traitify.ui.userAgent.toString()

  Traitify.ui.userAgent = "iPhone"
  results = Traitify.ui.load("results", playedAssessment, ".builder-test-initialization")
  assert.equal(results.device, "iphone", "Can get all nodes and compare")

  Traitify.ui.userAgent = "iPad"
  results = Traitify.ui.load("results", playedAssessment, ".builder-test-initialization")
  assert.equal(results.device, "ipad", "Can get all nodes and compare")

  Traitify.ui.userAgent = "Android"
  results = Traitify.ui.load("results", playedAssessment, ".builder-test-initialization")
  assert.equal(results.device, "android", "Can get all nodes and compare")

  Traitify.ui.userAgent = "Blackberry"
  results = Traitify.ui.load("results", playedAssessment, ".builder-test-initialization")
  assert.equal(results.device, "blackberry", "Can get all nodes and compare")

  Traitify.ui.userAgent = "webOS"
  results = Traitify.ui.load("results", playedAssessment, ".builder-test-initialization")
  assert.equal(results.device, "webos", "Can get all nodes and compare")

  Traitify.ui.userAgent = oldUserAgent
)
