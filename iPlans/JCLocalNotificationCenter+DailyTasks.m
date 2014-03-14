//
//  JCLocalNotificationCenter+DailyTasks.m
//  iPlans
//
//  Created by Jymn_Chen on 14-3-12.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "JCLocalNotificationCenter+DailyTasks.h"
#import "JCTimer+Clock.h"

static NSString * const kLocalNotificationBody = @"今天的毅力训练您完成了吗？";
static NSString * const kLocalNotification1_ID = @"1210";
static NSString * const kLocalNotification2_ID = @"1240";

@implementation JCLocalNotificationCenter (DailyTasks)

- (void)addDailyTasksNotification {
    NSArray *fireDates = [[JCTimer sharedInstance] fireDatesOfDailyTasks];
    if (fireDates) {
        [self addLocalNotificationWithIdentifier:kLocalNotification1_ID
                                            Body:kLocalNotificationBody
                                        FireDate:(NSDate *)fireDates[0]
                                  RepeatInterval:0];
        
        [self addLocalNotificationWithIdentifier:kLocalNotification2_ID
                                            Body:kLocalNotificationBody
                                        FireDate:(NSDate *)fireDates[1]
                                  RepeatInterval:0];
    }
}

- (void)removeDailyTasksNotification {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in localNotifications) {
        NSString *notiID = [notification userInfo][kLocalNotificationIdentifier];
        if ([notiID isEqualToString:kLocalNotification1_ID] || [notiID isEqualToString:kLocalNotification2_ID]) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

- (void)resetDailyTasksNotification {
    [self removeDailyTasksNotification];
    [self addDailyTasksNotification];
}

- (BOOL)isFirstDailyTasksNotification:(NSDictionary *)notiUserInfo {
    return ([(NSString *)notiUserInfo[kLocalNotificationIdentifier] isEqualToString:kLocalNotification1_ID]) ? YES : NO;
}

- (BOOL)isLastDailyTasksNotification:(NSDictionary *)notiUserInfo {
    return ([(NSString *)notiUserInfo[kLocalNotificationIdentifier] isEqualToString:kLocalNotification2_ID]) ? YES : NO;
}

@end
