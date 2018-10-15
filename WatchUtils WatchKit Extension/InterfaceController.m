//
//  InterfaceController.m
//  WatchUtils WatchKit Extension
//
//  Created by CokePokes on 3/24/18.
//  Copyright © 2018 CokePokes. All rights reserved.
//

#import "InterfaceController.h"
#import <WatchConnectivity/WatchConnectivity.h>

@interface InterfaceController () <WCSessionDelegate>

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    if ([WCSession isSupported])
    {
        WCSession *wcSession = [WCSession defaultSession];
        wcSession.delegate = self;
        [wcSession activateSession];
    }
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)sendMessage:(NSDictionary*)arg1
{
    [[WCSession defaultSession] sendMessage:arg1
                               replyHandler:^(NSDictionary *replyHandler) {
                                   
                               }
                               errorHandler:^(NSError *error) {
                                   
                               }
     ];
}

- (IBAction)respringPressed:(id)sender
{
    NSDictionary *applicationDict = @{@"command" : @"respring"};// Create a dict of application data
    [self sendMessage:applicationDict];
}

- (IBAction)safemodePressed:(id)sender
{
    NSDictionary *applicationDict = @{@"command" : @"safemode"};// Create a dict of application data
    [self sendMessage:applicationDict];
}

- (IBAction)rebootPressed:(id)sender
{
    NSDictionary *applicationDict = @{@"command" : @"reboot"};// Create a dict of application data
    [self sendMessage:applicationDict];
}

- (void)session:(nonnull WCSession *)session activationDidCompleteWithState:(WCSessionActivationState)activationState error:(nullable NSError *)error {
    NSLog(@"activationDidCompleteWithState");
}

@end



