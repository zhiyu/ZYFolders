//
//  ZYFolders.m
//  ZYFolders
//
//  Created by zhiyu on 13-5-6.
//  Copyright (c) 2013年 Zhiyu. All rights reserved.
//

#import "ZYFolders.h"
#import <QuartzCore/QuartzCore.h>

@interface ZYFolders()

@property(nonatomic) float y;
@property(nonatomic, retain) UIView *bgView;

@end

@implementation ZYFolders

@synthesize topView;
@synthesize bottomView;
@synthesize containerView;
@synthesize contentView;
@synthesize strokeColor;
@synthesize fillColor;
@synthesize positon;
@synthesize direction;
@synthesize triWidth;
@synthesize triHeight;

- (id)init {
    self = [super init];
    if (self) {
        self.triWidth = 16;
        self.triHeight = 10;
        
        self.strokeColor = [UIColor colorWithWhite:1.f alpha:0.8];
        self.fillColor = [UIColor blackColor];
    }
    return self;
}

- (void)open {
    
    if(self.direction == ZYFoldersDirectionUp){
        self.positon = CGPointMake(self.positon.x, self.positon.y + self.triHeight);
    }else{
        self.positon = CGPointMake(self.positon.x, self.positon.y - self.triHeight);
    }
    
    CGRect rect1 = CGRectMake(0, 0, self.containerView.bounds.size.width, self.positon.y);
    CGRect rect2 = CGRectMake(0, self.positon.y, self.containerView.bounds.size.width, self.containerView.bounds.size.height-self.positon.y);
    
    self.y = self.positon.y;
    
    self.topView = [[UIControl alloc] initWithFrame:rect1];
    [topView release];
    self.bottomView = [[UIControl alloc] initWithFrame:rect2];
    [bottomView release];
    
    CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat width1  = rect1.size.width;
    CGFloat height1 = rect1.size.height;
    CGPoint origin1 = rect1.origin;
    CGFloat width2  = rect2.size.width;
    CGFloat height2 = rect2.size.height;
    CGPoint origin2 = rect2.origin;
    
    rect1 = CGRectMake(origin1.x*scale, origin1.y*scale, width1*scale, height1*scale);
    rect2 = CGRectMake(origin2.x*scale, origin2.y*scale, width2*scale, height2*scale);
    
    UIGraphicsBeginImageContextWithOptions(self.containerView.bounds.size, NO, scale);
    [self.containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef1 = CGImageCreateWithImageInRect([screenshot CGImage], rect1);
    CGImageRef imageRef2 = CGImageCreateWithImageInRect([screenshot CGImage], rect2);
    
    topView.layer.contents = (id)imageRef1;
    bottomView.layer.contents = (id)imageRef2;
    
    [topView addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    
    CGImageRelease(imageRef1);
    CGImageRelease(imageRef2);

    if(self.direction == ZYFoldersDirectionUp){
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.positon.y + 0.5, self.containerView.bounds.size.width, self.contentView.bounds.size.height)];
    }else{
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.positon.y - self.contentView.bounds.size.height + 0.5, self.containerView.bounds.size.width, self.contentView.bounds.size.height)];
    }
    
    CAShapeLayer *path = [CAShapeLayer layer];
    path.frame = self.bgView.bounds;
    path.strokeColor = strokeColor.CGColor;
    path.fillColor = fillColor.CGColor;
    path.path = [self path:self.bgView.bounds.size position:self.positon direction:self.direction].CGPath;
    
    [self.bgView.layer addSublayer:path];
    [self.bgView addSubview:self.contentView];

    if(self.direction == ZYFoldersDirectionUp){
        [self.containerView addSubview:topView];
        [self.containerView addSubview:self.bgView];
        [self.containerView addSubview:bottomView];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        bottomView.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y+self.bgView.bounds.size.height, bottomView.frame.size.width, bottomView.frame.size.height);
        
        [UIView commitAnimations];
    }else{
        [self.containerView addSubview:bottomView];
        [self.containerView addSubview:self.bgView];
        [self.containerView addSubview:topView];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3f];
        topView.frame = CGRectMake(topView.frame.origin.x, topView.frame.origin.y - self.bgView.bounds.size.height, topView.frame.size.width, topView.frame.size.height);
        [UIView commitAnimations];
    }
}


- (void)close {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didStop)];
    
    if(self.direction == ZYFoldersDirectionUp){
        bottomView.frame = CGRectMake(bottomView.frame.origin.x, self.y, bottomView.frame.size.width, bottomView.frame.size.height);
    }else{
        topView.frame = CGRectMake(topView.frame.origin.x, 0, topView.frame.size.width, topView.frame.size.height);
    }
    
    [UIView commitAnimations];
}

-(void)didStop{
    [self.bgView removeFromSuperview];
    [topView removeFromSuperview];
    [bottomView removeFromSuperview];
}

- (UIBezierPath *)path:(CGSize)size position:(CGPoint)position direction:(int) direct{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:direct==1 ? CGPointMake(-1, size.height-1) : CGPointMake(-1, 0)];
    
    if (direct==1) {
        [path addLineToPoint:CGPointMake(position.x - triWidth/2, size.height-1)];
        [path addLineToPoint:CGPointMake(position.x, size.height + self.triHeight)];
        [path addLineToPoint:CGPointMake(position.x + triWidth/2, size.height-1)];
        [path addLineToPoint:CGPointMake(size.width+1, size.height-1)];
        [path addLineToPoint:CGPointMake(size.width+1, 0)];
        [path addLineToPoint:CGPointMake(-1, 0)];
    } else {
        [path addLineToPoint:CGPointMake(position.x - triWidth/2, 0)];
        [path addLineToPoint:CGPointMake(position.x, 0 - self.triHeight)];
        [path addLineToPoint:CGPointMake(position.x + triWidth/2, 0)];
        [path addLineToPoint:CGPointMake(size.width+1, 0)];
        [path addLineToPoint:CGPointMake(size.width+1, size.height-1)];
        [path addLineToPoint:CGPointMake(-1, size.height-1)];
    }
    [path closePath];
    return path;
}

@end
