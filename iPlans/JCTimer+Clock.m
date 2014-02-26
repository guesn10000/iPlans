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

- (void)setClock {
    NSString *curDateString = [self get_yyMMdd_StringOfCurrentTime];
    NSDate   *curDate       = [self getDateFrom_yyMMdd_String:curDateString];
    NSDate   *clock         = [NSDate dateWithTimeInterval:DAY_TIMEINTERVAL + HOUR_TIMEINTERVAL sinceDate:curDate];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:clock forKey:kClock];
    [userDefaults synchronize];
}

- (BOOL)shouldUpdateClock {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *clock   = [userDefaults objectForKey:kClock];
    NSDate *curDate = [NSDate date];
    NSUInteger result = [self compareDate:curDate toDate:clock];
    if (result == JCEarlier) {
        return NO;
    }
    else { // result = JCLater || result = JCSame
        return YES;
    }
}

@end
