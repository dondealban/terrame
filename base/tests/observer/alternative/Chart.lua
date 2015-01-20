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
		local c = Cell{value = 5}

		local error_func = function()
			Chart{}
		end
		unitTest:assert_error(error_func, mandatoryArgumentMsg("subject"))

		local error_func = function()
			Chart{subject = c, select = 5}
		end
		unitTest:assert_error(error_func, incompatibleTypeMsg("select", "table", 5))

		local error_func = function()
			Chart{subject = c, select = "mvalue"}
		end
		unitTest:assert_error(error_func, "Selected element 'mvalue' does not belong to the subject.")

		local error_func = function()
			Chart{subject = c, xLabel = 5}
		end
		unitTest:assert_error(error_func, incompatibleTypeMsg("xLabel", "string", 5))

		local error_func = function()
			Chart{subject = c, yLabel = 5}
		end
		unitTest:assert_error(error_func, incompatibleTypeMsg("yLabel", "string", 5))

		local error_func = function()
			Chart{subject = c, title = 5}
		end
		unitTest:assert_error(error_func, incompatibleTypeMsg("title", "string", 5))

		local error_func = function()
			Chart{subject = c, xAxis = 5}
		end
		unitTest:assert_error(error_func, incompatibleTypeMsg("xAxis", "string", 5))

		local error_func = function()
			Chart{subject = c, xwc = 5}
		end
		unitTest:assert_error(error_func, unnecessaryArgumentMsg("xwc"))

		local error_func = function()
			Chart{subject = c, select = {}}
		end
		unitTest:assert_error(error_func, "Charts must select at least one attribute.")

		local cell = Cell{
			value1 = 2,
			value2 = 3
		}

		local error_func = function()
			Chart{subject = cell, select = {"value1", "value2"}, style = 2}
		end
		unitTest:assert_error(error_func, incompatibleTypeMsg("style", "table", 2))

		local error_func = function()
			Chart{subject = cell, select = {"value1", "value2"}, style = "abc"}
		end
		unitTest:assert_error(error_func, "'abc' is an invalid value for argument 'style'. It must be a string from the set ['dots', 'lines', 'steps', 'sticks'].")

		local unit = Cell{
			count = 0
		}

		local world = CellularSpace{
			xdim = 10,
			value = "aaa",
			instance = unit
		}

		local error_func = function()
			Chart{subject = world}
		end
		unitTest:assert_error(error_func, "The subject does not have at least one valid numeric attribute to be used.")

		world.msum = 5

		local error_func = function()
			Chart{subject = world, label = {"sss"}}
		end
		unitTest:assert_error(error_func, "As select is nil, it is not possible to use label.")

		local error_func = function()
			Chart{subject = world, select = "value"}
		end
		unitTest:assert_error(error_func, incompatibleTypeMsg("value", "number or function", "value"))
	end
}

