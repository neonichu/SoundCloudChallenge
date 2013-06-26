//
//  UIAlertView+BBUAdditions.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "UIAlertView+BBUAdditions.h"

@implementation UIAlertView (BBUAdditions)

+(UIAlertView*)bbu_showAlertWithError:(NSError*)error {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription
                                                    message:error.localizedRecoverySuggestion
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
    return alert;
}

@end
