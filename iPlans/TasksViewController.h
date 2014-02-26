//
//  TasksViewController.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-24.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TasksViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *doingTasks;

@property (strong, nonatomic) NSMutableArray *finishedTasks;

@end
