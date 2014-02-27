//
//  AddMyTaskViewController.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "AddMyTaskViewController.h"
#import "MyTask.h"
#import "MyTasksManager.h"

#define kLengthOfPlaceHolder [kPlaceHolder length]

static NSString * const kPlaceHolder = @"请在这里输入您的任务";

@interface AddMyTaskViewController ()

@end

@implementation AddMyTaskViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageIDPicker.delegate   = self;
    self.imageIDPicker.dataSource = self;
    
    self.navigationItem.hidesBackButton = YES;
    
    self.inputTaskName_textView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.finishAdding_buttonItem.enabled = NO;
    
    self.inputTaskName_textView.text          = kPlaceHolder;
    self.inputTaskName_textView.textColor     = LIGHET_GRAY_COLOR;
    self.inputTaskName_textView.selectedRange = NSRangeZero;
    [self.inputTaskName_textView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextView Delegate

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        self.finishAdding_buttonItem.enabled = NO;
        
        self.inputTaskName_textView.text          = kPlaceHolder;
        self.inputTaskName_textView.textColor     = LIGHET_GRAY_COLOR;
        self.inputTaskName_textView.selectedRange = NSRangeZero;
    }
    else if ([textView.text hasSuffix:kPlaceHolder] && ![textView.text isEqualToString:kPlaceHolder]) {
        self.finishAdding_buttonItem.enabled = YES;
        
        self.inputTaskName_textView.textColor = BLACK_COLOR;
        NSString   *tempText   = self.inputTaskName_textView.text;
        NSUInteger  textLength = [tempText length];
        tempText = [tempText substringToIndex:textLength - kLengthOfPlaceHolder];
        self.inputTaskName_textView.text = tempText;
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    if ([textView.text isEqualToString:kPlaceHolder]) {
        self.inputTaskName_textView.selectedRange = NSRangeZero;
    }
}

#pragma mark - UIPickerView DataSource and Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 4;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return @"后台";
            
        case 1:
            return @"一般";
            
        case 2:
            return @"重要";
            
        case 3:
            return @"紧急";
            
        default:
            return nil;
    }
}

#pragma mark - Actions

- (IBAction)dismissKeyboard:(id)sender {
    [self.inputTaskName_textView resignFirstResponder];
}

- (IBAction)finishAddingTask:(id)sender {
    NSUInteger selectedRow = [self.imageIDPicker selectedRowInComponent:0];
    NSString *imageID;
    switch (selectedRow) {
        case 0:
            imageID = TASK_BACKGROUND;
            break;
            
        case 1:
            imageID = TASK_ORDINARY;
            break;
            
        case 2:
            imageID = TASK_IMPORTANT;
            break;
            
        case 3:
            imageID = TASK_EMERGENT;
            break;
            
        default:
            break;
    }
    
    MyTask *task = [[MyTask alloc] initWithName:self.inputTaskName_textView.text ImageID:imageID];
    [[MyTasksManager defaultManager] addNewTaskToAllTasks:task];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cancelAddingTask:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
