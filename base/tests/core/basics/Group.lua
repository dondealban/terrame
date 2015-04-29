-------------------------------------------------------------------------------------------
-- TerraME - a software platform for multiple scale spatially-explicit dynamic modeling.
-- Copyright (C) 2001-2014 INPE and TerraLAB/UFOP.
--
-- This code is part of the TerraME framework.
-- This framework is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this library.
--
-- The authors reassure the license terms regarding the warranties.
-- They specifically disclaim any warranties, including, but not limited to,
-- the implied warranties of merchantability and fitness for a particular purpose.
-- The framework provided hereunder is on an "as is" basis, and the authors have no
-- obligation to provide maintenance, support, updates, enhancements, or modifications.
-- In no event shall INPE and TerraLAB / UFOP be held liable to any party for direct,
-- indirect, special, incidental, or caonsequential damages arising out of the use
-- of this library and its documentation.
--
-- Authors: Pedro R. Andrade (pedro.andrade@inpe.br)
--          Rodrigo Reis Pereira
-------------------------------------------------------------------------------------------

return{
	Group = function(unitTest)
		local group1 = Group{}
		unitTest:assert_type(group1, "Group")

		local nonFooAgent = Agent{
			init = function(self)
				self.age = Random():integer(10)
			end,
			w = 3,
			p = 5,
			execute = function(self)
				self.age = self.age + 1
			end
		}

		local nonFooSociety = Society{
			instance = nonFooAgent,
			quantity = 10
		}

		local g = Group{
			target = nonFooSociety
		}
		unitTest:assert_type(g, "Group")
		unitTest:assert_equal(#g, #nonFooSociety)
		unitTest:assert_equal(g.agents[1], nonFooSociety.agents[1])
		unitTest:assert_nil(g.select)
		unitTest:assert_nil(g.greater)
		unitTest:assert_equal(g:w(), 30)
		unitTest:assert_equal(g:p(), 50)

		g = Group{
			target = nonFooSociety,
			build = false
		}
		unitTest:assert_equal(0, #g)
		
		g:filter()
		unitTest:assert_equal(#nonFooSociety, #g)

		g = Group{
			target = nonFooSociety,
			select = function(ag)
				return ag.age > 5
			end
		}

		unitTest:assert_equal(6, #g)
		local sum = 0
		forEachAgent(g, function(ag)
			sum = sum + ag.age
		end)

		unitTest:assert_equal(49, sum)

		local g2 = Group{
			target = g,
			select = function(ag)
				return ag.age < 8
			end
		}

		unitTest:assert_equal(#g2, 2)

		g = Group{
			target = nonFooSociety,
			greater = function(a, b)
				return a.age > b.age
			end
		}

		unitTest:assert_equal(10, #g)
		unitTest:assert_equal(10, g.agents[1].age)
		unitTest:assert_equal(0, g.agents[10].age)
	end,
	__len = function(unitTest)
		local ag1 = Agent{age = 8}
		local soc1 = Society{
			instance = ag1,
			quantity = 2
		}

		local g1 = Group{
			target = soc1,
			select = function(ag) return ag.age > 5 end
		}
	
		unitTest:assert(#g1 == 2)
	end,
	__tostring = function(unitTest)
		local ag1 = Agent{age = 8}
		local soc1 = Society{
			instance = ag1,
			quantity = 2
		}

		local g1 = Group{
			target = soc1,
			select = function(ag) return ag.age > 5 end
		}
		unitTest:assert_equal(tostring(g1), [[age     function
agents  table of size 2
parent  Society
select  function
]])
	end,
	add = function(unitTest)
		local nonFooAgent = Agent{}

		local soc = Society{
			instance = nonFooAgent,
			quantity = 10
		}

		local g = Group{
			target = soc,
			build = false
		}

		g:add(soc.agents[1])
		g:add(soc.agents[2])
		g:add(soc.agents[3])
	
		unitTest:assert_equal(#g, 3)
	end,
	clone = function(unitTest)
		local randomObj = Random{}
		randomObj:reSeed(0)

		local nonFooAgent = Agent{
			name = "nonfoo",
			init = function(self)
				self.age = randomObj:integer(10)
				if self.age < 5 then
					self.name = "foo"
				end
			end,
			execute = function(self)
				self.age = self.age + 1
			end
		}

		local soc = Society{
			instance = nonFooAgent,
			quantity = 10
		}

		local g = Group{
			target = soc,
			select = function(ag) return ag.age > 5 end
		}
		unitTest:assert_type(g, "Group")
		unitTest:assert_equal(6, #g)

		local g2 = g:clone()
		unitTest:assert_type(g2, "Group")
		unitTest:assert_equal(#g, #g2)
		unitTest:assert(g.select == g2.select)
		unitTest:assert(g.greater == g2.greater)
		unitTest:assert(g.parent == g2.parent)
		unitTest:assert(g.agents[1] == g2.agents[1])
	end,
	filter = function(unitTest)
		local count = 0
		local nonFooAgent = Agent{
			init = function(self)
				self.age = count
				count = count + 1
			end,
			execute = function(self)
				self.age = self.age + 1
			end
		}

		local nonFooSociety = Society{
			instance = nonFooAgent,
			quantity = 10
		}

		local g = Group{target = nonFooSociety}

		g:filter(function(ag)
			return ag.age > 5 and ag.age < 8
		end)

		forEachAgent(g, function(agent)
			unitTest:assert(agent.age > 5 and agent.age < 8)
		end)
	end,
	randomize = function(unitTest)
		local nonFooAgent = Agent{
			init = function(self)
				self.age = Random():integer(10)
			end,
			execute = function(self)
				self.age = self.age + 1
			end
		}

		local nonFooSociety = Society{
			instance = nonFooAgent,
			quantity = 10
		}

		local g = Group{
			target = nonFooSociety,
			select = function(ag)
				return ag.age < 8
			end
		}

		unitTest:assert_equal(#g, 6)
		g:randomize()
		unitTest:assert_equal(#g, 6)
		unitTest:assert_equal(0, g.agents[1].age)
	end,
	rebuild = function(unitTest)
		local nonFooAgent = Agent{
			init = function(self)
				self.age = Random():integer(10)
			end,
			execute = function(self)
				self.age = self.age + 1
			end
		}

		local nonFooSociety = Society{
			instance = nonFooAgent,
			quantity = 10
		}

		local g = Group{
			target = nonFooSociety,
			select = function(ag)
				return ag.age < 8
			end,
			greater = function(a, b)
				return a.age < b.age
			end
		}

		unitTest:assert_equal(0, g.agents[1].age)
		unitTest:assert_equal(6, g.agents[6].age)

		nonFooSociety:execute()
		g:rebuild()

		unitTest:assert_equal(6, #g)
		g:execute()
		g:execute()
		g:execute()
		g:rebuild()

		unitTest:assert_equal(3, #g)
		unitTest:assert_equal(4, g.agents[1].age)
	end,
	sort = function(unitTest)
		local count = 0
		local nonFooAgent = Agent{
			init = function(self)
				self.age = count
				count = count + 1
			end,
			execute = function(self)
				self.age = self.age + 1
			end
		}

		local nonFooSociety = Society{
			instance = nonFooAgent,
			quantity = 10
		}

		local g = Group{
			target = nonFooSociety
		}

		g:sort(function(ag1, ag2)
			return ag1.age < ag2.age
		end)

		local lastAge = 0
		forEachAgent(g, function(agent)
			unitTest:assert(agent.age >= lastAge)
			lastAge = agent.age
		end)
	end
}

