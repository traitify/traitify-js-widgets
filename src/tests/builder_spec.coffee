QUnit.module( "Testing Builder Version 2", {
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
    @widget = new Widget(".builder-test-initialization")

  , teardown: ->
    Traitify.XHR = XMLHttpRequest
})

QUnit.test("Builder Version", (assert)->
  assert.equal(@widget.version, "3.0.0 HNA", "passed!")
)

QUnit.test("Builder Main Node", (assert)->
  assert.equal(@widget.views.tags.library.get("main"), @testDiv, "passed!")
)

QUnit.test("Has View class Attached", (assert)->
  delete @widget.views.tags.library.store["main"]
  delete @widget.views.tags.library.store["main"]
  views = new Views()
  views.data = new Data()
  assert.equal(JSON.stringify(@widget.views), JSON.stringify(views), "passed!")
)

QUnit.test("Has View class Library", (assert)->
  assert.equal(JSON.stringify(@widget.library), JSON.stringify(new Library()), "passed!")
)

QUnit.test("Tags addTag Works", (assert)->
  div = (new Tags()).i("awesome2").outerHTML
  assert.equal(div, '<i class="awesome2"></i>', "i tag creates properly")
  @widget.views.tags.div("awesome")
  assert.equal(@widget.views.tags.get("awesome").outerHTML, '<div class="awesome"></div>', "passed!")
)

QUnit.test("Has Tags addTag works", (assert)->
  targetDiv = (new Tags()).div("awesome", {"data-awesome": "here"}).outerHTML
  div = @widget.views.tags.div("awesome", {"data-awesome": "here"}).outerHTML
  assert.equal(div, targetDiv, "passed!")
)

QUnit.test("Has Tags addTag works", (assert)->
  targetDiv = (new Tags()).div("awesome", "inner content").outerHTML
  div = @widget.views.tags.div("awesome", "inner content").outerHTML
  assert.equal(div, targetDiv, "passed!")
)

QUnit.test("Has Tags", (assert)->
  div = @widget.views.tags.div("awesome").outerHTML
  assert.ok(div.indexOf('class="awesome"') != -1,"contains class")
)

QUnit.test("Has Tags addTag works", (assert)->
  div = @widget.views.tags.div("awesomeName").outerHTML
  assert.ok(div.indexOf('class="awesome-name"') != -1,"contains class")
)

QUnit.test("callbacks work", (assert)->
  parent = new Widget("div")
  callbacks = new Callbacks(parent)
  callbacks.states.add("bandOfBrothers", false)
  callbacks.add("Awesome")
  parent.onAwesome(->
    callbacks.states.add("bandOfBrothers", true)
  )
  
  callbacks.trigger("Awesome")
  assert.ok(callbacks.states.get("bandOfBrothers"), "contains class")
)

QUnit.test("callbacks work", (assert)->
  parent = Object()
  callbacks = new Callbacks(parent)
  callbacks.states.add("bandOfBrothers", false)
  callbacks.add("Awesome")
  callbacks.trigger("Awesome")

  parent.onAwesome(->
    callbacks.states.add("bandOfBrothers", true)
  )
  assert.ok(callbacks.states.get("bandOfBrothers"),"contains class")
)

QUnit.test("Data works with storing and fetching", (assert)->
  data = new Data()
  expectedReturn = {awesome: "thing"}
  Traitify.getDecks = ()->
    new SimplePromise((resolve, reject)->
      resolve(expectedReturn)
    )
  data.add("awesome", Traitify.getDecks())

  data.get("awesome").then((localData)->
    assert.equal(JSON.stringify(data.get("awesome").data), JSON.stringify(expectedReturn), "fetches and stores data")
    assert.equal(JSON.stringify(localData), JSON.stringify(expectedReturn), "fetches and stores data")
  )
  expectedStoredReturn = {"expected Stored Return"}
)

QUnit.test("Data passes error on correctly", (assert)->
  data = new Data()
  expectedCatch = "My fake plants died because I did not pretend to water them."
  Traitify.getDecks = ()->
    new SimplePromise((resolve, reject)->
      reject(expectedCatch)
    )
  data.add("awesome", Traitify.getDecks())

  data.get("awesome").catch((localData)->
    assert.equal(JSON.stringify(localData), JSON.stringify(expectedCatch), "contains class")
  )
)

QUnit.test("Data works with storing and fetching", (assert)->
  data = new Data()
  data.add("blue", 0)
  assert.equal(data.get("blue"), 0, "store retreives data as 0")
  data.counter("blue").up()
  assert.equal(data.get("blue"), 1, "store retreives data as 1 with counter up()")
  data.counter("blue").up(2)
  assert.equal(data.get("blue"), 3, "store retreives data as 3 with counter up(2)")
  data.counter("blue").down()
  assert.equal(data.get("blue"), 2, "store retreives data as 2 with counter down()")
  data.counter("blue").down(3)
  assert.equal(data.get("blue"), -1, "store retreives data as -1 with counter down(3)")
)

QUnit.test("Data works with storing and fetching with persistence", (assert)->
  data = new Data()
  expectedReturn = {awesome: "thing"}
  data.persist("bats")
  data.add("bats", expectedReturn)
  delete data.store["bats"]
  if(navigator.userAgent.indexOf("PhantomJS") != -1) #TODO: Change this so the test isn't conditional
    assert.equal(JSON.parse(data.get("bats")).awesome, expectedReturn.awesome, "fetches and stores data in cookie")  
  else
    assert.equal(data.get("bats").awesome, expectedReturn.awesome, "fetches and stores data in cookie")  

  data = new Data()
  expectedReturn = {awesome: "thing"}
  data.persist("bats")
  data.set("bats", expectedReturn)
  delete data.store["bats"]
  if(navigator.userAgent.indexOf("PhantomJS") != -1) #TODO: Change this so the test isn't conditional
    assert.equal(JSON.parse(data.get("bats")).awesome, expectedReturn.awesome, "fetches and stores data in cookie")  
  else
    assert.equal(data.get("bats").awesome, expectedReturn.awesome, "fetches and stores data in cookie")  
)


