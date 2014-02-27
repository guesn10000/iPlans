//
//  BackgroundCell.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "BackgroundCell.h"

@implementation BackgroundCell

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

- (void)configureCellAtRow:(NSUInteger)aRow TaskName:(NSString *)aName {
    self.row = aRow;
    self.taskName_label.text = aName;
    self.description_imageView.image = [UIImage imageNamed:TASK_BACKGROUND];
}

- (IBAction)doTask:(id)sender {
    NSString *rowStr = [NSString stringWithFormat:@"%d", self.row];
    NSDictionary *userInfo = @{kRow: rowStr};
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMyTaskWillEnterForegroundNotification object:self userInfo:userInfo];
}

@end
