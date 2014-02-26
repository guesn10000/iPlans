//
//  AddTaskViewController.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "AddTaskViewController.h"
#import "Task.h"
#import "TasksManager.h"

#define kLengthOfPlaceHolder [kPlaceHolder length]

static NSString * const kPlaceHolder = @"请在这里输入您的任务";

@interface AddTaskViewController ()

@end

@implementation AddTaskViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.inputTaskName_textView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.finish_buttonItem.enabled = NO;
    
    [self.inputTaskName_textView becomeFirstResponder];
    self.inputTaskName_textView.text = kPlaceHolder;
    self.inputTaskName_textView.textColor = LIGHET_GRAY_COLOR;
    self.inputTaskName_textView.selectedRange = NSRangeZero;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.inputTaskName_textView resignFirstResponder];
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.finish_buttonItem.enabled = NO;
        
        self.inputTaskName_textView.text = kPlaceHolder;
        self.inputTaskName_textView.textColor = LIGHET_GRAY_COLOR;
        self.inputTaskName_textView.selectedRange = NSRangeZero;
    }
    else if ([textView.text hasSuffix:kPlaceHolder] && ![textView.text isEqualToString:kPlaceHolder]) {
        self.finish_buttonItem.enabled = YES;
        
        self.inputTaskName_textView.textColor = BLACK_COLOR;
        NSString *tempText = self.inputTaskName_textView.text;
        NSUInteger textLength = [tempText length];
        tempText = [tempText substringToIndex:textLength - kLengthOfPlaceHolder];
        self.inputTaskName_textView.text = tempText;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([textView.text isEqualToString:kPlaceHolder]) {
        self.inputTaskName_textView.selectedRange = NSRangeZero;
    }
}

#pragma mark - Button Actions

- (IBAction)finishAddingTask:(id)sender {
    Task *task = [[Task alloc] initWithName:self.inputTaskName_textView.text Record:@"0" isFinished:NO];
    [[TasksManager defaultManager] addNewTaskToAllTasks:task];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancelAddingTask:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
