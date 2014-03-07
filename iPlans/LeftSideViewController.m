//
//  LeftSideViewController.m
//  iPlans
//
//  Created by Jymn_Chen on 14-3-7.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "LeftSideViewController.h"
#import "JCSideMenuViewController.h"

@interface LeftSideViewController ()

@property (weak, nonatomic) UIImage *_backgroundImage;

@end

@implementation LeftSideViewController
@synthesize _backgroundImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _backgroundImage = [UIImage imageNamed:@"galaxy"];
    [self addBackgroundImage:_backgroundImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    _backgroundImage = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
