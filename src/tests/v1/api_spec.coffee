QUnit.module( "Testing API Version 2", {setup: ->
  @Traitify = new ApiClient() 
  @Traitify.setVersion("v1")
  @Traitify.setHost("api-sandbox.traitify.com")
  @Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")
  @Traitify.XHR = MockRequest
});

QUnit.test( "API Client Set Host", (assert)->
  @Traitify.setHost("hi")
  assert.equal( @Traitify.host, "https://hi", "Setting Host Succeeds!" )

  @Traitify.setHost("https://new_hi")
  assert.equal( @Traitify.host, "https://new_hi", "Setting Host with https Succeeds!" )

  @Traitify.setHost("http://new_hi_with_https")
  assert.equal( @Traitify.host, "https://new_hi_with_https", "Setting Host with http is changed for https Succeeds!" )
)

QUnit.test( "API Client Set Version", (assert)->
  @Traitify.setVersion("v2")
  assert.equal( @Traitify.version, "v2", "Setting Version" )
)


QUnit.test( "API Client Set Public Key", (assert)->
  @Traitify.setPublicKey("here-is-the-key")
  assert.equal( @Traitify.publicKey, "here-is-the-key", "Setting public key Succeeds!" )
)

QUnit.test("API Client Get Slides", (assert)->
  @Traitify.getSlides(unPlayedAssessment, (slides)->
    assert.equal( slides.length, 84, "Returns 84 slides" )
    assert.equal( slides[0].caption, "Navigating", "Checking that The Caption of The First Slide Succeeds!" )
  )
)
  
QUnit.asyncTest("API Client Get Decks", (assert)->
  @Traitify.getDecks((decks)->
    assert.equal( decks[0].name, "Career Deck", "Checking that The First Deck Succeeds!" )
    QUnit.start()
  )
)

QUnit.test("API Client Add Slide", (assert)->
  @Traitify.addSlide(unPlayedAssessment, 0, true, 1000, (response)->
    assert.equal( response, "", "Checking that The First Deck Succeeds!" )
  )
)

QUnit.test("API Client Add Slides", (assert)->
  @Traitify.addSlides(unPlayedAssessment, [{id:0, response:true, response_time:1000}], (response)->
    assert.equal( response, "", "Checking that The First Deck Succeeds!" )
  )
)

QUnit.test("API Client Add Slides", (assert)->
  slides = @Traitify.addSlides(unPlayedAssessment, [{id:0, response:true, response_time:1000}])
  slides.then((response)->
    assert.equal(response, "", "Checking that The First Deck Succeeds!" )
  )
)

QUnit.test("Get Personality Types", (assert)->
  personalityTypes = @Traitify.getPersonalityTypes(playedAssessment)
  personalityTypes.then((response)->
    assert.equal(JSON.stringify(response), JSON.stringify(apiFactory.build("personality")), "Checking that The First Deck Succeeds!" )
  )
)

QUnit.test( "Test Beautify", (assert)->
  @Traitify.setBeautify(true)
  personalityTypes = @Traitify.getPersonalityTypes(playedAssessment)
  personalityTypes.then((response)->
    assert.ok(["personalityBlend", "personalityTypes"].indexOf(Object.keys(response)[0]) != -1, "Checking that The First Deck Succeeds!" )
  ) 
  @Traitify.setBeautify(false)
  personalityTypes = @Traitify.getPersonalityTypes(playedAssessment)
  personalityTypes.then((response)->
    assert.ok(["personality_blend", "personality_types"].indexOf(Object.keys(response)[0]) != -1, "Checking that The First Deck Succeeds!" )
    assert.ok(["personalityBlend", "personalityTypes"].indexOf(Object.keys(response)[0]) == -1, "Checking that The First Deck Succeeds!" )
  ) 
)

QUnit.test("Test Ajax XDomainRequest", (assert)->
  ieTraitify = new ApiClient()
  ieTraitify.XHR = MockIEXMLRequest
  window.XDomainRequest = MockRequest
  ieTraitify.setVersion("v1")
  ieTraitify.setHost("api-sandbox.traitify.com")
  ieTraitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")

  personalityTypes = ieTraitify.getPersonalityTypes(playedAssessment)
  personalityTypes.then((response)->
    assert.equal(JSON.stringify(response), JSON.stringify(apiFactory.build("personality")), "Checking that The First Deck Succeedss!" )
  )
)

QUnit.test("Test NO CORS SUPPORT", (assert)->
  ieTraitify = new ApiClient()
  ieTraitify.XHR = MockIEXMLRequest
  delete window["XDomainRequest"]
  ieTraitify.setVersion("v1")
  ieTraitify.setHost("api-sandbox.traitify.com")
  ieTraitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")
  personalityTypes = ieTraitify.getPersonalityTypes(playedAssessment)
  personalityTypes.catch((response)->
    assert.equal(response, "CORS is Not Supported By This Browser", "Checking that The First Deck Succeedss!" )
  )
)

QUnit.test("Test Errors", (assert)->
  errorTraitify = new ApiClient()
  errorTraitify.XHR = MockRequestWithError
  
  errorTraitify.setVersion("v1")
  errorTraitify.setHost("api.traitify.com")
  errorTraitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")
  personalityTypes = errorTraitify.getPersonalityTypes(playedAssessment)
  personalityTypes.catch((response)->
    assert.equal(response, "Mock Request Error", "Checking that The First Deck Succeedss!" )
  )
)

QUnit.test("Test Get Personality Traits", (assert)->
  personalityTypes = @Traitify.getPersonalityTraits(playedAssessment)
  personalityTypes.then((response)->
    assert.ok(response[0].personality_trait.definition, "Checking that The First Deck Succeedss!" )
  )
)