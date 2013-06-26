//
//  UIAlertView+BBUAdditions.h
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (BBUAdditions)

+(UIAlertView*)bbu_showAlertWithError:(NSError*)error;

@end
