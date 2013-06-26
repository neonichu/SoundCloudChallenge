//
//  BBUSoundListViewController.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <SCUI.h>

#import "BBUSoundListViewController.h"

@interface BBUSoundListViewController ()

@property (readonly, getter = isLoggedIn) BOOL loggedIn;
@property (readonly) NSString* loginButtonTitle;

@end

#pragma mark -

@implementation BBUSoundListViewController

- (id)init
{
    self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.loginButtonTitle
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(logInOrOut)];
        self.navigationItem.title = NSLocalizedString(@"Challenge", nil);
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.isLoggedIn) {
        [self login];
    }
}

#pragma mark - Deal with logging into SoundCloud

-(BOOL)isLoggedIn {
    return [SCSoundCloud account] != nil;
}

- (void)login;
{
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                      completionHandler:^(NSError *error){
                                                                          if (SC_CANCELED(error)) {
                                                                              NSLog(@"Canceled!");
                                                                          } else if (error) {
                                                                              [UIAlertView bbu_showAlertWithError:error];
                                                                          } else {
                                                                              NSLog(@"Done!");
                                                                          }
                                                                      }];
        
        [self presentViewController:loginViewController animated:YES completion:^{
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            
            loginViewController.view.y += 20.0;
            loginViewController.view.height -= 20.0;
        }];
    }];
}

-(NSString *)loginButtonTitle {
    return self.isLoggedIn ? NSLocalizedString(@"Logout", nil) : NSLocalizedString(@"Login", nil);
}

-(void)logInOrOut {
    // TODO: Implement logout and re-login
}

@end
