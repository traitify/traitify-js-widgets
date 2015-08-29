/*
 * Paste this in a file and source it after the traitify js library
 *
 * Fill out this content reflect your needs, POSITION IS IMPORTANT
 * Make the position be where you want the slide to be inserted
 */

Traitify.translations = {
  slides:{
    "eed19717-2014-48ec-b520-bb71f96ebc78":{ // the id of the slide you want to change
      caption: "Support the military"
    },
    "eyp19717-2004-48ec-b5o0-bb71f96ebc56":{ // the id of the slide you want to change
      caption: "Hola"
    }
  }
  personalityTypes:{
    "eod19717-2014-48ec-beuo-bb71f83eb8oe":{
      name: "heya",
      description: "hehyhoeu"
    }
  }
  personalityTraits:{
    "Whimsical":{ // This time use the trait name as the key
      name: "Not Whimsical",
      definition: "This trait is not really Whimsical"
    }
  }

}


/**********************************************
 * PATCH 
 * Don't worry about this it just patches the functionality
 **********************************************/
Traitify.getOriginalSlides = Traitify.getSlides;
Traitify.getSlides = function(options){
  that = this;
  promise = SimplePromise(function(accept, reject){
    that.getOriginalSlides(options).then(function(data){
      slides = data.map(function(index, slide){
        slide.caption = that.translations.slides[slide.id].caption
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
      data.personality_types = data.personality_types.map(function(index, personalityType){
        pt = personalityType.personality_type;
        pt.name = that.translations.personalityTypes[pt.id].name;
        pt.description = that.translations.personalityTypes[pt.id].description
        personalityType.personality_type = pt;
        return personalityType;
      })

      blend = data.personality_blend
      blend.personality_type_1.name = that.translations.personalityTypes[blend.personality_type_1.id].name
      blend.personality_type_1.description = that.translations.personalityTypes[blend.personality_type_1.id].description

      blend.personality_type_2.name = that.translations.personalityTypes[blend.personality_type_2.id].name
      blend.personality_type_2.description = that.translations.personalityTypes[blend.personality_type_2.id].description
      data.personality_blend = blend;
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
      personalityTraits = data.map(function(index, personalityTrait){
        pt = personalityTrait.personality_trait;
        pt.name = that.translations.personalityTraits[pt.name].name;
        pt.definition = that.translations.personalityTraits[pt.name].definition;
        presonalityTrait.personality_trait = pt;
        return personalityTrait;
      })
      accept(personalityTypes);
    })
  })
 return promise;
}
