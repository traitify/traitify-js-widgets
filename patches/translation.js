/*
 * Paste this in a file and source it after the traitify js library
 *
 * This is an example of a partial translation of the Core Deck. Ids are used 
 * where possible to make sure that if any data changes in the api the client 
 * still functions properly
 */
Traitify.translations = {
  slides:{
    "56e3d769-e90b-4e80-bc36-69f4aec89fbc":{ // the id of the slide you want to change
      caption: "Not Drawing"
    },
    "7d50f7b2-ed53-44de-a94f-912ab0e2cc43":{ // the id of the slide you want to change
      caption: "Not Non-Profit Organization"
    }
  },
  personalityTypes:{
    "9b7daca3-5725-45dd-97d8-006d4e1953cf":{ // the id of the personality type you want to change
      name: "Not Adventurous",
      description: "This is not the Adventurous description"
    },
    "4e8d31a3-16d9-4a10-93fd-16094f3ee303":{
      name: "Not Charismatic",
      description: "This is not the Charismatic description"
    }
  },
  personalityTraits:{
    "Empathic":{ // This time use the trait name as the key
      name: "Not Empathic",
      definition: "This trait is not really the Empathic trait"
    }
  },
  personalityBlends:{
    "9b7daca3-5725-45dd-97d8-006d4e1953cf/4e8d31a3-16d9-4a10-93fd-16094f3ee303":{
      name: "Not Adventurous/Not Charismatic",
      description: "This is not the Charismatic/Adventurous Blend description"
    }
  }
}


/**********************************************
 * PATCH 
 * Don't worry about what this does it just patches the functionality
 *
 * Just make sure that its pasted after your Traitify.translations Variable
 **********************************************/
Traitify.getOriginalSlides = Traitify.getSlides;
Traitify.getSlides = function(options){
  that = this;
  promise = SimplePromise(function(accept, reject){
    that.getOriginalSlides(options).then(function(data){
      slides = data.map(function(slide, index){
        if(that.translations.slides[slide.id]){
          slide.caption = that.translations.slides[slide.id].caption;
        }
        return slide;
      })
      accept(slides)
    })
  })
 return promise;
}

Traitify.getOriginalPersonalityTypes = Traitify.getPersonalityTypes;
Traitify.getPersonalityTypes = function(options){
  that = this;
  promise = SimplePromise(function(accept, reject){
    that.getOriginalPersonalityTypes(options).then(function(data){
      originalData = JSON.parse(JSON.stringify(data)); // Duplicate JSON
      data.personality_types = data.personality_types.map(function(personalityType, index){
        pt = personalityType.personality_type;
        if(that.translations.personalityTypes[pt.id]){
          pt.name = that.translations.personalityTypes[pt.id].name;
          pt.description = that.translations.personalityTypes[pt.id].description;
          personalityType.personality_type = pt;
        }
        return personalityType;
      })
      blend = data.personality_blend;
      if(blend.name){
        names = blend.name.split("/");
        blendTypes = [
          originalData.personality_types.filter(function(personality_type){
            return personality_type.personality_type.name == names[0];
          })[0],
          originalData.personality_types.filter(function(personality_type){
            return personality_type.personality_type.name == names[1];
          })[0]
        ]
        ids = blendTypes.map(function(a){ return a.personality_type.id });
        blend = that.translations.personalityBlends[ids.join("/")];
        if(blend){
          data.personality_blend.name = blend.name;
          data.personality_blend.description = blend.description;
        }
      }
      accept(data)
    })
  })
 return promise;
}

Traitify.getOriginalPersonalityTraits = Traitify.getPersonalityTraits;
Traitify.getPersonalityTraits = function(options){
  that = this;
  promise = SimplePromise(function(accept, reject){
    that.getOriginalPersonalityTraits(options).then(function(data){
      personalityTraits = data.map(function(personalityTrait, index){
        pt = personalityTrait.personality_trait;
        if(that.translations.personalityTraits[pt.name]){
          temp = {
            name: that.translations.personalityTraits[pt.name].name,
            definition: that.translations.personalityTraits[pt.name].definition
          }
          pt.name = temp.name
          pt.definition = temp.definition
          personalityTrait.personality_trait = pt;
        }
        return personalityTrait;
      })
      accept(personalityTraits);
    })
  })
 return promise;
}
