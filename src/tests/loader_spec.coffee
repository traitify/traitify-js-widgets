      
QUnit.asyncTest("Results Loader works", (assert)->
  builder = Traitify.ui.load("results", playedAssessment, ".widget")

  builder.onInitialize(->
    badge = document.querySelector(".badge")
    badge.innerHTML = ""
    assert.equal(badge.outerHTML, '<div class=\"badge\"></div>', "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results prints Styles", (assert)->
  Traitify.ui.styles = ""

  builder = Traitify.ui.load(playedAssessment, ".widget")
  builder.results.onInitialize(->
    badge = document.querySelector(".badge")
    badge.innerHTML = ""
    assert.equal(badge.outerHTML, '<div class=\"badge\"></div>', "Personality types container exists")
    QUnit.start()
  )
)

QUnit.asyncTest("Results Puts Traits in when the Traits callback is faster than the Types Callback", (assert)->
  
  unless document.querySelector(".personality-traits")
    personalityTraits = document.createElement("div")
    personalityTraits.setAttribute("class", "personality-traits")
    body.appendChild(personalityTraits)

  options = {
    personalityTraits: {
      target:".personality-traits"
    }
  }
  
  apiClient = new ApiClient()
  apiClient.publicKey = Traitify.publicKey
  apiClient.host = Traitify.host
  apiClient.XHR = MockRequest

  traitsFire = false
  Traitify.getPersonalityTraits = (args)->
    traitsFire = true
    apiClient.getPersonalityTraits(args)

  Traitify.getPersonalityTypes = (args)->
    new SimplePromise((resolve, reject)->
      waitUntil( -> traitsFire ).then(->
        resolve(apiFactory.build("personality", {number: 6}))
      )
    )
    
  builder = Traitify.ui.load(playedAssessment, ".widget", options)
  builder.Results.onInitialize(->
    badge = document.querySelector(".badge")
    badge.innerHTML = ""
    assert.equal(badge.outerHTML, '<div class=\"badge\"></div>', "Personality types container exists")
    QUnit.start()
  )
)

