window.Traitify.ui.simpleSlideDeck = (publicKey, assessmentId)->
    Traitify.setPublicKey(publicKey)
    Traitify.setHost("http://sandbox.traitify.com")
    Traitify.setVersion("v1")
    Traitify.ui.slideDeck(assessmentId)
