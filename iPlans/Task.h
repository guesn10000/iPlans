//
//  Task.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-25.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *record;

@property (assign, nonatomic) BOOL isFinished;

- (instancetype)initWithName:(NSString *)aName Record:(NSString *)aRecord isFinished:(BOOL)finished;

@end
