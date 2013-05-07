//
//  ZYFolders.h
//  ZYFolders
//
//  Created by zhiyu on 13-5-6.
//  Copyright (c) 2013年 Zhiyu. All rights reserved.
//

#import <Foundation/Foundation.h>

enum ZYFoldersDirection {
    ZYFoldersDirectionUp = 0,
    ZYFoldersDirectionDown = 1
};
typedef NSInteger ZYFoldersDirection;


@interface ZYFolders : NSObject

@property(nonatomic, retain) UIControl *topView;
@property(nonatomic, retain) UIControl *bottomView;
@property(nonatomic, retain) UIView *contentView;
@property(nonatomic, retain) UIView *containerView;
@property(nonatomic, retain) UIColor *strokeColor;
@property(nonatomic, retain) UIColor *fillColor;
@property(nonatomic) CGPoint positon;
@property(nonatomic) ZYFoldersDirection direction;
@property(nonatomic) float triWidth;
@property(nonatomic) float triHeight;

-(void)open;
-(void)close;

@end

