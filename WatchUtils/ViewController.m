//
//  ViewController.m
//  WatchUtils
//
//  Created by CokePokes on 3/24/18.
//  Copyright © 2018 CokePokes. All rights reserved.
//

#import "ViewController.h"
#import <WatchConnectivity/WatchConnectivity.h>
#import <notify.h>
#import "rocketbootstrap.h"
#import <objc/runtime.h>

@interface ViewController () <WCSessionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([WCSession isSupported])
    {
        WCSession *wcSession = [WCSession defaultSession];
        wcSession.delegate = self;
        [wcSession activateSession];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *, id> *)message replyHandler:(void(^)(NSDictionary<NSString *, id> *replyMessage))replyHandler{
    if ([message[@"command"] isEqualToString:@"respring"]) {
        NSLog(@"should respring!");
        [self respring:nil];
    } else if ([message[@"command"] isEqualToString:@"safemode"]) {
        NSLog(@"should safemode!");
        [self safemode:nil];
    } else if ([message[@"command"] isEqualToString:@"reboot"]) {
        NSLog(@"should reboot!");
        [self reboot:nil];
    }
}

- (IBAction)respring:(id)sender
{
    CPDistributedMessagingCenter *c = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.cokepokes.watchUtilsSB"];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c sendMessageName:@"triggered_utils" userInfo:@{@"command" : @"respring"}];
}
- (IBAction)safemode:(id)sender
{
    CPDistributedMessagingCenter *c = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.cokepokes.watchUtilsSB"];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c sendMessageName:@"triggered_utils" userInfo:@{@"command" : @"safemode"}];
}
- (IBAction)reboot:(id)sender
{
    CPDistributedMessagingCenter *c = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.cokepokes.watchUtilsSB"];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c sendMessageName:@"triggered_utils" userInfo:@{@"command" : @"reboot"}];
}

- (void)sessionDidBecomeInactive:(nonnull WCSession *)session {
}

- (void)sessionDidDeactivate:(nonnull WCSession *)session {
}

@end
