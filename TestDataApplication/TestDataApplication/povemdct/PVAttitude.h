//
//  PVAttitude.h
//  povemdct
//
//  Created by Roman Filippov on 10.05.14.
//  Copyright (c) 2014 Roman Filippov. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * PVRotationMatrix
 *
 * Discussion:
 *
 * Wrapper for CMRotationMatrix
 *
 */
typedef struct
{
	double m11, m12, m13;
	double m21, m22, m23;
	double m31, m32, m33;
    
} PVRotationMatrix;

/*
 * PVQuaternion
 *
 * Discussion:
 *
 * Wrapper for CMQuaternion
 *
 */
typedef struct
{
	double x, y, z, w;
} PVQuaternion;

/*
 * PVAttitudeReferenceFrame
 *
 * Discussion:
 *
 * Wrapper for CMAttitudeReferenceFrame
 *
 */
typedef enum {
	PVAttitudeReferenceFrameXArbitraryZVertical = 1 << 0,
	PVAttitudeReferenceFrameXArbitraryCorrectedZVertical = 1 << 1,
	PVAttitudeReferenceFrameXMagneticNorthZVertical = 1 << 2,
	PVAttitudeReferenceFrameXTrueNorthZVertical = 1 << 3
} PVAttitudeReferenceFrame;


@interface PVAttitude : NSObject <NSCoding>

/*
 *  roll
 *
 *  Discussion:
 *    Returns the roll of the device in radians.
 *
 */
@property(readonly, nonatomic) double roll;

/*
 *  pitch
 *
 *  Discussion:
 *    Returns the pitch of the device in radians.
 *
 */
@property(readonly, nonatomic) double pitch;

/*
 *  yaw
 *
 *  Discussion:
 *    Returns the yaw of the device in radians.
 *
 */
@property(readonly, nonatomic) double yaw;

/*
 *  rotationMatrix
 *
 *  Discussion:
 *    Returns a rotation matrix representing the device's attitude.
 *
 */
@property(readonly, nonatomic) PVRotationMatrix rotationMatrix;

/*
 *  quaternion
 *
 *  Discussion:
 *    Returns a quaternion representing the device's attitude.
 *
 */
@property(readonly, nonatomic) PVQuaternion quaternion;


- (id)initWithRoll:(double)roll pitch:(double)pitch yaw:(double)yaw rotationMatrix:(PVRotationMatrix)rmat quartenion:(PVQuaternion)quartenion;


@end
