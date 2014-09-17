Number::times = (fn) ->
	for [0..@valueOf()]
		fn(_i)

UUID = ->
  s4 = ->
    return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
  s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4()