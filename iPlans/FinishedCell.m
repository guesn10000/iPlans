//
//  FinishedCell.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-25.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "FinishedCell.h"

@implementation FinishedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)restoreTask:(id)sender {
    NSString *rowStr = [NSString stringWithFormat:@"%d", self.row];
    NSDictionary *userInfo = @{kRow: rowStr};
    [[NSNotificationCenter defaultCenter] postNotificationName:UITaskWillRestoreNotification object:self userInfo:userInfo];
}

- (void)configureCellAtRow:(NSUInteger)aRow TaskName:(NSString *)aName Record:(NSString *)aRecord {
    self.row = aRow;
    self.taskName_label.text = aName;
    self.record_label.text   = [NSString stringWithFormat:@"连续%@天", aRecord];
}

@end
