//
//  DoingCell.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-25.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoingCell : UITableViewCell

@property (assign, nonatomic) NSUInteger row;

- (void)configureCellAtRow:(NSUInteger)aRow TaskName:(NSString *)aName;

@property (weak, nonatomic) IBOutlet UILabel  *taskName_label;
@property (weak, nonatomic)   IBOutlet UIButton *finishTask_button;
- (IBAction)finishTask:(id)sender;

@end
