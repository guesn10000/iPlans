//
//  JCTimer+Clock.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "JCTimer+Clock.h"

static NSString * const kClock = @"Clock";

@implementation JCTimer (Clock)

#pragma mark - Update daily tasks

- (void)setClock {
    NSString *curDateString = [self get_yyMMdd_StringOfCurrentTime];
    NSDate   *curDate       = [self getDateFrom_yyMMdd_String:curDateString];
    NSDate   *clock         = [NSDate dateWithTimeInterval:__DAY_TIMEINTERVAL__ + __HOUR_TIMEINTERVAL__ sinceDate:curDate];
    
    [JCUserDefaults setObject:clock forKey:kClock];
}

- (BOOL)shouldUpdateClock {
    NSDate *clock   = [JCUserDefaults objectForKey:kClock];
    NSDate *curDate = [NSDate date];
    NSUInteger result = [self compareDate:curDate toDate:clock];
    if (result == kJCEarlier) {
        return NO;
    }
    else { // result = kJCLater || result = kJCSame
        return YES;
    }
}

#pragma mark - Daily Notification

/**
 例如今天是1月1日，那么在1月2日的凌晨，12:10 12:40各提醒一次
 这里返回的是2个提醒时间
 */
- (NSArray *)fireDatesOfDailyTasks {
    NSString *curDateString = [self get_yyMMdd_StringOfCurrentTime];
    NSDate   *curDate       = [self getDateFrom_yyMMdd_String:curDateString];
    NSDate   *nextDate      = [NSDate dateWithTimeInterval:__DAY_TIMEINTERVAL__ sinceDate:curDate];
    
    NSMutableArray *fireDates = [[NSMutableArray alloc] init];
    
    // 12:10
    NSDate *clock1 = [NSDate dateWithTimeInterval:__TEN_MINUTES_TIMEINTERVAL__ sinceDate:nextDate];
    [fireDates addObject:clock1];
    
    // 12:40
    NSDate *clock2 = [NSDate dateWithTimeInterval:__HALF_HOUR_TIMEINTERVAL__ sinceDate:clock1];
    [fireDates addObject:clock2];
    
    return fireDates;
}

@end
