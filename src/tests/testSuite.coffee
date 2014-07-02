describe = (description, testSuite, options)->
	Builder = Object()
	Builder.description = description;
	Builder.test = (title, testCase)->
		@errors = Array()
		@testCase = testCase;

		@assert = (assertion, assertionCode, assertionType)->
			if assertion
				if(options && options.logger)
					print("<span style='color:#00ff00'>*</span>")

				if(options && !options.silent)
					console.log("*")
			else
				error = "X #{title} on #{@description} failed #{assertionCode}, #{assertionType}"
				console.log(error)
				@errors.push(error)

		@it = (testItem)->
			@testItem = testItem
			@should_be_equal_to = (assertedItem)->
				@assert(@testItem == assertedItem)

			@should_have_text = (assertedItem)->
				@assert(@testItem.indexOf(assertedItem) != -1, @testItem, "should_have_text")

			@should_be_a_number = ()->
				@assert(typeof @testItem == "number", @testItem, "should_be_a_number")

			@should_be_an_integer = ()->
				isNumber = (typeof @testItem == "number")
				@testItem = "#{@testItem}"
				doesNotHavePeriod = !("#{@testItem}".indexOf(".") != -1)
				@assert(isNumber && doesNotHavePeriod, @testItem, "should_be_an_integer")

			@should_be_a_float = ()->
				isNumber = (typeof @testItem == "number")
				hasPeriod = "#{@testItem}".indexOf(".") != -1
				@assert(isNumber && hasPeriod, @testItem, "should_be_a_float")

			@should_be_a_string = ()->
				@assert(typeof @testItem == "string", @testItem, "should_be_a_string")

			this

		@testCase()

	Builder.testSuite = testSuite
	Builder.testSuite()

describe("testSuite Test", ->
	@test("should be", ->
		@it("should have text").should_have_text("have")
		@it("should be equal to").should_be_equal_to("should be equal to")
		@it("should be a string").should_be_a_string()
		@it(1).should_be_a_number()
		@it(1).should_be_an_integer()
		@it(1.1).should_be_a_float()

	)
	
	{silent:true})