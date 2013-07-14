//
//  BBUAppDelegate.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <SCUI.h>

#import "BBUAppDelegate.h"
#import "BBUSoundListViewController.h"

@implementation BBUAppDelegate

+(void)initialize {
    [SCSoundCloud  setClientID:@"1e5d51ce1146673349fd4c7e2b352360"
                        secret:@"30053f1de703e146cc2a956a3898d468"
                   redirectURL:[NSURL URLWithString:@"scchallenge://login"]];
}

#pragma mark -

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if (BBUSystemVersionLessThan(@"7.0")) {
        [[UIBarButtonItem appearance] setTitleTextAttributes:[self titleTextAttributes] forState:UIControlStateNormal];
        [[UINavigationBar appearance] setTintColor:[UIColor sc_color]];
        [[UINavigationBar appearance] setTitleTextAttributes:[self titleTextAttributes]];
    } else {
#ifdef __IPHONE_7_0
        [[UINavigationBar appearance] setBarTintColor:[UIColor sc_color]];
#endif
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[BBUSoundListViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}
     
-(NSDictionary*)titleTextAttributes {
    return @{ NSFontAttributeName: @"Avenir" };
}

@end
