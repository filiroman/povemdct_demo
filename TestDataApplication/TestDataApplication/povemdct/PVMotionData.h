//
//  PVMotionData.h
//  povemdct
//
//  Created by Roman Filippov on 08.05.14.
//  Copyright (c) 2014 Roman Filippov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVGyroData.h"
#import "PVAccelerometerData.h"
#import "PVAttitude.h"
#if TARGET_OS_IPHONE
    #import <CoreMotion/CoreMotion.h>
#endif

/*
 * PVMagneticFieldCalibrationAccuracy
 *
 *  Discussion:
 *        PVMagneticFieldCalibrationAccuracy indicates the calibration
 *        accuracy of a magnetic field estimate.
 *
 */
typedef enum {
	PVMagneticFieldCalibrationAccuracyUncalibrated = -1,
	PVMagneticFieldCalibrationAccuracyLow,
	PVMagneticFieldCalibrationAccuracyMedium,
	PVMagneticFieldCalibrationAccuracyHigh
} PVMagneticFieldCalibrationAccuracy;

/*
 *  PVCalibratedMagneticField
 *
 *  Discussion:
 *    A structure containing 3-axis calibrated magnetic field data
 *    and an estimate of the accuracy of the calibration
 *
 *  Fields:
 *    field:
 *      The 3-axis calibrated magnetic field vector.
 *    accuracy:
 *      An estimate of the calibration accuracy.
 */
typedef struct {
    //PVMagneticField field;
    PVMagneticFieldCalibrationAccuracy accuracy;
} PVCalibratedMagneticField;

@interface PVMotionData : NSObject <NSCoding>

@property (readonly, nonatomic) PVRotationRate rotationRate;
@property (readonly, nonatomic) PVAcceleration userAcceleration;
@property (readonly, nonatomic) PVAcceleration gravity;
@property (readonly, nonatomic) PVCalibratedMagneticField magneticField;
@property (readonly, retain, nonatomic) PVAttitude* attitude;

#if TARGET_OS_IPHONE
    + (id) motionDataWithData:(CMDeviceMotion*)gdata;
#endif

@end
