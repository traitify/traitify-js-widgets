
Traitify.js
===============

This package does not require jQuery, as it is a standalone encapsulated library. It does however require a browser with the ability to make cors requests (currently only supports ie10 and up, chrome, safari).

Html:


How to initialize Version 1:

    <div>
        <div class="traitify">
        </div>
    </div>

    <script>
        Traitify.setPublicKey("Your public key");
        Traitify.setHost("The Host For Your Url");
        Traitify.setVersion("Version of API (v1)");
        var setAssessmentId = "Your assessment Id";

        Traitify.ui.slideDeck(assessmentId, ".traitify", function(){
            Traitify.ui.resultsProp(assessmentId, ".traitify");
        });
    </script>


How to initialize Version 2:
    <script>
        Traitify.setPublicKey(“your public key”);
        Traitify.setHost(“your host”);
        Traitify.setVersion(“Version of API (v1)”);
        var assessmentId = “Your assessment Id”;

        Traitify.ui.slideDeck(assessmentid, “.traitify)

    </script>
