//
//  FinishedCell.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-25.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishedCell : UITableViewCell

@property (assign, nonatomic) NSUInteger row;

@property (weak, nonatomic) IBOutlet UILabel  *taskName_label;
@property (weak, nonatomic) IBOutlet UILabel  *record_label;
@property (weak, nonatomic) IBOutlet UIButton *finished_button;
- (IBAction)restoreTask:(id)sender;

- (void)configureCellAtRow:(NSUInteger)aRow TaskName:(NSString *)aName Record:(NSString *)aRecord;

@end
