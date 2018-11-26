//
//  ShareOnce.m
//  FounderReader-2.5
//
//  Created by 黄柳姣 on 2018/1/31.
//

#import "ShareOnce.h"

@implementation ShareOnce
+ (ShareOnce *)shareOnce
{
    static ShareOnce *shareOnce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shareOnce = [[ShareOnce alloc] init];
    });
    return shareOnce;
}
@end
