//
//  ShareOnce.h
//  FounderReader-2.5
//
//  Created by 黄柳姣 on 2018/1/31.
//

#import <Foundation/Foundation.h>

@interface ShareOnce : NSObject

@property(nonatomic,assign) int jwId;
@property(nonatomic,assign) int zmtId;
@property(nonatomic,assign) BOOL isBlueToothConnect;
@property(nonatomic,copy) NSString *languageStr;
+ (ShareOnce *)shareOnce;

@end
