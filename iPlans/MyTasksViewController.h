//
//  MyTasksViewController.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTasksViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *foregroundTasks;

@property (strong, nonatomic) NSMutableArray *backgroundTasks;

@end
