QUnit.module( "Testing Builder Version 2", {setup: ->
  @testDiv = document.createElement("div")
  @testDiv.className = "builder-test-initialization"
  testCaseContainer = document.querySelector("#test-case-container")
  testCaseContainer.innerHTML = ""
  testCaseContainer.appendChild(@testDiv)
  @widget = new Widget(".builder-test-initialization")
  Traitify = new ApiClient() 
, teardown: ->
  Traitify = new ApiClient() 
})
QUnit.test("Builder Version", (assert)->
  assert.equal(@widget.version, "2.0.0 HN", "passed!")
)
QUnit.test("Builder Main Node", (assert)->
  assert.equal(@widget.views.tags.library.get("main"), @testDiv, "passed!")
)
QUnit.test("Has View class Attached", (assert)->
  delete @widget.views.tags.library.store["main"] 
  
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


QUnit.test("callbacks work", (assert)->

  callbacks = new Callbacks()
  callbacks.states.add("bandOfBrothers", false)
  callbacks.add("Awesome")
  callbacks.onAwesome(->
    callbacks.states.add("bandOfBrothers", true)
  )
  callbacks.trigger("Awesome")
  assert.ok(callbacks.states.get("bandOfBrothers"),"contains class")
)

QUnit.test("callbacks work", (assert)->
  callbacks = new Callbacks()
  callbacks.states.add("bandOfBrothers", false)
  callbacks.add("Awesome")
  callbacks.trigger("Awesome")
  callbacks.onAwesome(->
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
  data.sources.add("awesome", Traitify.getDecks())

  data.sources.fetch("awesome").then((localData)->
    assert.equal(JSON.stringify(data.sources.data.get("awesome")), JSON.stringify(expectedReturn), "fetches and stores data")
    assert.equal(JSON.stringify(localData), JSON.stringify(expectedReturn), "fetches and stores data")
  )
  expectedStoredReturn = {"expected Stored Return"}

  data.sources.data.add("awesome", expectedStoredReturn)
  data.sources.fetch("awesome").then((localData)->
    assert.equal(JSON.stringify(localData), JSON.stringify(expectedStoredReturn), "returns stored data")
  )
)
QUnit.test("Data passes error on correctly", (assert)->
  data = new Data()
  expectedCatch = "My fake plants died because I did not pretend to water them."
  Traitify.getDecks = ()->
    new SimplePromise((resolve, reject)->
      reject(expectedCatch)
    )
  data.sources.add("awesome", Traitify.getDecks())

  data.sources.fetch("awesome").catch((localData)->
    assert.equal(JSON.stringify(localData), JSON.stringify(expectedCatch), "contains class")
  )
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