//
//  PVGyroData.h
//  povemdct
//
//  Created by Roman Filippov on 06.05.14.
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
} PVRotationRate;

@interface PVGyroData : NSObject <NSCoding>

@property (assign, nonatomic) PVRotationRate rotationRate;

#if TARGET_OS_IPHONE
    + (id) gyroDataWithData:(CMGyroData*)gdata;
#endif

@end
