Traitify.js
===============

This package does not require jQuery, as it is a standalone encapsulated library. It does however require a browser with the ability to make cors requests (currently only supports ie10 and up, chrome, safari, and firefox).

### Assessment id and public key required!
For instructions on obtaining an assessment id and a public key visit:
[https://developer.traitify.com](https://developer.traitify.com)

### Using Traitify JS UI:
Include the Traitify.js library:

```xhtml
<script src="https://cdn.traitify.com/js/api/1.0.0.js"></script>
<script src="https://cdn.traitify.com/js/widgets/slide_deck/2.0.0.js"></script>
```

You can initialize using an id or a class on any div tag:
```HTML
<div class="traitify-widget"></div> <!-- Example Target Div for the widget -->
```

The following javascript will initialize with the above html:
```HTML
<script>
    Traitify.setPublicKey("8asdf8sda-f98as-df8ads-fadsf"); // Example Public Key
    Traitify.setHost("api-sandbox.traitify.com"); // Example host url (Defaults to api.traitify.com)
    Traitify.setVersion("v1"); // Example Version
    var assessmentId = "34aeraw23-3a43a32-234a34as42"; // Example Assessment id

    traitify = Traitify.ui.slideDeck(assessmentId, ".traitify-widget") // Example selector for widget target
</script>
```

When you initialize the widget we return our widget builder to you (This is the same builder we use to construct the widget).
```HTML
<script>

    traitify = Traitify.ui.slideDeck(assessmentId, ".traitify-widget")
    
    // This callback gives you the ability to trigger an event when
    // the widget has finished loading
    traitify.onInitialize(function(){
        console.log(traitify.data);
        console.log("Initialized");
    })
    
    // This callback gives you the ability to trigger an event when
    // the user has finished playing the slide deck
    traitify.onFinished(function(){
        console.log(traitify.data);
        console.log("Finished!");
    })
</script>
```
===============
### Using Traitify JS API CLIENT:
```xhtml
<script src="https://cdn.traitify.com/js/api/1.0.0.js"></script>
```

##### Get Decks
```JavaScript
Traitify.getDecks("assessment id", function(data){
  console.log(data)
})
```

##### Get Slides
```JavaScript
Traitify.getSlides("assessment id", function(data){
  console.log(data)
})
```

##### Get Personality Traits
```JavaScript
Traitify.addSlide("assessment id", function(data){
    console.log(data)
})
```

##### Get Personality Traits
```JavaScript
Traitify.getPersonalityTraits("assessment id", function(data){
    console.log(data)
})
```

### Contributing 
#### Building, Testing and Bundling:
```Shell
$ cake watch
$ cake build
$ cake bundle
$ cake test
```
