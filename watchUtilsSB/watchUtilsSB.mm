//
//  watchUtilsSB.mm
//  watchUtilsSB
//
//  Created by CokePokes on 3/24/18.
//  Copyright (c) 2018 CokePokes. All rights reserved.
//

// CaptainHook by Ryan Petrich
// see https://github.com/rpetrich/CaptainHook/

#if TARGET_OS_SIMULATOR
#error Do not support the simulator, please use the real iPhone Device.
#endif

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CaptainHook/CaptainHook.h"
#import "rocketbootstrap.h"
#include <notify.h> // not required; for examples only

// iOS 10
@interface SBRestartManager : NSObject
- (void)restartWithTransitionRequest:(id)arg1;
- (void)rebootWithContext:(id)arg1 ;
- (void)rebootForReason:(id)arg1 ;

@end

// iOS 10
@interface SBRestartTransitionRequest : NSObject
@property(nonatomic) int restartType;
- (id)initWithRequester:(id)arg1 reason:(id)arg2;
@property(nonatomic) _Bool wantsPersistentSnapshot;
@property(nonatomic) double delay;
@end

@interface SpringBoard : UIApplication
- (void)_relaunchSpringBoardNow;
- (void)_tearDownNow;
- (void)watchUtilsTriggeredFromName:(NSString*)arg1 userInfo:(NSDictionary*)arg2;
- (void)qwertyuiop:(id)arg1 asdfghjkl:(id)arg2;
- (void)restartManagerWillReboot:(id)arg1 ;

// iOS 10
@property(readonly, nonatomic) SBRestartManager *restartManager;
@end



CHDeclareClass(SpringBoard);
CHOptimizedMethod1(self, void, SpringBoard, applicationDidFinishLaunching, id, application)
{
    CHSuper1(SpringBoard, applicationDidFinishLaunching, application);
    
    CPDistributedMessagingCenter *c = [objc_getClass("CPDistributedMessagingCenter") centerNamed:@"com.cokepokes.watchUtilsSB"];
    rocketbootstrap_distributedmessagingcenter_apply(c);
    [c runServerOnCurrentThread];
    [c registerForMessageName:@"triggered_utils" target:self selector:@selector(watchUtilsTriggeredFromName:userInfo:)];
}
CHOptimizedMethod2(new, void, SpringBoard, watchUtilsTriggeredFromName, NSString*, arg1, userInfo, NSDictionary*, arg2)
{
    SpringBoard *springBoard = (SpringBoard *)[objc_getClass("UIApplication") sharedApplication];
    if ([arg2[@"command"] isEqualToString:@"respring"]){
        SBRestartTransitionRequest *request = [[objc_getClass("SBRestartTransitionRequest") alloc] initWithRequester:@"WatchUtils" reason:@"respring_triggered"];
        request.delay = 0.1f;
        [springBoard.restartManager restartWithTransitionRequest:request];
    }else if ([arg2[@"command"] isEqualToString:@"safemode"]) {
        [(SpringBoard*)[objc_getClass("UIApplication") sharedApplication] performSelector:@selector(qwertyuiop:asdfghjkl:)
                                                                               withObject:nil
                                                                               afterDelay:0.0];
    }else if ([arg2[@"command"] isEqualToString:@"reboot"]) {
        [springBoard.restartManager rebootForReason:0];
    }
}

CHConstructor // code block that runs immediately upon load
{
	@autoreleasepool
	{
        CHLoadLateClass(SpringBoard);
        CHHook1(SpringBoard, applicationDidFinishLaunching);
        CHHook2(SpringBoard, watchUtilsTriggeredFromName, userInfo);
	}
}
