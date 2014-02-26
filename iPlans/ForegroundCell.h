//
//  ForegroundCell.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForegroundCell : UITableViewCell

@property (assign, nonatomic) NSUInteger row;

- (void)configureCellAtRow:(NSUInteger)aRow TaskName:(NSString *)aName ImageID:(NSString *)aImageID;

@property (weak, nonatomic) IBOutlet UIImageView *description_imageView;
@property (weak, nonatomic) IBOutlet UILabel *taskName_label;
@property (weak, nonatomic) IBOutlet UIButton *finish_button;
- (IBAction)finishTask:(id)sender;

@end
