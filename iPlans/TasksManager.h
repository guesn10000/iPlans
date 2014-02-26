//
//  TasksManager.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;

@interface TasksManager : NSObject

+ (instancetype)defaultManager;

- (void)verifyTimestamp;

- (NSMutableArray *)getInitialTasks;

- (NSArray *)getAllTasks;

- (void)updateAllTasks:(NSMutableArray *)allTasks;

- (void)addNewTaskToAllTasks:(Task *)aTask;

@end
