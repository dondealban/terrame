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
-- Authors: Pedro R. Andrade
-------------------------------------------------------------------------------------------

return{
	Chart = function(unitTest)
		local Tube = Model{
			init = function(model)
				model.t = Timer{Event{action = function(ev)
					model.v = model.v + 1
					model:notify(ev)
				end}}
				model.v = 1
			end,
			finalTime = 10
		}

		local tube = Tube{}

		local c = Chart{
			subject = tube
		}

		tube:execute(10)

		local world = Agent{
			count = 0,
			mcount = function(self)
				return self.count + 1
			end
		}

		local c1 = Chart{subject = world}

		local c1 = Chart{
			subject = world,
			select = {"mcount"},
			color = "green",
			size = 5,
			pen = "solid",
			symbol = "square",
			width = 3,
			style = "lines"
		}

		local soc = Society{
			instance = world,
			quantity = 3
		}

		local c1 = Chart{subject = soc}

		local world = CellularSpace{
			xdim = 10,
			count = 0,
			mcount = function(self)
				return self.count + 1
			end
		}

		local c1 = Chart{subject = world}
		local c1 = Chart{subject = world, select = "mcount", xAxis = "count"}

		unitTest:assert(true)
	end,
	save = function(unitTest)
		local c = Cell{value = 1}

		local ch = Chart{subject = c}

		c:notify(1)
		c:notify(2)
		c:notify(3)

		local file = unitTest:tmpFolder()..sessionInfo().separator.."save_test.bmp"

		ch:save(file)

		unitTest:assert(isFile(file))
	end
}

