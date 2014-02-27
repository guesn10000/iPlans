//
//  BackgroundCell.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundCell : UITableViewCell

@property (assign, nonatomic) NSUInteger row;

- (void)configureCellAtRow:(NSUInteger)aRow TaskName:(NSString *)aName;

@property (weak, nonatomic) IBOutlet UIImageView *description_imageView;
@property (weak, nonatomic) IBOutlet UILabel     *taskName_label;
@property (weak, nonatomic) IBOutlet UIButton    *doTask_button;
- (IBAction)doTask:(id)sender;

@end
