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
-- indirect, special, incidental, or consequential damages arising out of the use
-- of this library and its documentation.
--
-- Authors: Pedro R. Andrade (pedro.andrade@inpe.br)
-------------------------------------------------------------------------------------------

return{
	getConfig = function(unitTest)
		local cf
		pcall(function() cf = getConfig() end)

		if not cf then
			print([[
===============================================================
Error: The environment was not correctly configured to execute
database tests. Please create file 'config.lua' in the current 
directory and set the database access variables. For example:

user = "root"
password = ""
host = "localhost"
port = 3306
dbType = "mysql"
===============================================================]])
			os.exit()
		else
			unitTest:assert_not_nil(cf.dbType)
			unitTest:assert_not_nil(cf.password)
		end
	end
}

