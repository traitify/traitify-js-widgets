// Generated by CoffeeScript 1.7.1
window.Traitify.ui.slideDeck = function(assessmentId, selector, slideDeckCallBack) {
  var Actions, classes, data, div, fetch, html, image, ipad, link, media, orientation, partial, partials, phoneSetup, slideDeck, slideLock, style, styles, styling, tag;
  slideLock = false;
  orientation = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
  ipad = /iPad/.test(navigator.userAgent);
  slideDeck = Object();
  if (!this.host) {
    this.host = "https://api-staging.traitify.com";
  }

  /*
  HELPERS
   */
  tag = function(type, attributes, content) {
    var key, preparedAttributes, value;
    preparedAttributes = Array();
    for (key in attributes) {
      value = attributes[key];
      preparedAttributes.push(key + "=\"" + value + "\"");
    }
    attributes = attributes || Array();
    if (content === false) {
      return "<" + type + " " + preparedAttributes.join(" ") + " />";
    } else {
      return "<" + type + " " + preparedAttributes.join(" ") + ">\n" + content + "\n</" + type + ">";
    }
  };
  div = function(attributes, content) {
    return tag("div", attributes, content);
  };
  image = function(src, attributes) {
    attributes["src"] = src;
    return tag("img", attributes, false);
  };
  link = function(href, attributes, content) {
    attributes["href"] = href;
    return tag("a", attributes, content);
  };
  style = function(content) {
    return tag("style", {}, content);
  };
  styling = function(selector, content) {
    var formattedContent, key;
    formattedContent = Array();
    for (key in content) {
      formattedContent.push(key + ":" + content[key] + ";");
    }
    if (selector.indexOf('&') !== -1) {
      selector = slideDeck.classes() + selector.replace("&", "");
    } else {
      selector = slideDeck.classes() + " " + selector;
    }
    return selector + "{\n" + formattedContent.join("\n") + "}";
  };
  media = function(arg, content) {
    var i;
    for (i in arg) {
      arg = i + ":" + arg[i];
    }
    return "@media screen and (" + arg + ")";
  };
  fetch = function(className) {
    return slideDeck.element.getElementsByClassName(className);
  };

  /*
  MAIN
   */

  /*
  Styles
   */
  styles = function() {
    var slideHeight;
    slideHeight = orientation ? "40em" : "22.5em";
    styles = Array();
    styles.push(styling("", {
      "font-family": '"Helvetica Neue", Helvetica,Arial, sans-serif',
      "text-align": "center",
      "margin": "1em"
    }));
    styles.push(styling(".slide-deck", {
      "text-align": "center",
      "margin": "0px auto",
      "display": "inline-block",
      "background-color": "transparent",
      "min-width": "40em"
    }));
    styles.push(styling(".slide .image", {
      width: "40em",
      height: slideHeight,
      "line-height": "1em"
    }));
    styles.push(styling(".slide .caption", {
      "text-align": "center",
      "background-color": "#1b1b1b",
      color: "#fff",
      padding: ".8em 0px"
    }));
    styles.push(styling(".slide", {
      display: "inline-block"
    }));
    styles.push(styling(".slide-container", {
      width: "40em",
      overflow: "hidden",
      position: "relative",
      display: "inline-block",
      "vertical-align": "middle",
      "float": "left"
    }));
    styles.push(styling(".me, .not-me", {
      width: "50%",
      display: "inline-block",
      padding: "1em 0em",
      "text-align": "center",
      color: "#fff",
      "text-decoration": "none"
    }));
    styles.push(styling(".me:hover, .not-me:hover", {
      "text-decoration": "none",
      color: "#fff"
    }));
    styles.push(styling(".me", {
      "background-color": "#3f6fef"
    }));
    styles.push(styling(".not-me", {
      "background-color": "#ef3f2f"
    }));
    styles.push(styling(".slides", {
      display: "inline-block",
      "text-align": "left",
      width: (slideDeck.fetch("slide").length * 40) + "em"
    }));
    styles.push(styling(".progress-bar", {
      "height": ".5em",
      "width": "40em",
      "font-size": "inherit",
      "display": "inline-block",
      "background-color": "#f0f0f0",
      "overflow": "hidden",
      "text-align": "left",
      "transition": "none",
      "-webkit-transition": "none"
    }));
    styles.push(styling(".inner-progress-bar", {
      "height": ".5em",
      "width": "0%",
      "display": "inline-block",
      "background-color": "#888",
      "float": "left"
    }));
    styles.push(styling(".me.side", {
      "position": "relative",
      "width": "3.6em",
      "height": "16.1em",
      "float": "left",
      "margin-top": ".4em",
      "display": "none"
    }));
    styles.push(styling(".not-me.side", {
      "position": "relati ve",
      "width": "3.6em",
      "height": "16.1em",
      "float": "left",
      "margin-top": ".4em",
      "display": "none",
      "text-align": "center"
    }));
    styles.push(styling(".me.side .text", {
      "margin-top": "6em"
    }));
    styles.push(styling(".not-me.side .text", {
      "margin-top": "5.7em"
    }));
    styles.push(styling("&.phone .me.bottom", {
      "display": "inline-block"
    }));
    styles.push(styling("&.phone .not-me.bottom", {
      "display": "inline-block"
    }));
    styles.push(styling("&.phone .me.side", {
      "display": "none"
    }));
    styles.push(styling("&.phone .not-me.side", {
      "display": "none"
    }));
    styles.push(styling("&.phone .slide .caption", {
      "font-size": "1.6em"
    }));
    styles.push(styling("&.phone .me.bottom", {
      "font-size": "1.6em"
    }));
    styles.push(styling("&.phone .not-me.bottom", {
      "font-size": "1.6em"
    }));
    styles.push(styling("&.phone.rotated .me.side", {
      "display": "inline-block"
    }));
    styles.push(styling("&.phone.rotated .not-me.side", {
      "display": "inline-block"
    }));
    styles.push(styling("&.phone.rotated .me.bottom", {
      "display": "none"
    }));
    styles.push(styling("&.phone.rotated .not-me.bottom", {
      "display": "none"
    }));
    styles.push(styling("&.phone.rotated .progress-bar", {
      "width": "16.5em",
      "height": ".4em",
      "background-color": "#cfcfcf",
      "border-radius": "0em"
    }));
    styles.push(styling("&.phone.rotated .slide", {
      "width": "16.5em",
      "height": "16.5em"
    }));
    styles.push(styling("&.phone.rotated .slide-container", {
      "width": "16.5em",
      "height": "16.5em"
    }));
    styles.push(styling("&.phone.rotated .slide img", {
      "width": "16.5em",
      "height": "16.5em"
    }));
    styles.push(styling("&.phone.rotated .slide .caption", {
      "width": "16.5em",
      "font-size": "1em",
      "padding": ".2em"
    }));
    styles.push(styling("&.phone.rotated .slide-deck", {
      "width": "26em",
      "height": "18.5em",
      "margin": "0px auto"
    }));
    styles.push(styling("&.ipad", {
      "font-weight": "100"
    }));
    styles.push(styling("&.ipad.rotated .slide-deck", {
      "font-size": "1.6em"
    }));
    styles.push(styling("& .spinner", {
      "margin-left": "auto",
      "margin-right": "auto",
      "width": "6em",
      "margin-top": "10em"
    }));
    return style(styles.join(""));
  };

  /*
  Views
   */
  partial = function(partialName, args) {
    return partials[partialName](args);
  };

  /*
  CONTROLLER
   */
  slideDeck.setProgressBar = function() {
    var slidesPlayed;
    slidesPlayed = slideDeck.fetch("slide").length / slideDeck.totalSlides;
    return slideDeck.fetch("inner-progress-bar")[0].style.width = (100 - (slidesPlayed * 100)) + "%";
  };
  slideDeck.lastAnimation = function() {
    slideDeck.fetch("slide-deck")[0].style.height = slideDeck.element.scrollHeight + "px";
    slideDeck.fetch("slide-deck")[0].innerHTML = partial("waiting-container");
    return false;
  };

  /*
  Events
   */
  Actions = function() {
    var addSlide, addSlideTimer, advanceSlide, me, mes, notMe, notMes, oldOnResize, _i, _j, _len, _len1;
    slideDeck.slideLength = slideDeck.fetch("slide").length;
    addSlideTimer = new Date();
    addSlide = function(value) {
      var slideId, slideTime;
      slideTime = new Date() - addSlideTimer;
      slideId = slideDeck.currentSlide.getAttribute("data-id");
      slideDeck.setProgressBar();
      return Traitify.addSlide(assessmentId, slideId, value, slideTime, function() {
        slideDeck.slideLength -= 1;
        if (slideDeck.slideLength === 0) {
          slideDeckCallBack();
        }
        return addSlideTimer = new Date();
      });
    };
    advanceSlide = function() {
      var ease, left, slideLeftAnimation, width;
      left = -10;
      ease = 20;
      width = slideDeck.currentSlide.offsetWidth;
      slideLeftAnimation = setInterval(function() {
        var slide;
        if (left > -(width / 2) + 30) {
          ease = ease * 1.2;
        } else {
          if (left < -(width / 2) - 30) {
            ease = ease / 1.17;
          }
        }
        left = left - ease;
        slideDeck.currentSlide.style["margin-left"] = left + "px";
        if (left < -width) {
          slide = slideDeck.currentSlide;
          slideDeck.fetch("slides")[0].removeChild(slideDeck.currentSlide);
          slideDeck.currentSlide = slideDeck.fetch("slide")[0];
          slideLock = false;
          clearInterval(slideLeftAnimation);
        }
      }, 40);
      return false;
    };
    slideDeck.currentSlide = slideDeck.fetch("slide")[0];
    slideLock = false;
    mes = slideDeck.fetch("me");
    for (_i = 0, _len = mes.length; _i < _len; _i++) {
      me = mes[_i];
      me.onclick = function(event) {
        if (!slideLock) {
          slideLock = true;
          addSlide("true");
          if (slideDeck.slideLength !== 1) {
            advanceSlide();
          } else {
            slideDeck.fetch("inner-progress-bar")[0].style.width = "100%";
            slideDeck.lastAnimation();
          }
        }
        if (event.preventDefault) {
          return event.preventDefault();
        } else {
          return event.returnValue = false;
        }
      };
    }
    slideDeck.resizeToFit = function() {
      var cln, itm, widthOfContainer;
      widthOfContainer = slideDeck.element.offsetWidth;
      if (slideDeck.element.offsetWidth === 0) {
        itm = slideDeck.element;
        cln = itm.cloneNode(true);
        while (cln.firstChild) {
          cln.removeChild(cln.firstChild);
        }
        cln.style.visibility = "hidden";
        document.body.appendChild(cln);
        widthOfContainer = cln.offsetWidth;
        document.body.removeChild(cln);
      }
      return slideDeck.element.style.fontSize = widthOfContainer / 42 + "px";
    };
    slideDeck.resizeToFit();
    oldOnResize = window.onresize;
    window.onresize = function(event) {
      slideDeck.resizeToFit();
      if (oldOnResize) {
        oldOnResize.call(window, event);
      }
    };
    notMes = slideDeck.fetch("not-me");
    for (_j = 0, _len1 = notMes.length; _j < _len1; _j++) {
      notMe = notMes[_j];
      notMe.onclick = function(event) {
        if (!slideLock) {
          slideLock = true;
          addSlide("false");
          if (slideDeck.slideLength !== 1) {
            advanceSlide();
          } else {
            slideDeck.fetch("inner-progress-bar")[0].style.width = "100%";
            slideDeck.lastAnimation();
          }
        }
        if (event.preventDefault) {
          return event.preventDefault();
        } else {
          return event.returnValue = false;
        }
      };
    }
  };
  phoneSetup = function() {
    var classes, orientationEvent, setSlideDeckOrientation, supportsOrientationChange;
    supportsOrientationChange = "onorientationchange" in window;
    orientationEvent = (supportsOrientationChange ? "orientationchange" : "resize");
    if (orientation) {
      classes = slideDeck.element.getAttribute("class") + (ipad ? " ipad" : "");
      slideDeck.element.setAttribute("class", classes + " phone");
    }
    window.addEventListener(orientationEvent, (function() {
      return setSlideDeckOrientation();
    }));
    setSlideDeckOrientation = function() {
      var captions, textSize;
      textSize = "1.2em";
      if (orientation) {
        if (window.orientation !== 0) {
          classes = slideDeck.element.getAttribute("class");
          slideDeck.element.setAttribute("class", classes + " rotated");
        } else {
          classes = slideDeck.element.getAttribute("class");
          slideDeck.element.setAttribute("class", classes.replace(" rotated", ""));
        }
        return captions = slideDeck.fetch("caption");
      }
    };
    return setSlideDeckOrientation();
  };
  selector = (selector ? selector : this.selector);
  if (selector.indexOf("#") !== -1) {
    slideDeck.element = document.getElementById(selector.replace("#", ""));
  } else {
    slideDeck.element = document.getElementsByClassName(selector.replace(".", ""))[0];
  }
  slideDeck.retina = window.devicePixelRatio > 1;
  data = function(attr) {
    return this.element.getAttribute("data-" + attr);
  };
  html = function(setter) {
    if (setter) {
      slideDeck.element.innerHTML = setter;
    }
    return slideDeck.element.innerHTML;
  };
  classes = function() {
    var key;
    classes = slideDeck.element.className.split(" ");
    for (key in classes) {
      classes[key] = "." + classes[key];
    }
    return classes.join("");
  };
  slideDeck.a = link;
  slideDeck.div = div;
  slideDeck.image = image;
  slideDeck.fetch = fetch;
  slideDeck.data = data;
  slideDeck.html = html;
  slideDeck.classes = classes;
  slideDeck.slidesUrl = function() {
    return slideDeck.host + "/v1/assessments/" + assessmentId + "/slides";
  };
  partials = Array();
  partials["slide"] = function(args) {
    var caption, id, imageUrl;
    caption = args.caption;
    imageUrl = args.imageUrl;
    id = args.id;
    return div({
      "class": "slide",
      "data-id": id
    }, [
      div({
        "class": "caption"
      }, caption), image(imageUrl, {
        "class": "image"
      }, imageUrl)
    ].join(""));
  };
  partials["slides"] = function(data) {
    var imageSrc, key, slides;
    slides = Array();
    for (key in data) {
      if (orientation) {
        imageSrc = data[key]["image_phone_landscape"];
      } else {
        imageSrc = data[key]["image_desktop"];
      }
      if (data[key].completed_at === null) {
        slides.push(partial("slide", {
          caption: data[key]["caption"],
          imageUrl: imageSrc,
          id: data[key].id
        }));
      }
    }
    slides = slides.join("");
    return div({
      "class": "slides"
    }, slides);
  };
  partials["me-not-me"] = function() {
    return link("#", {
      "class": "me bottom"
    }, "Me") + link("#", {
      "class": "not-me bottom"
    }, "Not Me");
  };
  partials["slide-container"] = function(data) {
    var progressBar, slideContainer;
    progressBar = div({
      "class": "progress-bar"
    }, div({
      "class": "inner-progress-bar"
    }, ""));
    slideContainer = div({
      "class": "slide-container"
    }, progressBar + partial("slides", data) + partial("me-not-me"));
    return link("#", {
      "class": "me side"
    }, div({
      "class": "text"
    }, "Me")) + slideContainer + link("#", {
      "class": "not-me side"
    }, div({
      "class": "text"
    }, "Not<br />Me")) + div({
      style: "clear:both"
    }, "");
  };
  partials["waiting-container"] = function() {
    return "<img src='https://s3.amazonaws.com/traitify-cdn/images/spinners/blue_dot.gif' class='spinner' />";
  };
  Traitify.getSlides(assessmentId, function(data) {
    var slides;
    slideDeck.totalSlides = data.length;
    slides = partial("slide-container", data);
    slideDeck.html(div({
      "class": "slide-deck"
    }, slides));
    slideDeck.html(slideDeck.html() + styles());
    Actions();
    phoneSetup();
    slideDeck.setProgressBar();
  });
  return this;
};
