//
//  PVAcceletometerData.h
//  povemdct
//
//  Created by Roman Filippov on 08.05.14.
//  Copyright (c) 2014 Roman Filippov. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
    #import <CoreMotion/CoreMotion.h>
#endif

typedef struct {
	double x;
	double y;
	double z;
} PVAcceleration;


@interface PVAccelerometerData : NSObject <NSCoding>

@property (assign, nonatomic) PVAcceleration acceleration;

#if TARGET_OS_IPHONE
    + (id) accelerometerDataWithData:(CMAccelerometerData*)gdata;
#endif

@end
