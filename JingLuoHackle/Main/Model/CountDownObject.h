//
//  CountDownObject.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/30.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef void (^countDownBlock) (NSInteger currentTime);

@interface CountDownObject : NSObject

@property (nonatomic,copy) void (^timeStopCallBack)();

@property (nonatomic,strong) dispatch_source_t timer;

@property (nonatomic,assign) NSInteger timeOut;

@property (nonatomic,assign) BOOL *isTimeOut;

- (void)countDownWithTimeInterval:(NSTimeInterval)duration withBlock:(countDownBlock)block;
- (void)pauseTimer;
- (void)cancleTimer;
- (void)startTimer;
@end
