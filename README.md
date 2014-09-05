
Traitify.js
===============

This package does not require jQuery, as it is a standalone encapsulated library. It does however require a browser with the ability to make cors requests (currently only supports ie10 and up, chrome, safari).

Html:


How to initialize Version 1:

    <div>
        <div class="traitify-widget">
        </div>
    </div>

    <script>
        Traitify.setPublicKey("Your public key");
        Traitify.setHost("The Host For Your Url");
        Traitify.setVersion("Version of API (v1)");
        var assessmentId = "Your assessment Id";

        Traitify.ui.load(assessmentId, ".traitify-widget")
    </script>
