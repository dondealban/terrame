--#########################################################################################
-- TerraME - a software platform for multiple scale spatially-explicit dynamic modeling.
-- Copyright (C) 2001-2014 INPE and TerraLAB/UFOP -- www.terrame.org
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
--          Rodrigo Avancini
--#########################################################################################

CellularLayer_ = {
	type_ = "CellularLayer",
	--- Create a new attribute for each cell of a CellularLayer.
	-- This attribute can be stored as a new
	-- column of a table or a new file, according to where the CellularLayer is stored.
	-- There are several strategies for filling cells according to the geometry of the
	-- input layer.
	-- @arg data.select Name of an attribute from the input data. It is only required when
	-- the selected operation needs a value associated to the geometry (average, sum, majority).
	-- It can also be an integer value representing the band of the raster to be used.
	-- If the raster has only one band then this value is optional.
	-- @arg data.layer Name of an input layer belonging to the same Project. There are
	-- several strategies available, depending on the geometry of the layer. See below:
	-- @tabular layer
	-- Geometry & Using only geometry & Using attribute of objects with some overlap &
	-- Using geometry and attribute \
	-- Points & "count", "distance", "presence" & 
	-- "average", "majority", "maximum", "minimum", "stdev", "sum" &
	-- "value" \
	-- Lines & "count", "distance", "length", "presence" &
	-- "average", "majority", "maximum", "minimum", "stdev", "sum" &
	-- "majority", "value" \
	-- Polygons & "area", "count", "distance", "presence" &
	-- "average", "majority", "maximum", "minimum", "stdev", "sum" &
	-- "average", "majority", "percentage", "value", "sum" \
	-- Raster & (none) &
	-- "average", "majority", "maximum", "minimum", "percentage", "stdev", "sum" &
	-- (none) \
	-- @arg data.operation The way to compute the attribute of each cell. See the
	-- table below:
	-- @tabular operation
	-- Operation & Description & Mandatory arguments & Optional arguments \
	-- "area" & Total overlay area between the cell and a layer of polygons. The created values
	-- will range from zero to one, indicating a percentage of coverage. & attribute, layer & \
	-- "average" & Average of an attribute of the objects that have some intersection with the
	-- cell, without taking into account their geometric properties. When using argument area, 
	-- it computes the average weighted by the proportions of the respective intersection areas.
	-- Useful to distribute atributes that represent averages, such as per capita income. 
	-- & attribute, layer, select & area, default, dummy \
	-- "count" & Number of objects that have some overlay with the cell.
	-- & attribute, layer & \
	-- "distance" & Distance to the nearest object. The distance is computed from the
	-- centroid of the cell to the closest point, line, or border of a polygon.
	-- & attribute, layer & \
	-- "length" & Total length of overlay between the cell and a layer of lines. If there is
	-- more than one line, it sums all lengths.
	-- & attribute, layer & \
	-- "majority" & More common value in the objects that have some intersection with the cell, 
	-- without taking into account their geometric properties. When using argument area, it
	-- computes the value of a given attribute that has larger coverage. & attribute, layer, select & 
	-- default, dummy \
	-- "maximum" & Maximum value of  an attribute among the objects that have some intersection with the
	-- cell, without taking into account their geometric properties. & attribute, layer, select &
	-- default, dummy \
	-- "minimum" & Minimum value of an attribute among the objects that have some intersection with
	-- the cell, without taking into account their geometric properties. & attribute, layer, select &
	-- default, dummy \
	-- "percentage" & Percentages of each value of an attribute covering the cell. It creates
	-- one attribute for each attribute value, appending the value to the attribute name. 
	-- The sum of the created values for a given cell will range from zero to one, according to
	-- the percentage of coverage.
	-- & attribute, layer, select & default, dummy \
	-- "presence" & Boolean value pointing out whether some object has an overlay with the cell.
	-- & attribute, layer & \
	-- "stdev" & Standard deviation of an attribute of the objects that have some intersection with the
	-- cell, without taking into account their geometric properties. & attribute, layer, select &
	-- default, dummy \
	-- "sum" & Sum of an attribute of the objects that have some intersection with the cell, without
	-- taking into account their geometric properties. When using argument area, it computes the sum 
	-- based on the proportions of intersection area. Useful to preserve the total sum
	-- in both layers, such as population size.
	-- & attribute, layer, select & area, default, dummy \
	-- "value" & The attribute value of the closest object. If using area, it uses the attribute
	-- value of the object with greater intersection area. & attribute, layer, select & area \
	-- @arg data.attribute The name of the new attribute to be created.
	-- @arg data.area Whether the calculation will be based on the intersection area (true), 
	-- or the weights are equal for each object with some overlap (false, default value).
	-- @arg data.dummy A value that will ignored when computing the operation, used only for
	-- raster strategies.
	-- @arg data.default A value that will be used to fill a cell whose attribute cannot be computed.
	-- For example, when there is no intersection area.
	-- @usage -- DONTRUN
	-- import("fillcell")
	--
	-- cl = CellularLayer{
	--     project = file("rondonia.tview"),
	--     layer = "cells"
	-- }
	--
	-- cl:fillCells{
	--     attribute = "distRoads",
	--     operation = "distance",
	--     layer = "roads"
	-- }
	--
	-- cl:fillCells{
	--     attribute = "population",
	--     layer = "population",
	--     operation = "sum",
	--     area = true
	-- }
	--
	-- cl:fillCells{
	--     attribute = "area2010_",
	--     operation = "percentage",
	--     layer = "cover",
	--     select = "cover2010"
	-- }
	fillCells = function(self, data)
	    verifyNamedTable(data)

	    mandatoryTableArgument(data, "operation", "string")
	    mandatoryTableArgument(data, "layer", "string")
	    mandatoryTableArgument(data, "attribute", "string")

		switch(data, "operation"):caseof{
			area = function()
	    		verifyUnnecessaryArguments(data, {"attribute", "layer", "operation"})
			end,
			average = function()
	    		mandatoryTableArgument(data, "select", "string")
				defaultTableValue(data, "area", false)
				defaultTableValue(data, "default", 0)
				defaultTableValue(data, "dummy", math.huge)

	    		verifyUnnecessaryArguments(data, {"area", "attribute", "default", "dummy", "layer", "operation", "select"})
			end,
			count = function()
	    		verifyUnnecessaryArguments(data, {"attribute", "layer", "operation"})
			end,
		}
	end
}

metaTableCellularLayer_ = {
	__index = CellularLayer_
}
	
--- A Layer of cells. It has operations to create new attributes from other layers.
-- @arg data.project A file name with the TerraView project to be used, or a Project.
-- @arg data.layer A string with the layer name to be used.
-- @usage -- DONTRUN
-- import("fillcell")
--
-- cl = CellularLayer{
--     project = file("rondonia.tview"),
--     layer = "cells"
-- }
function CellularLayer(data)
    verifyNamedTable(data)

    verifyUnnecessaryArguments(data, {"layer", "project"})

    mandatoryTableArgument(data, "project", "string")
    mandatoryTableArgument(data, "layer", "string")

	setmetatable(data, metaTableCellularLayer_)

	return data
end
