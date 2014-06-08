//
//  PVCaptureManager.h
//  povemdct
//
//  Created by Roman Filippov on 25.10.13.
//  Copyright (c) 2013 Roman Filippov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVNetworkManager.h"
#import "PVManager.h"
#import "PVGyroData.h"
#import "PVAccelerometerData.h"
#import "PVMotionData.h"

#if TARGET_OS_IPHONE
    #import <CoreMotion/CoreMotion.h>
    #import <UIKit/UIKit.h>
#endif

@protocol PVCaptureManagerDelegate;
@protocol PVCaptureManagerCameraDelegate;
@protocol PVCaptureManagerGyroDelegate;
@protocol PVCaptureManagerTouchDelegate;

@interface PVCaptureManager : NSObject

@property (nonatomic, assign) PVApplicationType appType;

+ (id)sharedManager;
- (void)sendFaceCaptureWithRect:(CGRect)captureRect;
- (void)sendWindowSize:(CGSize)wsize;
#if TARGET_OS_IPHONE
    - (void)sendGyroData:(CMGyroData*)gdata;
    - (void)sendAccelerometerData:(CMAccelerometerData*)accdata;
    - (void)sendMotionData:(CMDeviceMotion*)mdata;
#endif
- (void)sendTouchPoint:(CGPoint)touchPoint;
- (void)sendData:(NSData*)data withType:(int)dataType;

- (NSString*)deviceCapabilities;

@end

@interface PVCaptureManager (SubscribeMethods)

- (void)subscribeToAllEvents:(id<PVCaptureManagerCameraDelegate, PVCaptureManagerGyroDelegate>) delegate forDevice:(NSDictionary*)device;
- (void)subscribeToCameraEvents:(id<PVCaptureManagerCameraDelegate>) delegate forDevice:(NSDictionary*)device;
- (void)subscribeToGyroEvents:(id<PVCaptureManagerGyroDelegate>) delegate forDevice:(NSDictionary*)device;
- (void)subscribeToAccelerometerEvents:(id<PVCaptureManagerGyroDelegate>) delegate forDevice:(NSDictionary*)device;
- (void)subscribeToMotionEvents:(id<PVCaptureManagerGyroDelegate>) delegate forDevice:(NSDictionary*)device;
- (void)subscribeToTouchEvents:(id<PVCaptureManagerTouchDelegate>) delegate forDevice:(NSDictionary*)device;

- (void)unsubscribeFromCameraEvents:(id<PVCaptureManagerCameraDelegate>) delegate forDevice:(NSDictionary*)device;
- (void)unsubscribeFromGyroEvents:(id<PVCaptureManagerGyroDelegate>) delegate forDevice:(NSDictionary*)device;
- (void)unsubscribeFromAccelerometerEvents:(id<PVCaptureManagerGyroDelegate>) delegate forDevice:(NSDictionary*)device;
- (void)unsubscribeFromMotionEvents:(id<PVCaptureManagerGyroDelegate>) delegate forDevice:(NSDictionary*)device;
- (void)unsubscribeFromTouchEvents:(id<PVCaptureManagerTouchDelegate>) delegate forDevice:(NSDictionary*)device;

@end

@protocol PVCaptureManagerDelegate <NSObject>

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedData:(NSData*)data fromDevice:(NSDictionary*)device;
- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedWindowSize:(CGSize)winSize fromDevice:(NSDictionary*)device;

@end

@protocol PVCaptureManagerTouchDelegate <NSObject>

- (void)PVCaptureManager:(PVCaptureManager*)manager didReceivedTouchAtPosition:(CGPoint)touchPosition fromDevice:(NSDictionary*)device;

@end

@protocol PVCaptureManagerCameraDelegate <NSObject>

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedFaceCaptureAtRect:(CGRect)captureRect fromDevice:(NSDictionary*)device;

@end

@protocol PVCaptureManagerGyroDelegate <NSObject>

@optional

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedGyroscopeData:(PVGyroData*)gdata fromDevice:(NSDictionary*)device;
- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedAccelerometerData:(PVAccelerometerData*)accdata fromDevice:(NSDictionary*)device;
- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedMotionData:(PVMotionData*)mdata fromDevice:(NSDictionary*)device;


@end
