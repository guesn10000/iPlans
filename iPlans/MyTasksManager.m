//
//  MyTasksManager.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "MyTasksManager.h"
#import "MyTask.h"
#import "JCFilePersistence.h"

@implementation MyTasksManager

#pragma mark - Singleton

+ (instancetype)defaultManager {
    static MyTasksManager *manager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self defaultManager];
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark - Tasks setter and getter

- (NSArray *)getAllTasks {
    JCFilePersistence *filePersistence = [JCFilePersistence sharedInstance];
    NSString *tasksFilePath = [filePersistence getDirectoryOfDocumentFileWithName:MYTASKS_FILE];
    if ([filePersistence isFileExitsAtPath:tasksFilePath]) {
        NSMutableData *data = [filePersistence loadMutableDataFromDocumentFile:MYTASKS_FILE];
        return (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}

- (void)updateAllTasks:(NSMutableArray *)allTasks {
    JCFilePersistence *filePersistence = [JCFilePersistence sharedInstance];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allTasks];
    [filePersistence saveMutableData:[NSMutableData dataWithData:data] toDocumentFile:MYTASKS_FILE];
}

- (void)addNewTaskToAllTasks:(MyTask *)aTask {
    NSArray *allTasks = [self getAllTasks];
    if (!allTasks) {
        allTasks = [[NSArray alloc] init];
    }
    NSMutableArray *updatingTasks = [NSMutableArray arrayWithArray:allTasks];
    [updatingTasks addObject:aTask];
    [self updateAllTasks:updatingTasks];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UINewMyTaskDidAddNotification object:nil];
}

@end
