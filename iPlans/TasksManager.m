//
//  TasksManager.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <JuliaCore/JuliaCore.h>
#import "TasksManager.h"
#import "Task.h"
#import "JCTimer+Clock.h"
#import "JCLocalNotificationCenter+DailyTasks.h"

@implementation TasksManager

#pragma mark - Singleton

+ (instancetype)defaultManager {
    static TasksManager *manager = nil;
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

- (NSMutableArray *)getInitialTasks {
    JCFilePersistence *filePersistence = [JCFilePersistence sharedInstance];
    NSString *bundleFilePath = [[NSBundle mainBundle] pathForResource:TASK_EVERYDAY_FILE ofType:nil];
    if ([filePersistence isFileExitsAtPath:bundleFilePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:bundleFilePath];
        return (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}

- (NSArray *)getAllTasks {
    JCFilePersistence *filePersistence = [JCFilePersistence sharedInstance];
    NSString *tasksFilePath = [filePersistence getDirectoryOfDocumentFileWithName:TASKS_FILE];
    if ([filePersistence isFileExitsAtPath:tasksFilePath]) {
        NSMutableData *data = [filePersistence loadMutableDataFromDocumentFile:TASKS_FILE];
        return (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}

- (void)addNewTaskToAllTasks:(Task *)aTask {
    NSArray *allTasks = [self getAllTasks];
    if (!allTasks) {
        allTasks = [[NSArray alloc] init];
    }
    NSMutableArray *updatingTasks = [NSMutableArray arrayWithArray:allTasks];
    [updatingTasks addObject:aTask];
    [self updateAllTasks:updatingTasks];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UINewTaskDidAddNotification object:nil];
}

- (void)updateAllTasks:(NSMutableArray *)allTasks {
    JCFilePersistence *filePersistence = [JCFilePersistence sharedInstance];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allTasks];
    [filePersistence saveMutableData:[NSMutableData dataWithData:data] toDocumentFile:TASKS_FILE];
}

#pragma mark - Timestamp verify

- (void)verifyTimestamp {
    JCTimer *timer = [JCTimer sharedInstance];
    // 如果超过当天的凌晨一点，就刷新每天的任务列表
    if ([timer shouldUpdateClock]) {
        JCFilePersistence *filePersistence = [JCFilePersistence sharedInstance];
        NSString *tasksFilePath = [filePersistence getDirectoryOfDocumentFileWithName:TASKS_FILE];
        if ([filePersistence isFileExitsAtPath:tasksFilePath]) {
            NSMutableData *fileData = [filePersistence loadMutableDataFromDocumentFile:TASKS_FILE];
            NSArray       *allTasks = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:fileData];
            for (Task *task in allTasks) {
                if (!task.isFinished) {
                    task.record = @"0";
                }
                else {
                    task.isFinished = NO;
                }
            }
            
            NSData *archiveData = [NSKeyedArchiver archivedDataWithRootObject:allTasks];
            fileData = [NSMutableData dataWithData:archiveData];
            [filePersistence saveMutableData:fileData toDocumentFile:TASKS_FILE];
        }
        
        // 重置刷新时间
        [timer setClock];
        
        // 重置今天的本地通知
        [[JCLocalNotificationCenter defaultCenter] resetDailyTasksNotification];
        
        // 通知UI更新界面
        [[NSNotificationCenter defaultCenter] postNotificationName:UIClockDidResetNotification object:nil];
    }
}

@end
