//
//  CountDownObject.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/30.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "CountDownObject.h"
#import "BAKit_ConfigurationDefine.h"

@implementation CountDownObject

- (void)setTimer:(dispatch_source_t)timer
{
    BAKit_Objc_setObj(@selector(timer), timer);
}

- (dispatch_source_t)timer
{
    return BAKit_Objc_getObj;
}

- (void)countDownWithTimeInterval:(NSTimeInterval)duration withBlock:(countDownBlock)block
{
    __block NSInteger timeOut = duration; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    BAKit_WeakSelf
    dispatch_source_set_event_handler(self.timer, ^{
        BAKit_StrongSelf
        dispatch_async(dispatch_get_main_queue(), ^{
            if(block){
                block(timeOut);
            }
            if(timeOut <=0 ){
                [self cancleTimer];
            }else{
                timeOut -- ;
            }
        });
    });
    dispatch_resume(self.timer);
    
}

- (void)startTimer
{
    if(!self.timer){
        return;
    }
    if(self.timeOut){
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_resume(self.timer);
            self.timeOut = NO;
        });
    }
}

- (void)pauseTimer
{
    if(!self.timer){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_suspend(self.timer);
        self.timeOut = YES;
    });
}

- (void)cancleTimer
{
    if(!self.timer){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        self.timeOut = NO;
        if(self.timeStopCallBack){
            self.timeStopCallBack();
        }
    });
}

@end
