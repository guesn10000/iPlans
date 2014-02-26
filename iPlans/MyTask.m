//
//  MyTask.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "MyTask.h"

static NSString * const kTaskName  = @"TaskName";
static NSString * const kTaskState = @"TaskState";
static NSString * const kTaskImage = @"TaskImage";

@implementation MyTask

#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)aName ImageID:(NSString *)aImageID {
    self = [super init];
    
    if (self) {
        self.name    = aName;
        self.imageID = aImageID;
    }
    
    return self;
}

#pragma mark - NSCopying Delegate

- (instancetype)copyWithZone:(NSZone *)zone {
    MyTask *task = [[MyTask allocWithZone:zone] init];
    task.name    = self.name;
    task.imageID = self.imageID;
    return task;
}

#pragma mark - NSCoding Delegate

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self.name    = [aDecoder decodeObjectForKey:kTaskName];
    self.imageID = [aDecoder decodeObjectForKey:kTaskImage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name    forKey:kTaskName];
    [aCoder encodeObject:self.imageID forKey:kTaskImage];
}

@end
