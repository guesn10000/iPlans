//
//  IBMarcos.h
//  iPlans
//
//  Created by Jymn_Chen on 14-3-7.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#ifndef iPlans_IBMarcos_h
#define iPlans_IBMarcos_h

#import <JuliaCore/JCDeviceMarcos.h>

#define IPHONE_STORYBOARD_NAME @"Main_iPhone"
#define IPAD_STORYBOARD_NAME   @"Main_iPad"
#define STORYBOARD_NAME ((__IS_IPHONE__) ? IPHONE_STORYBOARD_NAME : IPAD_STORYBOARD_NAME)

#define LEFT_SIDE_VIEWCONTROLLER_ID @"LeftSideViewController"
#define TABBAR_VIEWCONTROLLER_ID    @"TabBarController"

#endif
