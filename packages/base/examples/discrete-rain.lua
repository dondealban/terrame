-- @example A simple discrete rain model. It simply computes the
-- amount of water according to the rain and a flow coefficient.
-- @arg C The amount of rain per unit of time. The default value is 2.
-- @arg K The flow coefficient. The default value is 0.4.

-- model parameters
C = 2
K = 0.4

-- GLOBAL VARIABLES
q = 0
input = 0
output = 0

-- RULES
t = Timer{
	Event{start = 0, action = function(event)
		-- rain
		input = C
		-- soil water
		q = q + input - output
		-- drainage
		output = K * q
		-- report
		print(event:getTime(), input, output, q)
	end}
}

t:run(100)

