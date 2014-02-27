//
//  MyTasksViewController.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "MyTasksViewController.h"
#import "JCAlert.h"
#import "MyTask.h"
#import "MyTasksManager.h"
#import "ForegroundCell.h"
#import "BackgroundCell.h"

static NSString * const kForegroundCellIdentifier = @"ForegroundCell";
static NSString * const kBackgroundCellIdentifier = @"BackgroundCell";

@interface MyTasksViewController ()

@end

@implementation MyTasksViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* 设置界面 */

    self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blueColor];
    [self.refreshControl addTarget:self
                            action:@selector(controlEventValueChanged:)
                  forControlEvents:UIControlEventValueChanged];
    
    
    /* 初始化数据 */
    
    [self loadTasksFromFile];
    
    
    /* 开始监听消息 */
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myTaskDidFinished:)
                                                 name:UIMyTaskDidFinishedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myTaskWillEnterForeground:)
                                                 name:UIMyTaskWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(myTaskDidAddNew:)
                                                 name:UINewMyTaskDidAddNotification
                                               object:nil];
}

- (void)loadTasksFromFile {
    self.foregroundTasks = [[NSMutableArray alloc] init];
    self.backgroundTasks = [[NSMutableArray alloc] init];
    
    NSArray *allTasks = [[MyTasksManager defaultManager] getAllTasks];
    if (allTasks) {
        for (MyTask *task in allTasks) {
            if ([task.imageID isEqualToString:TASK_BACKGROUND]) {
                [self.backgroundTasks addObject:task];
            }
            else {
                [self.foregroundTasks addObject:task];
            }
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMyTaskDidFinishedNotification         object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMyTaskWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UINewMyTaskDidAddNotification           object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notifications Handlers

- (void)myTaskDidFinished:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSUInteger index = (NSUInteger)[userInfo[kRow] integerValue];
    
    [self.foregroundTasks removeObjectAtIndex:index];
    
    [self updateTasksDataShouldSort:NO];
}

- (void)myTaskWillEnterForeground:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSUInteger index = (NSUInteger)[userInfo[kRow] integerValue];
    
    MyTask *task = self.backgroundTasks[index];
    task.imageID = TASK_ORDINARY;
    
    [self.backgroundTasks removeObjectAtIndex:index];
    [self.foregroundTasks insertObject:task atIndex:0];
    
    [self updateTasksDataShouldSort:YES];
}

- (void)myTaskDidAddNew:(NSNotification *)noti {
    [self loadTasksFromFile];
    
    [self updateTasksDataShouldSort:YES];
    
    [self.tableView reloadData];
}

- (void)updateTasksDataShouldSort:(BOOL)shouldSort {
    if (shouldSort) {
        [self sortForegroundTasks];
    }
    
    NSMutableArray *allTasks = [NSMutableArray array];
    for (MyTask *task in self.foregroundTasks) {
        [allTasks addObject:task];
    }
    for (MyTask *task in self.backgroundTasks) {
        [allTasks addObject:task];
    }
    
    [[MyTasksManager defaultManager] updateAllTasks:allTasks];
    
    [self.tableView reloadData];
}

- (void)sortForegroundTasks {
    [self.foregroundTasks sortUsingComparator:
     ^NSComparisonResult(id obj1, id obj2) {
         MyTask *task1 = (MyTask *)obj1;
         MyTask *task2 = (MyTask *)obj2;
         NSString *str1 = task1.imageID;
         NSString *str2 = task2.imageID;
         NSUInteger val1 = (NSUInteger)[[str1 substringToIndex:str1.length - kLengthOfImageSuffix] integerValue];
         NSUInteger val2 = (NSUInteger)[[str2 substringToIndex:str2.length - kLengthOfImageSuffix] integerValue];
         if (val1 < val2) {
             return NSOrderedDescending;
         }
         else if (val1 > val2) {
             return NSOrderedAscending;
         }
         else {
             return NSOrderedSame;
         }
     }
    ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.foregroundTasks count];
            break;
            
        case 1:
            return [self.backgroundTasks count];
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
            return @"后台";
            break;
            
        default:
            return @"";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ForegroundCell *foregroundCell = (ForegroundCell *)[tableView dequeueReusableCellWithIdentifier:kForegroundCellIdentifier forIndexPath:indexPath];
        MyTask *task = self.foregroundTasks[indexPath.row];
        [foregroundCell configureCellAtRow:indexPath.row TaskName:task.name ImageID:task.imageID];
        return foregroundCell;
    }
    else {
        BackgroundCell *backgroundCell = (BackgroundCell *)[tableView dequeueReusableCellWithIdentifier:kBackgroundCellIdentifier forIndexPath:indexPath];
        MyTask *task = self.backgroundTasks[indexPath.row];
        [backgroundCell configureCellAtRow:indexPath.row TaskName:task.name];
        return backgroundCell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            [self.foregroundTasks removeObjectAtIndex:indexPath.row];
        }
        else {
            [self.backgroundTasks removeObjectAtIndex:indexPath.row];
        }
        
        [self updateTasksDataShouldSort:NO];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.section != toIndexPath.section) {
        [tableView reloadData];
        [JCAlert alertWithMessage:@"对不起，您不能将后台任务直接拖拉进前台任务中"];
        return;
    }
    
    if (fromIndexPath.section == 0) {
        MyTask *task = self.foregroundTasks[fromIndexPath.row];
        [self.foregroundTasks removeObjectAtIndex:fromIndexPath.row];
        [self.foregroundTasks insertObject:task atIndex:toIndexPath.row];
    }
    else {
        MyTask *task = self.backgroundTasks[fromIndexPath.row];
        [self.backgroundTasks removeObjectAtIndex:fromIndexPath.row];
        [self.backgroundTasks insertObject:task atIndex:toIndexPath.row];
    }
    
    [self updateTasksDataShouldSort:NO];
}

#pragma mark - Refresh control

- (void)controlEventValueChanged:(id)sender {
    if (self.refreshControl.refreshing) {
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"禀大王，正在刷新"];
        
        [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0.5];
    }
}

- (void)refreshTable {
    [self updateTasksDataShouldSort:YES];
    
    // 完成刷新
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
}

@end
