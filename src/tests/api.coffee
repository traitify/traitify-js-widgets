unPlayedAssessment = "8e5352e8-33d4-4085-ac05-c6314008164b"

QUnit.test( "API Client Set Host", (assert)->
  Traitify.setHost("hi")
  assert.equal( Traitify.host, "https://hi", "Setting Host Succeeds" )

  Traitify.setHost("https://new_hi")
  assert.equal( Traitify.host, "https://new_hi", "Setting Host with https Succeeds" )

  Traitify.setHost("http://new_hi_with_https")
  assert.equal( Traitify.host, "https://new_hi_with_https", "Setting Host with http is changed for https Succeeds" )
)

QUnit.test( "API Client Set Version", (assert)->
  Traitify.setVersion("v2")
  assert.equal( Traitify.version, "v2", "Setting Version" )
)

QUnit.test( "API Client Set Public Key", (assert)->
  Traitify.setPublicKey("here-is-the-key")
  assert.equal( Traitify.publicKey, "here-is-the-key", "Setting public key Succeeds" )
)

QUnit.asyncTest("API Client Get Slides", (assert)->
  Traitify.setVersion("v1")
  Traitify.setHost("api-sandbox.traitify.com")
  Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")
  Traitify.getSlides(unPlayedAssessment, (slides)->
    assert.equal( slides.length, 84, "Returns 84 slides" );
    assert.equal( slides[0].caption, "Navigating", "Returns 84 slides" );
    QUnit.start()
  )
)
  
QUnit.asyncTest("API Client Get Decks", (assert)->
  Traitify.setVersion("v1")
  Traitify.setHost("api-sandbox.traitify.com")
  Traitify.setPublicKey("gglvv58easpesg9ajbltavb3gr")
  Traitify.getDecks((decks)->
    assert.equal( decks[0].name, "Career Deck", "Returns 84 slides" )
    QUnit.start()
  )
)