Mocker.mock("GET", "https://api-sandbox.traitify.com/v1/decks", JSON.stringify({}), [{
	name: "Career Deck"
}])

url = "https://api-sandbox.traitify.com/v1/assessments/unplayed/slides"
response = Array()
for (i = 0; i < 84; i++) {
	response.push({id: i, caption: "Navigating"})
}
Mocker.mock("GET", url, JSON.stringify({}), response)


url = "https://api-sandbox.traitify.com/v1/assessments/played/slides"
response = Array()
for (i = 0; i < 84; i++) {
	response.push({id: i, caption: "Navigating", completed_at: Date.now()})
}
Mocker.mock("GET", url, JSON.stringify({}), response)

url = "https://api-sandbox.traitify.com/v1/assessments/played/personality_types"
mockedPersonalityTypes = Array()
for (i = 0; i < 6; i++) {
	mockedPersonalityTypes.push({score:10, personality_type:{name: "Navigating", badge: Object()}})
}
response = {personality_blend:"", personality_types: mockedPersonalityTypes}
Mocker.mock("GET", url, JSON.stringify({}), response)

url = "https://api-sandbox.traitify.com/v1/assessments/played/slides/0"
Mocker.mock("PUT", url, JSON.stringify({"response":true, "time_taken":1000}), "")


url = "https://api-sandbox.traitify.com/v1/assessments/played/slides"
Mocker.mock("PUT", url, JSON.stringify([{"id":0,"response":true,"response_time":1000}]), "")


url = "https://api-sandbox.traitify.com/v1/assessments/unplayed/slides/0"
Mocker.mock("PUT", url, JSON.stringify({"response":true, "time_taken":1000}), "")


url = "https://api-sandbox.traitify.com/v1/assessments/unplayed/slides"
Mocker.mock("PUT", url, JSON.stringify([{"id":0,"response":true,"response_time":1000}]), "")
