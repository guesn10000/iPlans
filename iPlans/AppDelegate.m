//
//  AppDelegate.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-24.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <JuliaCore/JuliaCore.h>
#import "AppDelegate.h"
#import "JCTimer+Clock.h"
#import "JCLocalNotificationCenter+DailyTasks.h"
#import "Task.h"
#import "TasksManager.h"
#import "LeftSideViewController.h"

@implementation AppDelegate

#pragma mark - Local Notifications

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    JCLocalNotificationCenter *notiCenter = [JCLocalNotificationCenter defaultCenter];
    NSDictionary *userInfo = notification.userInfo;
    if ([notiCenter isFirstDailyTasksNotification:userInfo]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"iPlans提醒您"
                                                            message:@"今天的毅力训练您完成了吗？"
                                                           delegate:self
                                                  cancelButtonTitle:@"努力中" otherButtonTitles:@"完成了", nil];
        
        [alertView show];
    }
    else if ([notiCenter isLastDailyTasksNotification:userInfo]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"iPlans提醒您"
                                                            message:@"请抓紧时间完成今天的毅力训练"
                                                           delegate:self
                                                  cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 如果用户点击了"努力中"，那么什么也不做
    
    // 如果用户点击了"完成了"，相当于不再提醒，那么取消12:40的提醒
    if (buttonIndex == 1) {
        [[JCLocalNotificationCenter defaultCenter] removeDailyTasksNotification];
    }
}

#pragma mark - Application Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSString *appState = [JCUserDefaults objectForKey:kAppState];
    if (!appState || ![appState isEqualToString:kInitialized]) { // 如果是初次启动就执行下面的内容，整个程序从安装到删除期间只执行一次
        [JCUserDefaults setObject:kInitialized forKey:kAppState];
        
        NSMutableArray *tasksArray = [[NSMutableArray alloc] init];
        
        Task *task1 = [[Task alloc] initWithName:@"早晚刷牙洗脸" Record:@"0" isFinished:NO];
        [tasksArray addObject:task1];
        
        Task *task2 = [[Task alloc] initWithName:@"看CSDN头条" Record:@"0" isFinished:NO];
        [tasksArray addObject:task2];
        
        Task *task3 = [[Task alloc] initWithName:@"CSDN.Blogs" Record:@"0" isFinished:NO];
        [tasksArray addObject:task3];
        
        Task *task4 = [[Task alloc] initWithName:@"看36Kr全部资讯" Record:@"0" isFinished:NO];
        [tasksArray addObject:task4];
        
        Task *task5 = [[Task alloc] initWithName:@"浏览WeiPhone新闻" Record:@"0" isFinished:NO];
        [tasksArray addObject:task5];
        
        Task *task6 = [[Task alloc] initWithName:@"CocoaChina每天关注技术" Record:@"0" isFinished:NO];
        [tasksArray addObject:task6];
        
        Task *task7 = [[Task alloc] initWithName:@"每天学点新技术" Record:@"0" isFinished:NO];
        [tasksArray addObject:task7];
        
        Task *task8 = [[Task alloc] initWithName:@"写新浪博客" Record:@"0" isFinished:NO];
        [tasksArray addObject:task8];
        
        NSData   *data           = [NSKeyedArchiver archivedDataWithRootObject:tasksArray];
        NSString *bundleFilePath = [[NSBundle mainBundle] pathForResource:@"TasksEveryDay" ofType:@"plist"];
        if (![data writeToFile:bundleFilePath atomically:YES]) {
            NSLog(@"Succeed");
        }
        
        [[JCTimer sharedInstance] setClock];
        
        [[JCLocalNotificationCenter defaultCenter] removeAllLocalNotifications];
        [[JCLocalNotificationCenter defaultCenter] addDailyTasksNotification];
    }
    
    LeftSideViewController *leftSideViewController = [[UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil]
                                                      instantiateViewControllerWithIdentifier:LEFT_SIDE_VIEWCONTROLLER_ID];
    
    UITabBarController *tabBarController = [[UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil]
                                            instantiateViewControllerWithIdentifier:TABBAR_VIEWCONTROLLER_ID];
    
    JCSideMenuViewController *sideMenuViewController = [[JCSideMenuViewController alloc]
                                                        initWithLeftMenuViewController:leftSideViewController
                                                        MainViewController:tabBarController
                                                        RightMenuViewController:nil];
    
    self.window.rootViewController = sideMenuViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /**
     每天凌晨1点时刷新毅力训练列表
     程序启动或从后台恢复过来时，进行判断
     之所以把该方法放在BecomeActive方法中，因为考虑到某些用户是从不关后台的
     如果放在FinishLauching方法中将无法进行时间校验
     */
    [[TasksManager defaultManager] verifyTimestamp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
