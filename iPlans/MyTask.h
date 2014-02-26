//
//  MyTask.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTask : NSObject <NSCopying, NSCoding>

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *imageID;

- (instancetype)initWithName:(NSString *)aName ImageID:(NSString *)aImageID;

@end
