//
//  WPNetworkManager.h
//  WirelessPlayer
//
//  Created by Roman Filippov on 18.06.13.
//  Copyright (c) 2013 Roman Filippov. All rights reserved.
//

#define CONNECT_DATA 0
#define HEADER_DATA 1
#define CONTROL_DATA 2
#define WINSIZE_DATA 3
#define CAPTURE_DATA 4
#define GYRO_DATA 5
#define ACCL_DATA 6
#define MOTION_DATA 7
#define TOUCH_DATA 8
#define TIME_DATA 9

#define IS_SERVICE_DATA(a) (a<4)

// length of message where size of header is presented (1 number only)
#define HEADER_LENGTH_MSG_SIZE sizeof(int)

#import <Foundation/Foundation.h>
#import "PVNetworkManager.h"
#import "PVManager.h"

@class GCDAsyncSocket;
@class GCDAsyncUdpSocket;
@class PVCaptureManager;

@protocol PVNetworkManagerDelegate;

@interface PVNetworkManager : NSObject

+ (id)sharedManager;
- (void)setupSocketForApplicationType:(PVApplicationType)appType;
- (void)searchHosts;
- (void)start:(id<PVNetworkManagerDelegate>)delegate;
- (void)stop:(id<PVNetworkManagerDelegate>)delegate;
//- (void)sendData:(NSData*)data_to_send toDevice:(NSDictionary*)choosenDevice withType:(int)dataType;
- (void)sendData:(NSData*)data_to_send withType:(int)dataType toDevice:(NSDictionary*)device;
- (void)sendData:(NSData*)data_to_send;

- (void)sendHeaders:(NSDictionary*)headers;

- (void)connectWithDevice:(NSDictionary*)device;

@end


@protocol PVNetworkManagerDelegate <NSObject>

- (void)PVNetworkManager:(PVNetworkManager*)manager didFoundDevice:(NSDictionary*)device;
- (void)PVNetworkManager:(PVNetworkManager*)manager didConnectedToDevice:(NSDictionary*)device;
- (void)PVNetworkManager:(PVNetworkManager*)manager didReceivedData:(NSData*)data fromDevice:(NSDictionary*)device;
- (void)PVNetworkManager:(PVNetworkManager*)manager didReceivedData:(NSData*)data fromDevice:(NSDictionary*)device withType:(int)dataType;

@end
