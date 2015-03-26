gulp = require("gulp")
webserver = require("gulp-webserver")
gulp.task('webserver', ->
  gulp.src("./public").pipe(webserver({livereload: true, directoryListing: false, port: 8080, open: true}))
)
gulp.task('default', ['webserver'])
