//
//  JCDeviceMarcos.h
//  JuliaCoreFramework
//
//  Created by Jymn_Chen on 14-3-10.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#ifndef JuliaCoreFramework_JCDeviceMarcos_h
#define JuliaCoreFramework_JCDeviceMarcos_h

#define __IPHONE5_5S_SCREEN_WIDTH__  320.0
#define __IPHONE5_5S_SCREEN_HEIGHT__ 568.0

#define __IPHONE4_4S_SCREEN_WIDTH__  320.0
#define __IPHONE4_4S_SCREEN_HEIGHT__ 480.0

#define __IPAD_SCREEN_WIDTH__  768.0
#define __IPAD_SCREEN_HEIGHT__ 1024.0

#define __IS_IPHONE__ (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define __IS_IPAD__   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#endif
