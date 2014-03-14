//
//  JCLocalNotificationCenter.h
//  JuliaCoreFramework
//
//  Created by Jymn_Chen on 14-3-12.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCLocalNotificationCenter : NSObject

+ (instancetype)defaultCenter;

/* 默认用生成时间来指定消息的ID */
- (void)addLocalNotificationWithBody:(NSString *)aBody
                            FireDate:(NSDate *)aFireDate
                      RepeatInterval:(NSTimeInterval)aRepeatInterval;

- (void)addLocalNotificationWithIdentifier:(NSString *)aIdentifier
                                      Body:(NSString *)aBody
                                  FireDate:(NSDate *)aFireDate
                            RepeatInterval:(NSTimeInterval)aRepeatInterval;

/* 移除所有本地通知 */
- (void)removeAllLocalNotifications;

/* 判断用notiUserInfo标识的消息是否仍在scheduled local notifications中 */
- (BOOL)isLocalNotificationScheduled:(NSDictionary *)notiUserInfo;

@end
