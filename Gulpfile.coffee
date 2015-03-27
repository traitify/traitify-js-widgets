gulp = require("gulp")
webserver = require("gulp-webserver")
cors = require("cors")
traitify = require("traitify")
fs = require("fs")

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

  app.get("/", (req, res)->
    fileContents = fs.readFileSync("./public/index.html", "utf8")
    res.send(fileContents)
  )

  app.get("/tests/*", (req, res)->
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

gulp.task("default", ["server"])
