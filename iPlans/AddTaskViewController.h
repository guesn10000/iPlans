//
//  AddTaskViewController.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTaskViewController : UIViewController <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *inputTaskName_textView;

- (IBAction)dismissKeyboard:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *finish_buttonItem;
- (IBAction)finishAddingTask:(id)sender;
- (IBAction)cancelAddingTask:(id)sender;

@end
