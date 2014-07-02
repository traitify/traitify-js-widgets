describe("API Endpoints", ->
	@test("setHost", ->
		Traitify.setHost("awesome").host
		@it(Traitify.setHost("awesome").host).should_be_equal_to("awesome")

		@it(Traitify.setVersion("version").version).should_be_equal_to("version")

		@it(Traitify.setPublicKey("key").publicKey).should_be_equal_to("key")
	)
)