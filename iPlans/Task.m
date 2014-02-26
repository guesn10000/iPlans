//
//  Task.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-25.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "Task.h"

static NSString * const kTaskName   = @"TaskName";
static NSString * const kTaskRecord = @"TaskRecord";
static NSString * const kIsFinished = @"IsTaskFinished";

@implementation Task

#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)aName Record:(NSString *)aRecord isFinished:(BOOL)finished {
    self = [super init];
    
    if (self) {
        self.name       = aName;
        self.record     = aRecord;
        self.isFinished = finished;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"TaskName:%@ Record:%@ Finished:%d", self.name, self.record, self.isFinished];
}

#pragma mark - NSCopying Delegate

- (instancetype)copyWithZone:(NSZone *)zone {
    Task *task      = [[Task allocWithZone:zone] init];
    task.name       = self.name;
    task.record     = self.record;
    task.isFinished = self.isFinished;
    return task;
}

#pragma mark - NSCoding Delegate

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.name       = [aDecoder decodeObjectForKey:kTaskName];
    self.record     = [aDecoder decodeObjectForKey:kTaskRecord];
    self.isFinished = [aDecoder decodeBoolForKey:kIsFinished];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name     forKey:kTaskName];
    [aCoder encodeObject:self.record   forKey:kTaskRecord];
    [aCoder encodeBool:self.isFinished forKey:kIsFinished];
}

@end
