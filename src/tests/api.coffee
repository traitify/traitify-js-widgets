unPlayedAssessment = "unplayed"
unPlayedAssessment = "played"



QUnit.test( "API Client Set Host", (assert)->
  Traitify.setHost("hi")
  assert.equal( Traitify.host, "https://hi", "Setting Host Succeeds!" )

  Traitify.setHost("https://new_hi")
  assert.equal( Traitify.host, "https://new_hi", "Setting Host with https Succeeds!" )

  Traitify.setHost("http://new_hi_with_https")
  assert.equal( Traitify.host, "https://new_hi_with_https", "Setting Host with http is changed for https Succeeds!" )
)

QUnit.test( "API Client Set Version", (assert)->
  Traitify.setVersion("v2")
  assert.equal( Traitify.version, "v2", "Setting Version" )
)

QUnit.test( "API Client Set Public Key", (assert)->
  Traitify.setPublicKey("here-is-the-key")
  assert.equal( Traitify.publicKey, "here-is-the-key", "Setting public key Succeeds!" )
)

QUnit.module( "Testing API Version 1", { setup: ->
  Traitify.setVersion("v1")
  Traitify.setHost("api-sandbox.traitify.com")
  Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")
});

QUnit.test("API Client Get Slides", (assert)->
  Traitify.getSlides(unPlayedAssessment, (slides)->
    assert.equal( slides.length, 84, "Returns 84 slides" )
    assert.equal( slides[0].caption, "Navigating", "Checking that The Caption of The First Slide Succeeds!" )
  )
)
  
QUnit.test("API Client Get Decks", (assert)->
  Traitify.getDecks((decks)->
    assert.equal( decks[0].name, "Career Deck", "Checking that The First Deck Succeeds!" )
  )
)

QUnit.test("API Client Add Slide", (assert)->
  Traitify.addSlide(unPlayedAssessment, 0, true, 1000, (response)->
    assert.equal( response, "", "Checking that The First Deck Succeeds!" )
  )
)

QUnit.test("API Client Add Slides", (assert)->
  Traitify.addSlides(unPlayedAssessment, [{id:0, response:true, response_time:1000}], (response)->
    assert.equal( response, "", "Checking that The First Deck Succeeds!" )
  )
)