//
//  ViewController.m
//  ZYFolders
//
//  Created by zhiyu on 13-5-6.
//  Copyright (c) 2013年 Zhiyu. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize folders;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    
    for(int i=0;i<8;i++){
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i%4*64+(i%4+1)*13, 50+(i/4)*84, 64, 64)];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",(i+1)]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d",(i+1)]] forState:UIControlStateHighlighted];
        
        button.tag = i;
        [button addTarget:self action:@selector(openFolder:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [button release];
    }
}

-(void)openFolder:(id)sender{
    UIButton *button = (UIButton *)sender;
    int tag = button.tag;
    
    self.folders = [[ZYFolders alloc] init];
    [folders release];
    folders.containerView = self.view;
    if(tag/4==0){
        folders.positon = CGPointMake(button.frame.origin.x+32, button.frame.origin.y + 64);
        folders.direction = ZYFoldersDirectionUp;
    }else{
        folders.positon = CGPointMake(button.frame.origin.x+32, button.frame.origin.y);
        folders.direction = ZYFoldersDirectionDown;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.text  = @"Content View";
    label.textColor = [UIColor whiteColor];
    folders.contentView = label;
    [label release];
    
    [folders open];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
