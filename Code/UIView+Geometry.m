//
//  UIView+Geometry.m
//  SoundCloudChallenge
//
//  Created by Boris Bügling on 26.06.13.
//  Copyright (c) 2013 Boris Bügling. All rights reserved.
//

#import "UIView+Geometry.h"

@implementation UIView (Geometry)

-(CGPoint)origin {
    return self.frame.origin;
}

-(CGSize)size {
    return self.frame.size;
}

-(CGFloat)x {
    return self.frame.origin.x;
}

-(CGFloat)y {
    return self.frame.origin.y;
}

-(CGFloat)width {
    return self.frame.size.width;
}

-(CGFloat)height {
    return self.frame.size.height;
}

#pragma mark -

-(void)setOrigin:(CGPoint)origin {
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

-(void)setSize:(CGSize)size {
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

-(void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

-(void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

-(void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

-(void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

@end
