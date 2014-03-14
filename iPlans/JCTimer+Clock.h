//
//  JCTimer+Clock.h
//  iPlans
//
//  Created by Jymn_Chen on 14-2-26.
//  Copyright (c) 2014年 Jymn_Chen. All rights reserved.
//

#import <JuliaCore/JuliaCore.h>

@interface JCTimer (Clock)

/* 设定毅力训练的刷新动作：将今天完成的任务还原到未完成的任务中 */

- (void)setClock;

- (BOOL)shouldUpdateClock;


/* 每天的提醒：避免用户忘记记录已经完成的任务 */

- (NSArray *)fireDatesOfDailyTasks;

@end
