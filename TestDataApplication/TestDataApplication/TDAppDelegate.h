//
//  TDAppDelegate.h
//  TestDataApplication
//
//  Created by Roman Filippov on 05.05.14.
//  Copyright (c) 2014 Roman Filippov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TDAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (retain, nonatomic) IBOutlet NSButton *gyroSub;
@property (retain, nonatomic) IBOutlet NSButton *gyroUnsub;
@property (retain, nonatomic) IBOutlet NSButton *acclSub;
@property (retain, nonatomic) IBOutlet NSButton *acclUnsub;
@property (retain, nonatomic) IBOutlet NSButton *dmSub;
@property (retain, nonatomic) IBOutlet NSButton *dmUnsub;
@property (retain, nonatomic) IBOutlet NSButton *cameraSub;
@property (retain, nonatomic) IBOutlet NSButton *cameraUnsub;
@property (retain, nonatomic) IBOutlet NSButton *touchSub;
@property (retain, nonatomic) IBOutlet NSButton *touchUnsub;

@property (unsafe_unretained) IBOutlet NSTextView *mainTextView;


- (IBAction)gyroBtnPressed:(id)sender;
- (IBAction)acclBtnPressed:(id)sender;
- (IBAction)dmBtnPressed:(id)sender;
- (IBAction)cameraBtnPressed:(id)sender;
- (IBAction)touchBtnPressed:(id)sender;

@end
