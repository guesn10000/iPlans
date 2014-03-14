//
//  JCObjcMarcos.h
//  JuliaCoreFramework
//
//  Created by Jymn_Chen on 14-3-10.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#ifndef JuliaCoreFramework_JCObjcMarcos_h
#define JuliaCoreFramework_JCObjcMarcos_h

//A better version of NSLog
#define NSLog(format, ...) do {                                             \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0)

#endif
