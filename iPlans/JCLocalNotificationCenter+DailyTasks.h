//
//  JCLocalNotificationCenter+DailyTasks.h
//  iPlans
//
//  Created by Jymn_Chen on 14-3-12.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <JuliaCore/JuliaCore.h>

@interface JCLocalNotificationCenter (DailyTasks)

/* 添加或取消DailyTasks本地提醒 */

- (void)addDailyTasksNotification;

- (void)removeDailyTasksNotification;


/* 重置DailyTasks本地提醒 */
- (void)resetDailyTasksNotification;

/* 判断是不是毅力训练的提醒 */
- (BOOL)isFirstDailyTasksNotification:(NSDictionary *)notiUserInfo;
- (BOOL)isLastDailyTasksNotification:(NSDictionary *)notiUserInfo;

@end
