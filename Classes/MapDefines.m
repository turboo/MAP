//
//  MapDefines.m
//  Map
//
//  Created by App on 2011/10/14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "MapDefines.h"

double_t MapDistanceBetweenCoordinates (CLLocationCoordinate2D fromCoordinate, CLLocationCoordinate2D toCoordinate) {

	const double_t er = 6378137.0f; // 6378700.0f;

	double_t radlat1 = M_PI * fromCoordinate.latitude/180.0f;
	double_t radlat2 = M_PI * toCoordinate.latitude/180.0f;

	double radlong1 = M_PI * fromCoordinate.longitude/180.0f;
	double radlong2 = M_PI * toCoordinate.longitude/180.0f;

	if( radlat1 < 0 ) radlat1 = M_PI / 2 + fabs(radlat1);// south
	if( radlat1 > 0 ) radlat1 = M_PI / 2 - fabs(radlat1);// north
	if( radlong1 < 0 ) radlong1 = M_PI * 2 - fabs(radlong1);//west

	if( radlat2 < 0 ) radlat2 = M_PI / 2 + fabs(radlat2);// south
	if( radlat2 > 0 ) radlat2 = M_PI / 2 - fabs(radlat2);// north
	if( radlong2 < 0 ) radlong2 = M_PI * 2 - fabs(radlong2);// west

	//spherical coordinates x=r*cos(ag)sin(at), y=r*sin(ag)*sin(at), z=r*cos(at)
	//zero ag is up so reverse lat
	double x1 = er * cos(radlong1) * sin(radlat1);
	double y1 = er * sin(radlong1) * sin(radlat1);
	double z1 = er * cos(radlat1);

	double x2 = er * cos(radlong2) * sin(radlat2);
	double y2 = er * sin(radlong2) * sin(radlat2);
	double z2 = er * cos(radlat2);

	double d = sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));

	//side, side, side, law of cosines and arccos
	double theta = acos((er*er+er*er-d*d)/(2*er*er));
	double dist  = theta * er;

	return dist;

}
