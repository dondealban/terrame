/************************************************************************************
TerraME - a software platform for multiple scale spatially-explicit dynamic modeling.
Copyright (C) 2001-2017 INPE and TerraLAB/UFOP -- www.terrame.org

This code is part of the TerraME framework.
This framework is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

You should have received a copy of the GNU Lesser General Public
License along with this library.

The authors reassure the license terms regarding the warranties.
They specifically disclaim any warranties, including, but not limited to,
the implied warranties of merchantability and fitness for a particular purpose.
The framework provided hereunder is on an "as is" basis, and the authors have no
obligation to provide maintenance, support, updates, enhancements, or modifications.
In no event shall INPE and TerraLAB / UFOP be held liable to any party for direct,
indirect, special, incidental, or consequential damages arising out of the use
of this software and its documentation.
*************************************************************************************/

/*! \file luaChart.h
\brief This file definitions for the luaChart objects.
\author Pedro R. Andrade

*/
#ifndef LUACHART_H
#define LUACHART_H

#include "observerGraphic.h"
#include "reference.h"
#include "luna.h"

/**
* \brief
*  Implementation for a luaChart object.
*
*/
class luaChart : public Reference<luaChart>
{
	lua_State *luaL;

public:
	///< Data structure issued by Luna<T>
	static const char className[];

	///< Data structure issued by Luna<T>
	static Luna<luaChart>::RegType methods[];

	/// constructor
	luaChart(lua_State* L);

	int setObserver(lua_State* L);

	/// destructor
	~luaChart(void);

	int save(lua_State* L);

	int clear(lua_State* L);

	int restart(lua_State* L);

public:
	ObserverGraphic* obs;
};

#endif