QUnit.test("Cookies work with storing and fetching", (assert)->
  cookie = new Cookie()
  expectedReturn = {awesome: "thing"}  
  cookie.set("cookieStoreA", expectedReturn)
  if(navigator.userAgent.indexOf("PhantomJS") != -1) #TODO: Change this so the test isn't conditional
    assert.equal(JSON.parse(cookie.get("bats")).awesome, expectedReturn.awesome, "fetches and stores data in cookie")
  else
    assert.equal(cookie.get("bats").awesome, expectedReturn.awesome, "fetches and stores data in cookie")

  expectedReturnTwo = {awesome: "thingTwo"}

  cookie.set("cookieStoreB", expectedReturnTwo)
  if(navigator.userAgent.indexOf("PhantomJS") != -1) #TODO: Change this so the test isn't conditional
    assert.equal(JSON.parse(cookie.get("cookieStoreB")).awesome, expectedReturnTwo.awesome, "fetches and stores data in cookie")  
    assert.equal(JSON.parse(cookie.get("cookieStoreA")).awesome, expectedReturn.awesome, "fetches and stores data in cookie")  
  else
    assert.equal(cookie.get("cookieStoreB").awesome, expectedReturnTwo.awesome, "fetches and stores data in cookie")  
    assert.equal(cookie.get("bats").awesome, expectedReturn.awesome, "fetches and stores data in cookie")
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
  widget = new Widget(".builder-test-initialization")
  contentToRender = "Here it is!"
  widget.views.add("awesome", (plusExtraData)->
    contentToRender + plusExtraData
  )
  assert.equal(widget.views.render("awesome", "there"), contentToRender + "there", "rendering works")
)

QUnit.test("Helpers hexToRGB", (assert)->
  helpers = new Helpers
  rgb = helpers.hexToRGB("a77899")
  rgbShouldValue = [167, 120, 153]
  assert.equal(JSON.stringify(rgb), JSON.stringify(rgbShouldValue), " converts Hex Number Properly")
)

QUnit.test("Helpers", (assert)->
  helpers = new Helpers
  helpers.add("stuff", (name)->
    "#{name} Can Do Stuff"
  )
  assert.equal(helpers.stuff("Carson"), "Carson Can Do Stuff", " can add Helper")
)

QUnit.test("Create image", (assert)->
  view = new Views
  img = view.tags.img("awesome", "#test.jpg")
  shouldImg = document.createElement("img")
  shouldImg.setAttribute("src", "#test.jpg")
  shouldImg.setAttribute("class", "awesome")
  assert.equal(img.outerHTML, shouldImg.outerHTML, "Image can be created")
)

QUnit.test("Create image with Data Attribute", (assert)->
  view = new Views
  img = view.tags.img("awesome", "#test.jpg", {"data-test":"there"})
  assert.equal(img.outerHTML, '<img data-test="there" src="#test.jpg" class="awesome">', "create image with data attribute")
)

QUnit.test("Create Tag Set with scope", (assert)->
  view = new Views
  img = view.tags.img(["thing.awesome"], "#test.jpg", {"data-test":"there"})
  assert.equal(img.outerHTML, '<img data-test="there" src="#test.jpg" class="awesome">', "Create Tag set with Scope")
)

QUnit.test("Create Tag Set with a style", (assert)->
  view = new Views
  img = view.tags.img("font.awesome", "#test.jpg", {style: {fontColor: "blue"}})

  assert.equal(img.style.fontColor, 'blue', "Create Tag With style")
)

QUnit.test("Create Tag And Append To another Tag", (assert)->
  view = new Views
  div = view.tags.div("imgContainer")
  img = view.tags.img("awesome", "#test.jpg", {style: {fontColor: "blue"}}).appendTo("imgContainer")

  assert.equal(div.innerHTML, img.outerHTML, "Append Tag to another Tag")
)

QUnit.test("Create Tag and Append it to one tag of a tag Set", (assert)->
  view = new Views
  container = view.tags.div(["awesomeContainer"])
  img = view.tags.img(["thing.awesome"], "#test.jpg", {"data-test":"there"}).appendTo(["awesomeContainer", 0])
  assert.equal(container.innerHTML, img.outerHTML, "append to set")
)

QUnit.test("Initialization items can be added and run", (assert)->
  testCase = false

  @widget.initialization.events.add("Test Case Should Be True", ->
    testCase = true
  )
  @widget.run()
  assert.ok(testCase, "initializes properly")
)

QUnit.test("Initialization items can be added and run Individualy", (assert)->
  testCase = false
  initialization = new Stack
  initialization.events.add("Individual Test Case Should Also Be True", ->
    testCase = true
  )

  initialization.trigger("Individual Test Case Should Also Be True")

  assert.ok(testCase, "initializes properly")
)

QUnit.test("Actions can be added and triggered at will", (assert)->
  clickMe = false
  actions = new Actions
  actions.add("clickMe", ->
    clickMe = true
  )
  actions.trigger("clickMe")
  assert.ok(clickMe, "trigger functions")
)

QUnit.test("States should be able to be Set with set not just Add", (assert)->
  states = new States
  states.set("awesome", true)
  
  assert.ok(states.get("awesome"), "Set works as expected")
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
