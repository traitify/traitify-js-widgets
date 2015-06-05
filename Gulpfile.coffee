gulp = require("gulp")
webserver = require("gulp-webserver")
cors = require("cors")
traitify = require("traitify")
fs = require("fs")
coffee = require('gulp-coffee')
concat = require('gulp-concat')
yaml = require('yamljs')
minify = require('minify')
uglify = require('gulp-uglify')
gutil = require('gulp-util')
rename = require("gulp-rename")
gzip = require('gulp-gzip')
qunit = require('gulp-qunit')
clean = require('gulp-clean')
watch = require('gulp-watch')
runSequence = require('run-sequence')

gulp.task("server", ->
  express = require('express')
  app = express()
  app.use(cors())

  #CREATE ASSESSMENT
  app.post("/assessments", (req, res)->
    traitify.setHost(process.env.TF_HOST)
    traitify.setVersion("v1")
    traitify.setSecretKey(process.env.TF_SECRET_KEY)
    traitify.createAssessment(req.query.deck, (assessment)->
        res.send(assessment)
    )
  )
  app.post("/public_key", (req, res)->
    res.send(process.env.TF_PUBLIC_KEY)
  )

  # RENDER INDEX PAGE
  app.get("/", (req, res)->
    fileContents = fs.readFileSync("./public/index.html", "utf8")
    res.send(fileContents)
  )

  app.get("/tests/*", (req, res)->
    a = req.originalUrl
    fileContents = fs.readFileSync(req.originalUrl.slice(1, req.originalUrl.length), "utf8")
    res.send(fileContents)
  )

  app.get("/assets/*", (req, res)->
    res.setHeader('Content-Type', "text/css" )
    a = req.originalUrl
    fileContents = fs.readFileSync(req.originalUrl.slice(1, req.originalUrl.length), "utf8")
    res.send(fileContents)
  )

  app.get("/public/*", (req, res)->
    a = req.originalUrl
    fileContents = fs.readFileSync(req.originalUrl.slice(1, req.originalUrl.length), "utf8")
    res.send(fileContents)
  )

  app.get("/api-client/compiled/*", (req, res)->
    res.setHeader('Content-Type', "text/javascript" )
    a = req.originalUrl
    fileContents = fs.readFileSync(req.originalUrl.slice(1, req.originalUrl.length), "utf8")
    res.send(fileContents)
  )

  app.get("/compiled/*", (req, res)->
    res.setHeader('Content-Type', "text/javascript" )
    a = req.originalUrl
    fileContents = fs.readFileSync(req.originalUrl.slice(1, req.originalUrl.length), "utf8")
    res.send(fileContents)
  )

  app.listen(9292)
)

gulp.task('coffee', ->
  return gulp.src('./src/**/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./compiled/'))
)

gulp.task("bundle:scripts", (done)->
  bundles = fs.readFileSync("./bundles.yml", "utf8")
  bundles = yaml.parse(bundles)

  bundleNames = Object.keys(bundles)
  for bundleName in bundleNames
    jsContent = String()
    for bundleJS in bundles[bundleName].js
      jsContent += fs.readFileSync(bundleJS, "utf8")

    fs.writeFileSync("./compiled/bundles-src/#{bundleName}.js", jsContent)
    if bundleNames.indexOf(bundleName) + 1 == bundleNames.length
      done()
)

gulp.task("bundle:styles", (done)->
  bundles = fs.readFileSync("./bundles.yml", "utf8")
  bundles = yaml.parse(bundles)
  bundleNames = Object.keys(bundles)
  for bundleName in bundleNames
    styles = bundles[bundleName].css.map((css)->
      "assets/stylesheets/#{css}"
    )

    fs.writeFileSync("./compiled/bundles-src/#{bundleName}_styles.js", "")

    for style in styles
      cleanFileName = style.split("/").slice(0, style.split("/").length - 1).join("/")
      cleanFileName = cleanFileName.replace("assets/stylesheets/widgets/", "")
      styleFile = fs.readFileSync(style)
      minify(ext: ".css", data: styleFile, (error, minifiedFileData)->
        u = "Traitify.ui.styles['#{cleanFileName}'] = '"
        minifiedFileData = u + minifiedFileData + "';\n"

        fs.appendFileSync("./compiled/bundles-src/#{bundleName}_styles.js", minifiedFileData)
        lastBundle = bundleNames.indexOf(bundleName) + 1 == bundleNames.length
        lastStyle = styles.indexOf(style) + 1 == styles.length
        if lastBundle && lastStyle
          done()
      )
)

gulp.task("bundle:merge", (done)->
  bundles = fs.readFileSync("./bundles.yml", "utf8")
  bundles = yaml.parse(bundles)

  bundleNames = Object.keys(bundles)
  for bundleName in bundleNames
    js = fs.readFileSync("./compiled/bundles-src/#{bundleName}.js", "utf8")
    style = fs.readFileSync("./compiled/bundles-src/#{bundleName}_styles.js", "utf8")
    fs.writeFileSync("compiled/bundles/src/#{bundleName}.js", js + "\n" + style)

    if bundleNames.indexOf(bundleName) + 1 == bundleNames.length
      done()
)

gulp.task("bundle:production", ->
  return gulp.src("./compiled/bundles/src/*.js")
  .pipe(uglify())
  .pipe(rename((path)->
    path.extname = ".min.js"
  ))
  .pipe(gulp.dest("./compiled/bundles"))
)

gulp.task("bundle:debug", ->
  return gulp.src("./compiled/bundles/src/*.js")
  .pipe(rename((path)->
    path.extname = ".debug.js"
  ))
  .pipe(gulp.dest("./compiled/bundles"))
)

gulp.task('bundle:compress', ->
    return gulp.src('./compiled/bundles/*.min.js')
    .pipe(gzip())
    .pipe(gulp.dest('./compiled/bundles'))
)

gulp.task('bundle:test', (done)->
  runSequence("bundle", "test:bundles", done)
)

gulp.task('test:bundles', ->
    return gulp.src('./tests/*.html')
        .pipe(qunit())
)

gulp.task('clean', ->
    return gulp.src([
      './compiled/builder/*.js',
      "./compiled/loader/*.js",
      "./compiled/ui/*.js",
      "./compiled/widgets/results/career-details/*.js",
      "./compiled/widgets/results/careers/*.js",
      "./compiled/widgets/results/default/*.js",
      "./compiled/widgets/results/famous-people/*.js",
      "./compiled/widgets/results/personality-traits/*.js",
      "./compiled/widgets/results/personality-types/*.js",
      "./compiled/widgets/slide-deck/*.js"
    ], {read: false}).pipe(clean())
)

gulp.task('bundle:clean', ->
    return gulp.src(['./compiled/bundles/*.js',
      "./compiled/bundles/src/*.js",
      "./compiled/bundles-src/*.js"
    ], {read: false}).pipe(clean())
)
gulp.task("watch", ->
  watch(['assets/**/*.css', 'src/**/*.coffee'],->
      gulp.start("bundle:test")
  )
)

gulp.task("bundle", (done)->
  return runSequence(
    "clean",
    "coffee",
    "bundle:clean",
    "bundle:scripts",
    "bundle:styles",
    "bundle:merge",
    "bundle:debug",
    "bundle:production",
    "bundle:compress",
  done)
)

gulp.task("default", ["server", "bundle:test", "watch"])
