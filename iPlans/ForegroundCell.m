//
//  ForegroundCell.m
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import "ForegroundCell.h"

@implementation ForegroundCell

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

- (void)configureCellAtRow:(NSUInteger)aRow TaskName:(NSString *)aName ImageID:(NSString *)aImageID {
    self.row = aRow;
    self.taskName_label.text = aName;
    self.description_imageView.image = [UIImage imageNamed:aImageID];
}

- (IBAction)finishTask:(id)sender {
    NSString *rowStr = [NSString stringWithFormat:@"%d", self.row];
    NSDictionary *userInfo = @{@"Row": rowStr};
    [[NSNotificationCenter defaultCenter] postNotificationName:UIMyTaskDidFinishedNotification object:self userInfo:userInfo];
}

@end
