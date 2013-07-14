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
#import "BBUTrackCell.h"
#import "BBUTrackSearchDataSource.h"

//#define MAKE_DEFAULT_PNG 1

@interface BBUSoundListViewController ()

@property (getter = hasCancelled) BOOL cancelled;
@property BBUTrackSearchDataSource* dataSource;
@property (readonly, getter = isLoggedIn) BOOL loggedIn;
@property (readonly) NSString* loginButtonTitle;

@end

#pragma mark -

@implementation BBUSoundListViewController

-(void)dealloc {
    [self.dataSource removeObserver:self forKeyPath:@"tracks" context:nil];
}

-(id)init {
    self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
    if (self) {
        UICollectionViewFlowLayout* layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
        layout.headerReferenceSize = CGSizeMake(self.view.width, 44.0);
        layout.itemSize = CGSizeMake(100.0, 100.0);
        
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.loginButtonTitle
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(logInOrOut)];
        self.navigationItem.title = NSLocalizedString(@"Challenge", nil);
        
#ifdef MAKE_DEFAULT_PNG
        self.navigationItem.rightBarButtonItem.enabled = NO;
#endif
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"tracks"]) {
        [self.collectionView reloadData];
        [self performSelector:@selector(startAnimating) withObject:nil afterDelay:1.0];
    }
}

-(void)populateViewAfterSuccessfulLogin {
    [MMProgressHUD showWithStatus:NSLocalizedString(@"Fetching data...", nil)];
    [MMProgressHUD sharedHUD].hud.backgroundColor = [UIColor sc_color];
    
    [self.dataSource refreshWithCompletionHandler:^(NSError *error) {
        [MMProgressHUD dismiss];
        
        if (error) {
            [UIAlertView bbu_showAlertWithError:error];
            return;
        }
    }];
}

-(void)startAnimating {
    for (BBUTrackCell* cell in self.collectionView.visibleCells) {
        [cell startAnimating];
    }
}

-(void)viewDidAppear:(BOOL)animated {
#ifdef MAKE_DEFAULT_PNG
    return;
#endif
    
    if (self.hasCancelled) {
        return;
    }
    
    if (!self.isLoggedIn) {
        [self login];
        return;
    }
    
    [self performSelector:@selector(populateViewAfterSuccessfulLogin) withObject:nil afterDelay:0.5];
}

-(void)viewDidLoad {
    self.dataSource = [[BBUTrackSearchDataSource alloc] initWithQuery:@"power core"];
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.dataSource;
    
    [self.dataSource addObserver:self forKeyPath:@"tracks" options:0 context:NULL];
}

#pragma mark - Deal with logging into SoundCloud

-(UIView*)connectToSoundCloudTitleViewFromLoginViewControllerView:(UIView*)view {
    for (int i = 0; i < 4; i++) {
        if (view.subviews.count < 1) {
            break;
        }
        view = [view.subviews lastObject];
    }
    return view;
}

-(BOOL)isLoggedIn {
    return [SCSoundCloud account] != nil;
}

- (void)login {
    [SCSoundCloud requestAccessWithPreparedAuthorizationURLHandler:^(NSURL *preparedURL){
        SCLoginViewController *loginViewController;
        
        loginViewController = [SCLoginViewController loginViewControllerWithPreparedURL:preparedURL
                                                                      completionHandler:^(NSError *error) {
                                                                          if (BBUSystemVersionLessThan(@"7.0")) {
                                                                              self.statusBarColor = [UIColor sc_color];
                                                                          }
                                                                          
                                                                          if (SC_CANCELED(error)) {
                                                                              self.cancelled = YES;
                                                                          } else if (error) {
                                                                              [UIAlertView bbu_showAlertWithError:error];
                                                                          } else {
                                                                              [self populateViewAfterSuccessfulLogin];
                                                                              [self refreshLoginButton];
                                                                          }
                                                                      }];
        
        [self presentViewController:loginViewController animated:YES completion:^{
            if (BBUSystemVersionLessThan(@"7.0")) {
                // Adjust status bar to match SCConnectToSoundCloudTitleView's color
                UIView* titleView = [self connectToSoundCloudTitleViewFromLoginViewControllerView:loginViewController.view];
                self.statusBarColor = titleView.backgroundColor;
                return;
            }
            
#ifdef __IPHONE_7_0
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            
            loginViewController.view.y += 20.0;
            loginViewController.view.height -= 20.0;
#endif
        }];
    }];
}

-(NSString *)loginButtonTitle {
    return self.isLoggedIn ? NSLocalizedString(@"Logout", nil) : NSLocalizedString(@"Login", nil);
}

-(void)logInOrOut {
    if (self.isLoggedIn) {
        [SCSoundCloud removeAccess];
        
        [self.dataSource clear];
        [self.collectionView reloadData];
        
        [self refreshLoginButton];
    } else {
        [self login];
    }
}

-(void)refreshLoginButton {
    self.navigationItem.rightBarButtonItem.title = self.loginButtonTitle;
}

@end
