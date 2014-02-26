//
//  MyTasksManager.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MyTask;

@interface MyTasksManager : NSObject

+ (instancetype)defaultManager;

- (NSArray *)getAllTasks;

- (void)updateAllTasks:(NSMutableArray *)allTasks;

- (void)addNewTaskToAllTasks:(MyTask *)aTask;

@end
