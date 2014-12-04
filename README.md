### Definition of Terms
A widget is anything graphical element that is self contained, a widget builder is a library for that supports the self contained library (widget), and a slider is a deck of slides that is displayed in the user interface to gather personality information. By clicking me or not me per slide (Image with caption), the user is able to give the api feedback on particular elements of personality that traitify's psychology team has deamed valuable.


### How to include the js on your page
Stable Version:
```xhtml
<script src="https://cdn.traitify.com/lib/v1.js"></script>
```

### Basic setup for intilialization on page 
#### Assessment Id Required.  
To generate an Assessment Id use a server side library, for more information please visit [https://developer.traitify.com](https://developer.traitify.com)
```HTML
<script src="https://cdn.traitify.com/lib/v1.js"></script>

<div class="slide-deck your-class"></div> <!-- Example Target Div for the widget -->
<div class="results your-class"></div>
<div class="personality-types your-class"></div>
<div class="personality-traits your-class"></div>

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

### documentation on each widget (slider, blend, types, traits), what it is, when you use it, what it does, events you can capture (onFinished, onInitialized, etc)
If you choose to pass the widget you want to load at the beginning then the loader will return you that widget, otherwise it loads all widgets and passes you back all of them in an Object.
```HTML
<script>
     // This callback gives you the ability to trigger an event when
    // the widget has finished loading
    traitify = Traitify.ui.load("slideDeck", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialize(function(){
        console.log(traitify.data.get("Slides"));
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
    traitify.onInitialize(function(){
        console.log(traitify.data.get("PersonalityTypes"));
        console.log("Initialized!");
    })

    // This callback gives you the ability to trigger an event when
    // the user has finished playing the slide deck
    traitify = Traitify.ui.load("personalityTraits", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialize(function(){
        console.log(traitify.data.get("PersonalityTraits"));
        console.log("Initialized!");
    })
 </script>
 ```

 ### Examples of different use cases at the bottom

#### Standard Assessment and results
```HTML
<script src="https://cdn.traitify.com/lib/v1.js"></script>

<div class="slide-deck your-class"></div> <!-- Example Target Div for the widget -->
<div class="results your-class"></div>
<div class="personality-types your-class"></div>
<div class="personality-traits your-class"></div>

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
#### show an example of not rendering the results when the assessment is complete
 ```HTML
	<script>
	    Traitify.setPublicKey("8asdf8sda-f98as-df8ads-fadsf"); // Example Public Key
	    Traitify.setHost("api-sandbox.traitify.com"); // Example host url (Defaults to api.traitify.com)
	    Traitify.setVersion("v1"); // Example Version
	    var assessmentId = "34aeraw23-3a43a32-234a34as42"; // Example Assessment id

	    traitify = Traitify.ui.load(assessmentId, ".slide-deck",{slideDeck: {showResults: false}})
	    traitify.slideDeck.onFinished(function(){
	        alert("Finished")
	    })
	</script>
```

#### Callbacks (Events)
 ```HTML
	<script>
	    Traitify.setPublicKey("8asdf8sda-f98as-df8ads-fadsf"); // Example Public Key
	    Traitify.setHost("api-sandbox.traitify.com"); // Example host url (Defaults to api.traitify.com)
	    Traitify.setVersion("v1"); // Example Version
	    var assessmentId = "34aeraw23-3a43a32-234a34as42"; // Example Assessment id

	    traitify = Traitify.ui.load("slideDeck", assessmentId, ".slide-deck",{slideDeck: {showResults: false}})
	    traitify.onFinished(function(){
	        alert("Finished")
	    })
	   	traitify.onMe(function(){
	        alert("You clicked me!")
	    })
	    traitify.onNotMe(function(){
	        alert("You clicked not me!")
	    })
	   	traitify.onAdvanceSlide(function(){
	        alert("You clicked advance slide!")
	    })
	</script>
```
#### Triggering Me or Not Me with your own buttons
```HTML
	<div class="slide-deck"></div>
	<div class="yay-me">Yay Me!</div>
	<div class="yay-not-me">Yay Not Me!</div>
	<script>
	    Traitify.setPublicKey("8asdf8sda-f98as-df8ads-fadsf"); // Example Public Key
	    Traitify.setHost("api-sandbox.traitify.com"); // Example host url (Defaults to api.traitify.com)
	    Traitify.setVersion("v1"); // Example Version
	    var assessmentId = "34aeraw23-3a43a32-234a34as42"; // Example Assessment id

	    traitify = Traitify.ui.load("slideDeck", assessmentId, ".slide-deck",{slideDeck: {showResults: false}})

	    /********************************************
	     * Vanilla Javascript 
	     ********************************************/

		document.querySelector(".yay-me").onclick = function(){
			traitify.actions.trigger("me")	
		}

		document.querySelector(".yay-not-me").onclick = function(){
			traitify.actions.trigger("notMe")	
		}
		

		/********************************************
	     * jQuery
	     ********************************************/
		$(".yay-me").click(function(){
			traitify.actions.trigger("me")	
		})

		$(".yay-me").click(function(){
			traitify.actions.trigger("notMe")	
		})
```
#### Customization
You will notice that we added a class to your widgets called "your-class", we are going to use this class to scope our css therefore overriding the default widget css.


```HTML
<script src="https://cdn.traitify.com/lib/v1.js"></script>

<div class="slide-deck your-class"></div> <!-- Example Target Div for the widget -->
<div class="results your-class"></div>
<div class="personality-types your-class"></div>
<div class="personality-traits your-class"></div>

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

```HTML
<style>
    .your-class.tf-slide-deck-container .me{
        background-color: #aaa;
    }
</style>
```

Styling the Results
```HTML
<style>
    .your-class.tf-results .personality-type .name{
        background-color: #aaa;
    }
</style>
```

Styling the Personality Traits
```HTML
<style>
    .your-class.tf-personality-traits .personality-traits .trait .name{
        background-color: #aaa;
    }
</style>
```

Styling the Personality Types
```HTML
<style>
    .your-class.tf-personality-types .personality-types-container .personality-types{
        background-color: #aaa;
    }
</style>
```

##### Overriding the Slide Deck so that it doesn't even hit the Api!
```HTML
<script src="https://cdn.traitify.com/lib/v1.js"></script>
<div class="slide-deck"></div>
<script>
	slideDeck = Traitify.ui.widgets.slideDeck(assessmentId, currentTarget, options)
	slideDeck.data.add("Slides", [{caption:"Your Caption", image_desktop:"Your Image", id: "Your UUID"})
	slideDeck.actions.add("processSlide", function(data){alert("You Clicked " + data.caption)})
	slideDeck.run()
</script>
```
