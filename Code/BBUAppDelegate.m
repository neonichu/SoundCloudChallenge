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

+ (void)initialize;
{
    [SCSoundCloud  setClientID:@"1e5d51ce1146673349fd4c7e2b352360"
                        secret:@"30053f1de703e146cc2a956a3898d468"
                   redirectURL:[NSURL URLWithString:@"scchallenge://login"]];
}

#pragma mark -

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:232.0/255.0 green:77.0/255.0 blue:37.0/255.0 alpha:1.0]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[BBUSoundListViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
