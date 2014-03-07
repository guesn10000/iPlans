//
//  TasksViewController.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-24.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "TasksViewController.h"
#import "JCAlert.h"
#import "Task.h"
#import "TasksManager.h"
#import "DoingCell.h"
#import "FinishedCell.h"
#import "MyTasksViewController.h"

static NSString * const kDoingCellIdentifier    = @"DoingCell";
static NSString * const kFinishedCellIdentifier = @"FinishedCell";

@interface TasksViewController ()

@end

@implementation TasksViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 设置界面 */
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    /* 初始化数据 */
    
    [self loadTasksFromFile];
    
    
    /* 开始监听消息 */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(taskDidFinished:)
                                                 name:UITaskDidFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(taskWillRestore:)
                                                 name:UITaskWillRestoreNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(clockDidReset:)
                                                 name:UIClockDidResetNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(taskDidAddNew:)
                                                 name:UINewTaskDidAddNotification
                                               object:nil];
}

- (void)loadTasksFromFile {
    self.doingTasks    = [[NSMutableArray alloc] init];
    self.finishedTasks = [[NSMutableArray alloc] init];
    
    NSArray *allTasks = [[TasksManager defaultManager] getAllTasks];
    if (allTasks) {
        for (Task *task in allTasks) {
            if (!task.isFinished) {
                [self.doingTasks addObject:task];
            }
            else {
                [self.finishedTasks addObject:task];
            }
        }
    }
    else {
        self.doingTasks = [[TasksManager defaultManager] getInitialTasks];
        if (!self.doingTasks) {
            self.doingTasks = [[NSMutableArray alloc] init];
        }
        self.finishedTasks = [[NSMutableArray alloc] init];
        [self updateTasksData];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITaskDidFinishedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITaskWillRestoreNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIClockDidResetNotification   object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UINewTaskDidAddNotification   object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notifications Handlers

- (void)taskDidFinished:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSUInteger index = (NSUInteger)[userInfo[kRow] integerValue];
    
    Task *task = self.doingTasks[index];
    task.isFinished = YES;
    [self.doingTasks removeObjectAtIndex:index];
    
    NSUInteger times = (NSUInteger)[task.record integerValue];
    task.record = [NSString stringWithFormat:@"%d", times + 1];
    [self.finishedTasks insertObject:task atIndex:0];
    
    [self updateTasksData];
}

- (void)taskWillRestore:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSUInteger index = (NSUInteger)[userInfo[kRow] integerValue];
    
    Task *task = self.finishedTasks[index];
    task.isFinished = NO;
    [self.finishedTasks removeObjectAtIndex:index];
    
    NSUInteger times = (NSUInteger)[task.record integerValue];
    task.record = [NSString stringWithFormat:@"%d", times - 1];
    [self.doingTasks insertObject:task atIndex:0];
    
    [self updateTasksData];
}

- (void)updateTasksData {
    NSMutableArray *allTasks = [NSMutableArray array];
    for (Task *task in self.doingTasks) {
        [allTasks addObject:task];
    }
    for (Task *task in self.finishedTasks) {
        [allTasks addObject:task];
    }
    [[TasksManager defaultManager] updateAllTasks:allTasks];
    
    [self.tableView reloadData];
}

- (void)clockDidReset:(NSNotification *)noti {
    [self loadTasksFromFile];
    [self.tableView reloadData];
}

- (void)taskDidAddNew:(NSNotification *)noti {
    [self loadTasksFromFile];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.doingTasks count];
            break;
        
        case 1:
            return [self.finishedTasks count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"";
            break;
            
        case 1:
            return @"已完成";
            break;
            
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        DoingCell *doingCell = (DoingCell *)[tableView dequeueReusableCellWithIdentifier:kDoingCellIdentifier forIndexPath:indexPath];
        Task *task = self.doingTasks[indexPath.row];
        [doingCell configureCellAtRow:indexPath.row TaskName:task.name];
        return doingCell;
    }
    else {
        FinishedCell *finishedCell = (FinishedCell *)[tableView dequeueReusableCellWithIdentifier:kFinishedCellIdentifier forIndexPath:indexPath];
        Task *task = self.finishedTasks[indexPath.row];
        [finishedCell configureCellAtRow:indexPath.row TaskName:task.name Record:task.record];
        return finishedCell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.doingTasks removeObjectAtIndex:indexPath.row];
        [self updateTasksData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.section != toIndexPath.section) {
        [tableView reloadData];
        [JCAlert alertWithMessage:@"对不起，您不能将已经完成的任务直接拖拉进正在进行的任务中"];
        return;
    }
    
    if (fromIndexPath.section == 0) {
        Task *task = self.doingTasks[fromIndexPath.row];
        [self.doingTasks removeObjectAtIndex:fromIndexPath.row];
        [self.doingTasks insertObject:task atIndex:toIndexPath.row];
    }
    else {
        Task *task = self.finishedTasks[fromIndexPath.row];
        [self.finishedTasks removeObjectAtIndex:fromIndexPath.row];
        [self.finishedTasks insertObject:task atIndex:toIndexPath.row];
    }
    
    [self updateTasksData];
}

#pragma mark - Table view delegate

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return UITableViewCellEditingStyleNone;
    }
}

#pragma mark - Gesture Actions

- (IBAction)swipeRight:(id)sender {
    UITabBarController     *tabBarController     = self.navigationController.tabBarController;
    UINavigationController *navigationController = (UINavigationController *)tabBarController.viewControllers[1];
    MyTasksViewController  *aMyTasksController   = (MyTasksViewController *)navigationController.topViewController;
    [aMyTasksController swipeRight:nil];
}

@end
