//
//  PVManager.h
//  povemdct
//
//  Created by Roman Filippov on 13.12.13.
//  Copyright (c) 2013 Roman Filippov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    PVApplicationTypeClient = 0,
    PVApplicationTypeServer = 1,
} PVApplicationType;

@class PVCaptureManager;

@protocol PVManagerDelegate;

@interface PVManager : NSObject

@property (retain, nonatomic) PVCaptureManager *captureManager;

+ (id) sharedManager;

- (void) startClientSide:(id<PVManagerDelegate>)delegate;
- (void) startServerSize:(id<PVManagerDelegate>)delegate;		

- (void) connectWithDevice:(NSDictionary*)device;

//- (void)sendCommands:(NSDictionary*)commands;

@end


@protocol PVManagerDelegate <NSObject>

- (void)PVManager:(PVManager*)manager didFoundDevice:(NSDictionary*)device withCapabilities:(NSString*)capabilities;
- (void)PVManager:(PVManager*)manager didEstablishedConnectionWithDevice:(NSDictionary*)device withCapabilities:(NSString*)capabilities;

@end

