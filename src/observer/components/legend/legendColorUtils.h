/************************************************************************************
TerraLib - a library for developing GIS applications.
Copyright (C) 2001-2007 INPE and Tecgraf/PUC-Rio.

This code is part of the TerraLib library.
This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

You should have received a copy of the GNU Lesser General Public
License along with this library.

The authors reassure the license terms regarding the warranties.
They specifically disclaim any warranties, including, but not limited to,
the implied warranties of merchantability and fitness for a particular purpose.
The library provided hereunder is on an "as is" basis, and the authors have no
obligation to provide maintenance, support, updates, enhancements, or modifications.
In no event shall INPE and Tecgraf / PUC-Rio be held liable to any party for direct,
indirect, special, incidental, or consequential damages arising out of the use
of this library and its documentation.
*************************************************************************************/
/*! \file legendColorUtils.h
    \brief This file contains functions to manipulate a structure representing a color
*/
#ifndef  __TERRALIB_INTERNAL_COLORUTILS_H
#define  __TERRALIB_INTERNAL_COLORUTILS_H

#include <iostream>

#include <QString>
#include <QByteArray>
#include <QDataStream>

#define ROUND(__val) \
    ((__val) >= (0.0) ? ((int)((__val) + 0.5)) : ((int)((__val) - 0.5))) ;

#if ! defined (TME_OBSERVER_CLIENT_MODE) && ! defined (TME_NO_TERRALIB)

#include <TeVisual.h>
#include <TeUtils.h>

#else

//! A structure for supporting a color definition
struct TeColor
{
    //! Red component
    int red_;

    //! Green component
    int green_;

    //! Blue component
    int blue_;

    //! Color name
    std::string name_;

    //! Empty constructor
    TeColor () : red_(0), green_(0), blue_(0), name_("") {}

    //! Constructor with parameters
    TeColor (int r, int g, int b, const std::string& name="")
    	: red_(r), green_(g), blue_(b), name_(name) {}

    //! Set parameters of colors
    void init (int r, int g, int b, const std::string& name="")
    {
    	red_ = r, green_ = g, blue_ = b;name_ = name;
    }

    //! Returns TRUE if color1 is equal to color2 or FALSE if they are different.
    bool operator== (const TeColor& color)
    {
        return (red_ == color.red_ && green_ == color.green_ && blue_ == color.blue_);
    }

    //! Assignment operator
    TeColor& operator= (const TeColor& color)
    {
        if (this != &color)
        {
            red_ = color.red_;
            green_ = color.green_;
            blue_ = color.blue_;
            name_ = color.name_;
        }
        return *this;
    }
};
#endif

void rgb2Hsv(const TeColor& c, int& h, int& s, int& v);
void RGBtoHSV(const double& r, const double& g, const double& b,
		double& h, double& s, double& v);
void hsv2Rgb(TeColor& c, const int& h, const int& s, const int& v);
void HSVtoRGB(double& r, double& g, double& b, const double& h,
		const double& s, const double& v);

struct ColorBar {
    TeColor cor_;
    int		h_;
    int		s_;
    int		v_;
    double	distance_;

    void color(const TeColor& c) {cor_ = c; rgb2Hsv(cor_, h_, s_, v_);}

    ColorBar& operator= (const ColorBar& cb)
    {
        cor_ = cb.cor_;
        h_ = cb.h_;
        s_ = cb.s_;
        v_ = cb.v_;
        distance_ = cb.distance_;

        return *this;
    }

    bool operator<= (const ColorBar& cb) const
    {
        return (distance_ <= cb.distance_);
    }

    bool operator< (const ColorBar& cb) const
    {
        return (distance_ < cb.distance_);
    }

    QString toString()
    {
        QString r = QString("rgb: (%1, %2, %3); hsv: (%4, %5, %6); distance: %7;")
                .arg(cor_.red_).arg(cor_.green_).arg(cor_.blue_)
                .arg(h_).arg(s_).arg(v_).arg(distance_);
        return r;
    }

    friend QDataStream & operator <<(QDataStream &out, const ColorBar &cb)
    {
        out << (qint8)cb.h_ << (qint8)cb.s_ << (qint8)cb.v_;
        out << cb.distance_;

        out << (qint8)cb.cor_.red_ << (qint8)cb.cor_.green_ << (qint8)cb.cor_.blue_;
        out << QByteArray(cb.cor_.name_.c_str());

        return out;
    }

    friend QDataStream & operator >>(QDataStream &in, ColorBar &cb)
    {
        qint8 h, s, v, r, g, b;
        double distance;
        QByteArray name;

        in >> h >> s >> v;
        in >> distance;

        in >> r >> g >> b;
        in >> name;

        cb.h_ = (int)h;
        cb.s_ = (int)s;
        cb.v_ = (int)v;

        cb.cor_.init(r, g, b, name.constData());

        return in;
    }
};

#include <vector>
#include <string>
#include <map>

//! Generates a graduated color scale following a sequence of basic colors
/*!
        The possible basic colors are "RED", "GREEN", "BLUE", "YELLOW", "CYAN", "MAGENTA", "GRAY" and  "BLACK"
        \param ramps	vector with the sequence color ramps used to build the scale
        \param nc		desired number of colors on the scale
        \param colors	resulting color scale
        \returns true if color scale was successfully generated and false otherwise
*/
bool getColors(std::vector<std::string>& ramps, int nc, std::vector<TeColor>& colors);
std::vector<TeColor> getColors(TeColor cfrom, TeColor cto, int nc);
std::vector<TeColor> getColors(std::vector<ColorBar>& iVec, int ncores);
std::string getColors(std::vector<ColorBar>& aVec,
		std::vector<ColorBar>& bVec, int groupingMode);
void generateColorBarMap(std::vector<ColorBar>& inputColorVec,
		int ncores, std::map<int, std::vector<TeColor> >& colorMap);
std::vector<ColorBar> getColorBarVector(std::string& scores, const bool& first);
//unsigned int  TeReadColorRampTextFile(const string& fileName, map<string, string>& colorRamps);

#endif

