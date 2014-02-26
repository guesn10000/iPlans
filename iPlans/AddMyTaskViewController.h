//
//  AddMyTaskViewController.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMyTaskViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView   *inputTaskName_textView;
@property (weak, nonatomic) IBOutlet UIPickerView *imageIDPicker;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishAdding_buttonItem;
- (IBAction)finishAddingTask:(id)sender;
- (IBAction)cancelAddingTask:(id)sender;

- (IBAction)dismissKeyboard:(id)sender;

@end
