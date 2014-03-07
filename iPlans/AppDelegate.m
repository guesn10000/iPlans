//
//  AppDelegate.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-24.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "AppDelegate.h"
#import "JCSideMenuViewController.h"
#import "TasksManager.h"
#import "LeftSideViewController.h"

#ifdef APP_INITIALIZE
    #import "Task.h"
#endif

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

#ifdef APP_INITIALIZE
    NSArray *array = @[@"早晚刷牙洗脸", @"看CSDN头条", @"CSDN.Blogs", @"看36Kr全部资讯", @"浏览WeiPhone新闻", @"CocoaChina每天关注技术", @"每天学点新技术", @"写新浪博客"];
    NSMutableArray *tasksArray = [[NSMutableArray alloc] init];
    for (NSString *name in array) {
        Task *task = [[Task alloc] initWithName:name Record:@"0" isFinished:NO];
        [tasksArray addObject:task];
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tasksArray];
    NSString *bundleFilePath = [[NSBundle mainBundle] pathForResource:@"TasksEveryDay" ofType:@"plist"];
    if (![data writeToFile:bundleFilePath atomically:YES])
        NSLog(@"Succeed");
#endif
    
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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[TasksManager defaultManager] verifyTimestamp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
