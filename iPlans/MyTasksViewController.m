//
//  MyTasksViewController.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "MyTasksViewController.h"
#import "ForegroundCell.h"
#import "BackgroundCell.h"
#import "MyTask.h"
#import "MyTasksManager.h"

static NSString * const kForegroundCellIdentifier = @"ForegroundCell";
static NSString * const kBackgroundCellIdentifier = @"BackgroundCell";

@interface MyTasksViewController ()

@end

@implementation MyTasksViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self loadTasksFromFile];
    }
    
    return self;
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

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.editButtonItem setTitle:@"编辑"];
    
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
    NSUInteger index = (NSUInteger)[userInfo[@"Row"] integerValue];
    
    [self.foregroundTasks removeObjectAtIndex:index];
    
    [self updateTasksDataWithRefresh:YES];
}

- (void)myTaskWillEnterForeground:(NSNotification *)noti {
    NSDictionary *userInfo = [noti userInfo];
    NSUInteger index = (NSUInteger)[userInfo[@"Row"] integerValue];
    
    MyTask *task = self.backgroundTasks[index];
    task.imageID = TASK_ORDINARY;
    
    [self.backgroundTasks removeObjectAtIndex:index];
    [self.foregroundTasks insertObject:task atIndex:0];
    
    [self updateTasksDataWithRefresh:YES];
}

- (void)updateTasksDataWithRefresh:(BOOL)shouldRefresh {
    NSMutableArray *allTasks = [NSMutableArray array];
    for (MyTask *task in self.foregroundTasks) {
        [allTasks addObject:task];
    }
    for (MyTask *task in self.backgroundTasks) {
        [allTasks addObject:task];
    }
    [[MyTasksManager defaultManager] updateAllTasks:allTasks];
    
    if (shouldRefresh) {
        [self.tableView reloadData];
    }
}

- (void)myTaskDidAddNew:(NSNotification *)noti {
    [self loadTasksFromFile];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.foregroundTasks count];
    }
    else if (section == 1) {
        return [self.backgroundTasks count];
    }
    else {
        return 0;
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            [self.foregroundTasks removeObjectAtIndex:indexPath.row];
        }
        else {
            [self.backgroundTasks removeObjectAtIndex:indexPath.row];
        }
        
        [self updateTasksDataWithRefresh:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    if (fromIndexPath.section != toIndexPath.section) {
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
    
    [self updateTasksDataWithRefresh:YES];
}

@end
