//
//  BBUSoundListViewController.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import <MMProgressHUD/MMProgressHUD.h>
#import <SCUI.h>

#import "BBUSoundListViewController.h"
#import "BBUTrackSearchDataSource.h"

@interface BBUSoundListViewController ()

@property BBUTrackSearchDataSource* dataSource;
@property (readonly, getter = isLoggedIn) BOOL loggedIn;
@property (readonly) NSString* loginButtonTitle;

@end

#pragma mark -

@implementation BBUSoundListViewController

- (id)init
{
    self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    if (self) {
        UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
        layout.itemSize = CGSizeMake(100.0, 100.0);
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.loginButtonTitle
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(logInOrOut)];
        self.navigationItem.title = NSLocalizedString(@"Challenge", nil);
    }
    return self;
}

- (void)populateViewAfterSuccessfulLogin {
    [MMProgressHUD showWithStatus:NSLocalizedString(@"Fetching data...", nil)];
    [MMProgressHUD sharedHUD].hud.backgroundColor = [UIColor sc_color];
    
    [self.dataSource refreshWithCompletionHandler:^(NSError *error) {
        [MMProgressHUD dismiss];
        
        if (error) {
            [UIAlertView bbu_showAlertWithError:error];
            return;
        }
        
        [self.collectionView reloadData];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.isLoggedIn) {
        [self login];
        return;
    }
    
    // FIXME: There is a timing problem when accessing the API to quickly after app launch
    [self performSelector:@selector(populateViewAfterSuccessfulLogin) withObject:nil afterDelay:2.0];
}

-(void)viewDidLoad {
    self.dataSource = [[BBUTrackSearchDataSource alloc] initWithQuery:@"power core"];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.dataSource;
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
