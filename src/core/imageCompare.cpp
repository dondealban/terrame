
#include "imageCompare.h"

#include <iostream>

using namespace std;

double comparePerPixel(const QString &img1, const QString &img2)
{
	QImage image1(img1);
	QImage image2(img2);

	if(image1.width() == 0 || image1.height() == 0)
		return 1;

	if(image2.width() == 0 || image2.height() == 0)
		return 1;

	if(image1.width() != image2.width() || image1.height() != image2.height())
		return 1;

	double count = 0;
	for(int i = 0; i < image1.height(); i++)
		for(int j = 0; j < image1.width(); j++)
			if(image1.pixel(j, i) != image2.pixel(j, i))
			{
				count = count + 1;
			}

	return count / (image1.width() * image1.height());
}

