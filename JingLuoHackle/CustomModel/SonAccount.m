//
//  SonAccount.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/16.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "SonAccount.h"

@implementation SonAccount
- (instancetype)init{
    if (self = [super init]) {
        _token = @"";
        _JSESS = @"";
        _array = [[NSMutableArray alloc] init];
        
    }
    return self;
}

@end
