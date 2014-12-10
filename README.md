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

![Widgets](https://s3.amazonaws.com/traitify-js-widgets-docs/images/me_not_me.png "Widgets")


### What Widgets are included
If you choose to pass the widget you want to load at the beginning then the loader will return you that widget, otherwise it loads all widgets and passes you back all of them in an Object.

We include three results widgets, and one slide deck widget. The slide deck allows the user to select me or not me to each image we present, giving us the information we need to generate a personality profile. The results widgets can then be used to render the personality profile, and include the user's traits, their personality type scores, and and their blend / highest personality type. They can each be rendered individually below (The slide deck will render all results at the end of the assessment unless you use the showResults: false argument read below for more details)

slideDeck
The slideDeck widget is a widget that is used to collect personality information by recording the user's me and not me of every slide in the assessment. This personality information is composed of traits, personality types, and in most cases a blend.

```HTML
<script>
     // This callback gives you the ability to trigger an event when
    // the widget has finished loading
    traitify = Traitify.ui.load("slideDeck", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialize(function(){
        console.log(traitify.data.get("Slides"));
        console.log("Initialized");
    })
</script>
```

Results
The results widget is the basic results widget, it displays your blend, a merge of your 2 top personality types, or if they are not capable of a merge, it shows your top personality type.

```HTML
<script>
    // This callback gives you the ability to trigger an event when
    // the widget has finished loading
    traitify = Traitify.ui.load("results", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialize(function(){
        console.log(traitify.data.get("PersonalityTypes"));
        console.log("Initialized");
    })
</script>
```


Personality Types
The personalityTypes widget displays personality type data, each personality type is a sumation of a particular set of personality traits recorded from the user's assessment.

![Widgets](https://s3.amazonaws.com/traitify-js-widgets-docs/images/results.png "Widgets")

```HTML
<script>
    // This callback gives you the ability to trigger an event when
    // the user has finished playing the slide deck    
    traitify = Traitify.ui.load("personalityTypes", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialize(function(){
        console.log(traitify.data.get("PersonalityTypes"));
        console.log("Initialized!");
    })
</script>
```

![Widgets](https://s3.amazonaws.com/traitify-js-widgets-docs/images/personality_types.png "Widgets")


Personality Traits
The personalityTraits widget displays personality trait data, each trait contains a value recorded from each slide played on the assessment, which allows for us to create personality type values and your blend, it also gives a more granular view of the user's personality.


```HTML
<script>
    // This callback gives you the ability to trigger an event when
    // the user has finished playing the slide deck
    traitify = Traitify.ui.load("personalityTraits", assessmentId, ".traitify-widget"); // Example selector for widget target
    traitify.onInitialize(function(){
        console.log(traitify.data.get("PersonalityTraits"));
        console.log("Initialized!");
    })
 </script>
 ```

![Widgets](https://s3.amazonaws.com/traitify-js-widgets-docs/images/personality_traits.png "Widgets")

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
#### Turning Off Results
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

Every tag added to the widget is recorded with a class, to find the class name use your inspector, often the css that styles a tag is scoped all the way from .tf-slide-deck to .me with all of the containers in between. If you add your own class to the root container though you can use the same scope with the addition of ".your-class" and you should be able to override different anything.
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

Styling the me Button
```HTML
<style>
    .your-class.tf-slide-deck-container .me{
        background-color: #aaa;
    }
</style>
```

![Widgets](https://s3.amazonaws.com/traitify-js-widgets-docs/images/me_grey.png "Widgets")



Styling the Results description
```HTML
<style>
    .your-class.tf-results .personality-type .description{
        font-size: 50px;
    }
</style>
```

![Widgets](https://s3.amazonaws.com/traitify-js-widgets-docs/images/personality_font_size.png "Widgets")

Styling the Personality Traits name
```HTML
<style>
    .your-class.tf-personality-traits .personality-traits .trait .name{
        font-size: 50px;
    }
</style>
```

![Widgets](https://s3.amazonaws.com/traitify-js-widgets-docs/images/traits_font_size.png "Widgets")

Styling the Personality Types background color
```HTML
<style>
    .your-class.tf-personality-types .personality-types-container{
    	background-color: #aaa;
    } 
    .your-class.tf-personality-types .personality-types-container .personality-types{
    	background-color: #aaa;
    } 
    .your-class.tf-personality-types .personality-types-container .personality-types .arrow .icon{
        background-color: #aaa;
        border-top: 20px solid #aaa;
    }
</style>
```

![Widgets](https://s3.amazonaws.com/traitify-js-widgets-docs/images/personality_types_background_grey.png "Widgets")


##### Overriding the Slide Deck so that it doesn't even hit the Api!
This can be used for testing purposes, or so that you can make all your api requests on your own server instead of using the client.
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

##Contributing
Please create a pull request for review if you wish to give back

Building, Testing and Bundling:
```Bash
$ cake watch
$ cake build
$ cake bundle
$ cake test
```
