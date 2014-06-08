//
//  TDAppDelegate.m
//  TestDataApplication
//
//  Created by Roman Filippov on 05.05.14.
//  Copyright (c) 2014 Roman Filippov. All rights reserved.
//

#import "TDAppDelegate.h"
#import "povemdct/PVManager.h"
#import "povemdct/PVCaptureManager.h"


@interface TDAppDelegate ()

@property (retain, nonatomic) NSDictionary *myDevice;

@end

@implementation TDAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"%lu",sizeof(uint32_t));
    [[PVManager sharedManager] startClientSide:(id)self];
}

- (void)PVManager:(PVManager*)manager didFoundDevice:(NSDictionary*)device withCapabilities:(NSString*)capabilities
{
    if ([capabilities rangeOfString:@"gyro"].location != NSNotFound)
    {
        [manager connectWithDevice:device];
    }
}

- (void)PVManager:(PVManager*)manager didEstablishedConnectionWithDevice:(NSDictionary*)device withCapabilities:(NSString*)capabilities
{
    self.myDevice = device;
}

- (void) appendStringToTextView:(NSString *)str
{
    [self.mainTextView setString:[self.mainTextView.string stringByAppendingString:str]];
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedMotionData:(PVMotionData*)mdata fromDevice:(NSDictionary*)device
{
    NSString *res = [NSString stringWithFormat:@"%f/%f/%f\n",mdata.gravity.x, mdata.gravity.y, mdata.gravity.z];
    [self appendStringToTextView:res];
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedGyroscopeData:(PVGyroData*)gdata fromDevice:(NSDictionary*)device
{
    NSString *res = [NSString stringWithFormat:@"%f/%f/%f",gdata.rotationRate.x,gdata.rotationRate.y,gdata.rotationRate.z];
    [self appendStringToTextView:res];
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedAccelerometerData:(PVAccelerometerData*)accdata fromDevice:(NSDictionary*)device
{
    NSString *res = [NSString stringWithFormat:@"%f/%f/%f",accdata.acceleration.x,accdata.acceleration.y,accdata.acceleration.z];
    [self appendStringToTextView:res];
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didReceivedTouchAtPosition:(CGPoint)touchPosition fromDevice:(NSDictionary*)device
{
    [self appendStringToTextView:NSStringFromPoint(touchPosition)];
}

- (void)PVCaptureManager:(PVCaptureManager*)manager didRecievedFaceCaptureAtRect:(CGRect)captureRect fromDevice:(NSDictionary*)device
{
    [self appendStringToTextView:NSStringFromRect(captureRect)];
}

- (IBAction)gyroBtnPressed:(id)sender
{
    if (((NSButton*)sender).tag == 1)
    {
        [[PVCaptureManager sharedManager] subscribeToGyroEvents:(id)self forDevice:self.myDevice];
    } else
    {
        [[PVCaptureManager sharedManager] unsubscribeFromGyroEvents:(id)self forDevice:self.myDevice];
    }
}

- (IBAction)acclBtnPressed:(id)sender
{
    if (((NSButton*)sender).tag == 1)
    {
        [[PVCaptureManager sharedManager] subscribeToAccelerometerEvents:(id)self forDevice:self.myDevice];
    } else
    {
        [[PVCaptureManager sharedManager] unsubscribeFromAccelerometerEvents:(id)self forDevice:self.myDevice];
    }
}

- (IBAction)dmBtnPressed:(id)sender
{
    if (((NSButton*)sender).tag == 1)
    {
        [[PVCaptureManager sharedManager] subscribeToMotionEvents:(id)self forDevice:self.myDevice];
    } else
    {
        [[PVCaptureManager sharedManager] unsubscribeFromMotionEvents:(id)self forDevice:self.myDevice];
    }
}

- (IBAction)cameraBtnPressed:(id)sender
{
    if (((NSButton*)sender).tag == 1)
    {
        [[PVCaptureManager sharedManager] subscribeToCameraEvents:(id)self forDevice:self.myDevice];
    } else
    {
        [[PVCaptureManager sharedManager] unsubscribeFromCameraEvents:(id)self forDevice:self.myDevice];
    }
}

- (IBAction)touchBtnPressed:(id)sender
{
    if (((NSButton*)sender).tag == 1)
    {
        [[PVCaptureManager sharedManager] subscribeToTouchEvents:(id)self forDevice:self.myDevice];
    } else
    {
        [[PVCaptureManager sharedManager] unsubscribeFromTouchEvents:(id)self forDevice:self.myDevice];
    }
}

@end
