//
//  JCTimer.h
//  SCNUPaper
//
//  Created by Jymn_Chen on 14-1-22.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JCEarlier 0
#define JCSame    1
#define JCLater   2

#define WEEK_TIMEINTERVAL   7.0  * DAY_TIMEINTERVAL
#define DAY_TIMEINTERVAL    24.0 * HOUR_TIMEINTERVAL
#define HOUR_TIMEINTERVAL   60.0 * MINUTE_TIMEINTERVAL
#define MINUTE_TIMEINTERVAL 60.0

@interface JCTimer : NSObject

+ (instancetype)sharedInstance;

/* 获取当前时间对应的字符串 */
- (NSString *)get_yyMMdd_StringOfCurrentTime;
- (NSString *)get_yyMMddhh_StringOfCurrentTime;
- (NSString *)get_yyMMddhhmm_StringOfCurrentTime;
- (NSString *)get_yyMMddhhmmss_StringOfCurrentTime;

/* 根据指定的时间显示格式获取对应的日期 */
- (NSDate *)getDateFrom_yyMMdd_String:(NSString *)dateString;
- (NSDate *)getDateFrom_yyMMddhh_String:(NSString *)dateString;
- (NSDate *)getDateFrom_yyMMddhhmm_String:(NSString *)dateString;
- (NSDate *)getDateFrom_yyMMddhhmmss_String:(NSString *)dateString;

/* 比较两个日期并返回结果 */
- (NSUInteger)compareDate:(NSDate *)firstDate toDate:(NSDate *)nextDate;

@end
