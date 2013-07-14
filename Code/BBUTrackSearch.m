//
//  BBUTrackSearch.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 14.07.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "BBUTrackSearch.h"

@interface BBUTrackSearch ()

@property UISearchBar* searchBar;

@end

#pragma mark -

@implementation BBUTrackSearch

-(id<UISearchBarDelegate>)delegate {
    return self.searchBar.delegate;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:frame];
        self.searchBar.height -= 2.0;
        [self addSubview:self.searchBar];
        
        if (BBUSystemVersionLessThan(@"7.0")) {
            self.searchBar.tintColor = [UIColor sc_color];
        } else {
#ifdef __IPHONE_7_0
            self.searchBar.barTintColor = [UIColor sc_color];
#endif
        }
    }
    return self;
}

-(void)setDelegate:(id<UISearchBarDelegate>)delegate {
    self.searchBar.delegate = delegate;
}

-(void)setText:(NSString *)text {
    self.searchBar.text = text;
}

-(NSString *)text {
    return self.searchBar.text;
}

@end
