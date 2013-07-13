//
//  UIViewController+StatusBar.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 13.07.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "UIViewController+StatusBar.h"

@implementation UIViewController (StatusBar)

-(void)setStatusBarColor:(UIColor *)statusBarColor {
    UIApplication* app = [UIApplication sharedApplication];
    app.keyWindow.backgroundColor = statusBarColor;
    app.statusBarStyle = UIStatusBarStyleBlackTranslucent;
}

-(UIColor *)statusBarColor {
    UIApplication* app = [UIApplication sharedApplication];
    if (app.statusBarStyle == UIStatusBarStyleBlackTranslucent) {
        return app.keyWindow.backgroundColor;
    }
    return nil;
}

@end
