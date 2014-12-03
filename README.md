Traitify.js
===============

This package does not require jQuery, as it is a standalone encapsulated library. It does however require a browser with the ability to make cors requests (currently only supports ie8 and up, chrome, safari, and firefox).

### Assessment id and public key required!
For instructions on obtaining an assessment id and a public key visit:
[https://developer.traitify.com](https://developer.traitify.com)

### Using Traitify JS UI:
Include the Traitify.js library:

Stable Version:
```xhtml
<script src="https://cdn.traitify.com/lib/v1.js"></script>
```

You can initialize using an id or a class on any div tag:
```HTML
<div class="slide-deck"></div> <!-- Example Target Div for the widget -->
<div class="results"></div>
<div class="personality-types"></div>
<div class="personality-traits"></div>
```

The following javascript will initialize with the above html:
```HTML
<script>
    Traitify.setPublicKey("8asdf8sda-f98as-df8ads-fadsf"); // Example Public Key
    Traitify.setHost("api-sandbox.traitify.com"); // Example host url (Defaults to api.traitify.com)
    Traitify.setVersion("v1"); // Example Version
    var assessmentId = "34aeraw23-3a43a32-234a34as42"; // Example Assessment id

    traitify = Traitify.ui.load(assessmentId, ".slide-deck", {
        results: {target: ".results"},
        personalityTypes: {target: ".personality-types"},
        personalityTraits: {target: ".personality-traits"}
    }); // Example selector for widget target
</script>
```

The following javascript will initialize with the above html:
```HTML
<script>
    Traitify.setPublicKey("8asdf8sda-f98as-df8ads-fadsf"); // Example Public Key
    Traitify.setHost("api-sandbox.traitify.com"); // Example host url (Defaults to api.traitify.com)
    Traitify.setVersion("v1"); // Example Version
    var assessmentId = "34aeraw23-3a43a32-234a34as42"; // Example Assessment id

    traitify = Traitify.ui.load(assessmentId, ".slide-deck",{slideDeck: {showResults: false}})
</script>
```
When you initialize the widget we return our widget builder to you (This is the same builder we use to construct the widget).

```HTML
<script>
    traitify = Traitify.ui.load(assessmentId, ".traitify-widget", {
        results: {target: ".results"},
        personalityTypes: {target: ".personality-types"},
        personalityTraits: {target: ".personality-traits"}
    }); // Example selector for widget target
    
    // This callback gives you the ability to trigger an event when
    // the widget has finished loading
    traitify.slideDeck.onInitialize(function(){
        console.log(traitify.data.get("slides"));
        console.log("Initialized");
    })
    
    // This callback gives you the ability to trigger an event when
    // the user has finished playing the slide deck
    traitify.slideDeck.onFinished(function(){
        console.log(traitify.data.get("slides"));
        console.log("Finished!");
    })
</script>
```

When you initialize the widget we return our widget builder to you (This is the same builder we use to construct the widget).
```HTML
<script>
    // This callback gives you the ability to trigger an event when
    // the widget has finished loading
    traitify = Traitify.ui.load("slideDeck", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialize(function(){
        console.log(traitify.data.get("PersonalityTypes"));
        console.log("Initialized");
    })

    // This callback gives you the ability to trigger an event when
    // the widget has finished loading
    traitify = Traitify.ui.load("results", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialize(function(){
        console.log(traitify.data.get("PersonalityTypes"));
        console.log("Initialized");
    })


    // This callback gives you the ability to trigger an event when
    // the user has finished playing the slide deck    
    traitify = Traitify.ui.load("personalityTypes", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialized(function(){
        console.log(traitify.data.get("PersonalityTypes"));
        console.log("Finished!");
    })

    // This callback gives you the ability to trigger an event when
    // the user has finished playing the slide deck
    traitify = Traitify.ui.load("personalityTraits", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialized(function(){
        console.log(traitify.data.get("PersonalityTraits"));
        console.log("Finished!");
    })
</script>
```

### Using The Latest and Greatest(Edge)!
Edge Version:
```xhtml
<script src="https://cdn.traitify.com/lib/edge.js"></script>
```

### Contributing 
#### Building, Testing and Bundling:
```Shell
$ cake watch
$ cake build
$ cake bundle
$ cake test
```
