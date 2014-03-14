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

/* 获取单例 */
+ (instancetype)defaultManager;

/* 获取初始化的数据 */
- (NSMutableArray *)getInitialTasks;

/* 获取所有任务数据，包括完成的和没完成的 */
- (NSArray *)getAllTasks;

/* 验证刷新时间是否到了 */
- (void)verifyTimestamp;

/* 刷新所有任务 */
- (void)updateAllTasks:(NSMutableArray *)allTasks;

/* 增加新的任务到毅力训练中 */
- (void)addNewTaskToAllTasks:(Task *)aTask;

@end
