
Traitify.js
===============

This package does not require jQuery, as it is a standalone encapsulated library. It does however require a browser with the ability to make ajax requests.

Html:


How to initialize:

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

