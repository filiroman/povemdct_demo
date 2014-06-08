//
//  PVGyroCaptureViewController.h
//  povemdct
//
//  Created by Roman Filippov on 21.11.13.
//  Copyright (c) 2013 Roman Filippov. All rights reserved.
//

@interface PVGyroCaptureManager : NSObject

- (BOOL)startGyroEvents;
- (BOOL)startAccelerometerEvents;
- (BOOL)startMotionEvents;

+ (PVGyroCaptureManager*)sharedManager;

- (NSString*)deviceCapabilities;

@end
