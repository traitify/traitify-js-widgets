Traitify.ui.widget("careerDetails", (widget, options)->
  widget.states.add("initialized")
  widget.callbacks.add("Initialize")
  widget.styleDependency("all")
  widget.styleDependency("results/career-details")

  if widget.options.careerDetails
    ########################
    # INITIALIZE
    ########################
    widget.initialization.events.add("Setup Data", ->
      widget.views.render("Career Details Container").appendTo("main")
      widget.callbacks.trigger("Initialize")
    )

    #########################
    # PARTIALS
    #########################
    widget.views.add("Career Details Container", ->
      score = widget.options.careerDetails.score
      career = widget.options.careerDetails.career
      target = document.getElementsByClassName("tf-popout-career")[0]

      careerDetailsWidgetContainer = @tags.div("tfCareerDetails")
      if Traitify.oldIE
        careerDetailsWidgetContainer.className += " ie"

      @tags.div("tfCareerDetailsInner").appendTo("tfCareerDetails")

      header = @tags.div(["tfCareerDetailsInner.tfHeader"])
      innerHeader = @tags.div("tf-header-inner")
      innerHeader.appendChild(@tags.span("tf-header-text", "Career Details"))
      if target
        exitButton = @tags.span("tf-header-close", "X")
        exitButton.onclick = (event)->
          event.preventDefault()
          target.parentNode.removeChild(target)
          widget.views.remove("Career Details Container")
          document.getElementsByTagName("html")[0].className = document.getElementsByTagName("html")[0].className.replace(" tf-popout-open", "");
          return false
        innerHeader.appendChild(exitButton)
      header.appendChild(innerHeader)
      header.appendTo("tfCareerDetailsInner")
      @tags.div("tfCareerDetailsBody").appendTo("tfCareerDetailsInner")
      career.picture ?= "https://cdn.traitify.com/assets/images/career-details/default-career.jpg"
      @tags.img(["tfCareerDetailsBody.tfImage"], career.picture).appendTo("tfCareerDetailsBody")
      details = @tags.div(["tfCareerDetailsBody.tfDetails"])
      details.appendChild(@tags.div("tfTitle", career.title))
      if score
        scoreBox = @tags.div("tfScore")
        scoreBox.appendChild(@tags.span("tfPercent", Math.round(score) + "%"))
        scoreBox.appendChild(@tags.span("", "match"))
        details.appendChild(scoreBox)
      details.appendChild(@tags.div("tfDescription", career.description))
      details.appendTo("tfCareerDetailsBody")

      # Stats
      stats = @tags.div(["tfCareerDetailsBody.tfStats"])

      # Salary Mean
      mean = @tags.div("tf-mean")
      mean.className += " tf-stat"
      mean.innerHTML = """
        <div class="tf-stat-title">Salary Mean:</div>
        <div class="tf-stat-data">
          """ + (career.salary_projection ? "$"+career.salary_projection.annual_salary_mean.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") : "not available") + """
        </div>
      """
      stats.appendChild(mean)

      block_img = """<img src="https://cdn.traitify.com/assets/images/career-details/block.png" alt="Block">"""
      future_img = if career.bright_outlooks then """<img src="https://cdn.traitify.com/assets/images/career-details/sun.png" alt="Sun">""" else block_img
      green_img = if career.bright_outlooks then """<img src="https://cdn.traitify.com/assets/images/career-details/green.png" alt="Green">""" else block_img

      # Bright Future
      future = @tags.div("tf-future")
      future.className += " tf-stat"
      future.innerHTML = """
        <div class="tf-stat-title">Bright Future:</div>
        <div class="tf-stat-data">
          """ + future_img + """
        </div>
      """
      stats.appendChild(future)

      # Salary Median
      median = @tags.div("tf-median")
      median.className += " tf-stat"
      median.innerHTML = """
        <div class="tf-stat-title">Salary Median:</div>
        <div class="tf-stat-data">
          """ + (career.salary_projection ? "$"+career.salary_projection.annual_salary_median.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,") : "not available") + """
        </div>
      """
      stats.appendChild(median)

      # Green Career
      green = @tags.div("tf-green")
      green.className += " tf-stat"
      green.innerHTML = """
        <div class="tf-stat-title">Green Career:</div>
        <div class="tf-stat-data">
          """ + green_img + """
        </div>
      """
      stats.appendChild(green)

      # Job Growth
      growth = @tags.div("tf-growth")
      growth.className += " tf-stat"
      growth.innerHTML = """
        <div class="tf-stat-title">Job Growth:</div>
        <div class="tf-stat-data">
          """ + (career.employment_projection ? career.employment_projection.percent_growth_2022+"%" : "not available") + """
        </div>
      """
      stats.appendChild(growth)

      # ONet Link
      onet = @tags.div("tf-onet")
      onet.className += " tf-stat"
      onet.innerHTML = """
        <div class="tf-stat-title">O'Net Link:</div>
        <div class="tf-stat-data">
          <a href="http://www.onetonline.org/link/summary/""" + career.id + """" target="_blank">""" + career.id + """</a>
        </div>
      """
      stats.appendChild(onet)
      stats.appendTo("tfCareerDetailsBody")

      # Experience
      experience = @tags.div(["tfCareerDetailsBody.tfExperience"])
      header = @tags.div("tf-experience-header")
      header.appendChild(@tags.span("tf-experience-header-text", "Experience Level"))
      experienceBoxes = @tags.div("tf-experience-boxes")
      for level in [0..(career.experience_level.id-1)]
        experienceBox = @tags.div("tf-experience-box")
        experienceBox.className += " tf-highlighted-box"
        experienceBoxes.appendChild(experienceBox)
      if level < 5
        for level in [1..(5-career.experience_level.id)]
          experienceBoxes.appendChild(@tags.div("tf-experience-box"))
      header.appendChild(experienceBoxes)
      experience.appendChild(header)
      experience.appendChild(@tags.div("tf-experience-body", career.experience_level.experience))
      experience.appendTo("tfCareerDetailsBody")

      # Education
      education = @tags.div(["tfCareerDetailsBody.tfEducation"])
      header = @tags.div("tf-education-header")
      header.appendChild(@tags.span("tf-education-header-text", "Education"))
      education.appendChild(header)
      body = @tags.div("tf-education-body")
      body.appendChild(@tags.div("tf-education-title", career.experience_level.degree))
      body.appendChild(@tags.div("tf-education-description", career.experience_level.education))
      education.appendChild(body)
      education.appendTo("tfCareerDetailsBody")

      # Majors
      majors = @tags.div(["tfCareerDetailsBody.tfMajors"])
      header = @tags.div("tf-majors-header")
      header.appendChild(@tags.span("tf-majors-header-text", "Majors"))
      majors.appendChild(header)
      body = @tags.div("tf-majors-body")
      for m in career.majors
        major = @tags.div("tf-major")
        major.appendChild(@tags.div("tf-major-title", m.title))
        major.appendChild(@tags.div("tf-major-description", m.description))
        body.appendChild(major)
      if career.majors.length == 0
        major = @tags.div("tf-major")
        major.appendChild(@tags.div("tf-major-title", "None"))
        body.appendChild(major)
      majors.appendChild(body)
      majors.appendTo("tfCareerDetailsBody")

      careerDetailsWidgetContainer
    )
)
