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
      career = widget.options.careerDetails.career
      target = document.getElementsByClassName("popout-career")[0]

      careerDetailsWidgetContainer = @tags.div("tfCareerDetails")
      if Traitify.oldIE
        careerDetailsWidgetContainer.className += " ie"

      @tags.div("careerDetails").appendTo("tfCareerDetails")

      header = @tags.div(["careerDetails.header"])
      innerHeader = @tags.div("header-inner")
      innerHeader.appendChild(@tags.span("header-text", "Career Details"))
      if target
        exitButton = @tags.span("header-close", "X")
        exitButton.onclick = (event)->
          target.parentNode.removeChild(target)
          widget.views.remove("Career Details Container")
          document.body.className = document.body.className.replace(" tf-popout-open", "")
        innerHeader.appendChild(exitButton)
      header.appendChild(innerHeader)
      header.appendTo("careerDetails")
      @tags.div("careerDetailsBody").appendTo("careerDetails")
      @tags.img(["careerDetailsBody.image"], career.picture).appendTo("careerDetailsBody")
      details = @tags.div(["careerDetailsBody.details"])
      details.appendChild(@tags.div("title", career.title))
      details.appendChild(@tags.div("description", career.description))
      details.appendTo("careerDetailsBody")

      # Stats
      stats = @tags.div(["careerDetailsBody.stats"])

      # Salary
      salary = @tags.div("stat")
      salary.appendChild(@tags.div("stat-title invisible", "Blank"))
      data = @tags.div("stat-data")
      data.appendChild(@tags.div("stat-data-header", "Mean"))
      data.appendChild(@tags.div("stat-data-header", "Median"))
      salary.appendChild(data)
      stats.appendChild(salary)

      salary = @tags.div("stat")
      stats.appendChild(salary)

      salary = @tags.div("salary")
      salary.className += " stat"
      salary.appendChild(@tags.div("stat-title", "Salary:"))
      data = @tags.div("stat-data")
      data.appendChild(@tags.div("stat-data-body", "$" + career.salary_projection.annual_salary_mean.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")))
      data.appendChild(@tags.div("stat-data-body", "$" + career.salary_projection.annual_salary_median.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, "$1,")))
      salary.appendChild(data)
      stats.appendChild(salary)

      block_img = """<img src="https://cdn.traitify.com/assets/images/career-details/block.png" alt="Block">"""
      future_img = if career.bright_outlooks then """<img src="https://cdn.traitify.com/assets/images/career-details/sun.png" alt="Sun">""" else block_img
      green_img = if career.bright_outlooks then """<img src="https://cdn.traitify.com/assets/images/career-details/green.png" alt="Green">""" else block_img

      # Bright Future
      future = @tags.div("future")
      future.className += " stat"
      future.innerHTML = """
        <div class="stat-title">Bright Future:</div>
        <div class="stat-data">
          """ + future_img + """
        </div>
      """
      stats.appendChild(future)

      # Job Growth
      growth = @tags.div("growth")
      growth.className += " stat"
      growth.innerHTML = """
        <div class="stat-title">Job Growth:</div>
        <div class="stat-data">
          """ + career.employment_projection.percent_growth_2022 + """%
        </div>
      """
      stats.appendChild(growth)

      # Green Career
      green = @tags.div("green")
      green.className += " stat"
      green.innerHTML = """
        <div class="stat-title">Green Career:</div>
        <div class="stat-data">
          """ + green_img + """
        </div>
      """
      stats.appendChild(green)

      # Degree
      degree = @tags.div("degree")
      degree.className += " stat"
      degree.innerHTML = """
        <div class="stat-title">Education:</div>
        <div class="stat-data">
          """ + career.experience_level.degree + """
        </div>
      """
      stats.appendChild(degree)
      stats.appendTo("careerDetailsBody")

      # ONet Link
      onet = @tags.div("onet")
      onet.className += " stat"
      onet.innerHTML = """
        <div class="stat-title">O'Net Link</div>
        <div class="stat-data">
          <a href="http://www.onetonline.org/link/summary/""" + career.id + """">""" + career.id + """</a>
        </div>
      """
      stats.appendChild(onet)

      # Experience
      experience = @tags.div(["careerDetailsBody.experience"])
      header = @tags.div("experience-header")
      header.appendChild(@tags.span("experience-header-text", "Experience Level"))
      experienceBoxes = @tags.div("experience-boxes")
      for level in [1..career.experience_level.id]
        experienceBox = @tags.div("experience-box")
        experienceBox.className += " highlighted-box"
        experienceBoxes.appendChild(experienceBox)
      for level in [1..(5-career.experience_level.id)]
        experienceBoxes.appendChild(@tags.div("experience-box"))
      header.appendChild(experienceBoxes)
      header.appendChild(@tags.span("experience-header-number", "" + career.experience_level.id))
      experience.appendChild(header)
      experience.appendChild(@tags.div("experience-body", career.experience_level.experience))
      experience.appendTo("careerDetailsBody")

      # Education
      education = @tags.div(["careerDetailsBody.education"])
      header = @tags.div("education-header")
      header.appendChild(@tags.span("education-header-text", "Education"))
      education.appendChild(header)
      education.appendChild(@tags.div("education-body", career.experience_level.education))
      education.appendTo("careerDetailsBody")

      # Majors
      majors = @tags.div(["careerDetailsBody.majors"])
      header = @tags.div("majors-header")
      header.appendChild(@tags.span("majors-header-text", "Majors"))
      majors.appendChild(header)
      body = @tags.div("majors-body")
      for m in career.majors
        major = @tags.div("major")
        major.appendChild(@tags.div("major-title", m.title))
        major.appendChild(@tags.div("major-description", m.description))
        body.appendChild(major)
      if career.majors.length == 0
        major = @tags.div("major")
        major.appendChild(@tags.div("major-title", "None"))
        body.appendChild(major)
      majors.appendChild(body)
      majors.appendTo("careerDetailsBody")

      careerDetailsWidgetContainer
    )
)
