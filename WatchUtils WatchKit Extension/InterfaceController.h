//
//  InterfaceController.h
//  WatchUtils WatchKit Extension
//
//  Created by CokePokes on 3/24/18.
//  Copyright © 2018 CokePokes. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface InterfaceController : WKInterfaceController

- (IBAction)respringPressed:(id)sender;
- (IBAction)rebootPressed:(id)sender;
- (IBAction)safemodePressed:(id)sender;

@end
