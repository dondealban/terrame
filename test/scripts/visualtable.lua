local world = Cell{
	count = 0,
	mcount = function(self)
		return self.count + 1
	end
}

local c1 = VisualTable{target = world}

local world = Agent{
	count = 0,
	mcount = function(self)
		return self.count + 1
	end
}

local c1 = VisualTable{target = world}

local c1 = VisualTable{
	target = world,
	select = {"mcount"}
}

local soc = Society{
	instance = world,
	quantity = 3
}

local c1 = VisualTable{target = soc}
local c1 = VisualTable{target = soc, select = "#"}

local soc = Society{
	instance = Agent{},
	quantity = 3,
	total = 10
}

local c1 = VisualTable{target = soc}

local world = CellularSpace{
	xdim = 10,
	count = 0,
	mcount = function(self)
		return self.count + 1
	end
}

local c1 = VisualTable{target = world}
local c1 = VisualTable{target = world, select = "mcount"}

clean()

