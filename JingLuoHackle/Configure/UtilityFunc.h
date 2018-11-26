//
//  UtilityFunc.h
//  CustomNavigationBarDemo
//
//  Created by jimple on 14-1-6.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UtilityFunc : NSObject

// 是否4英寸屏幕
+ (BOOL)is4InchScreen;

// label设置最小字体大小
+ (void)label:(UILabel *)label setMiniFontSize:(CGFloat)fMiniSize forNumberOfLines:(NSInteger)iLines;

// 清除PerformRequests和notification
+ (void)cancelPerformRequestAndNotification:(UIViewController *)viewCtrl;

// 重设scroll view的内容区域和滚动条区域
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar;
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar iOS7ContentInsetStatusBarHeight:(NSInteger)iContentMulti inidcatorInsetStatusBarHeight:(NSInteger)iIndicatorMulti;
+ (NSString *)md5:(NSString *)str ;
+ (NSMutableDictionary*)mutableDictionaryFromAppConfig;
+ (void)updateAppConfigWithMutableDictionary:(NSMutableDictionary*)aDic;
+ (void)recordAppUserInfoWithDictionary:(NSMutableDictionary *)dic;
+ (NSMutableDictionary*)mutableDictionaryFromUserInfo;

+ (BOOL)fitToChineseIDWithString:(NSString*)aString;
+ (BOOL)fitToEmailWithString:(NSString*)aString;
+(UIColor *) colorWithHexString: (NSString *) hexString;

+(UILabel *)labelWith:(NSString *)title frame:(CGRect)frame textSize:(CGFloat)size textColor:(UIColor *)color lines:(NSInteger)lines aligment:(NSTextAlignment)aligment;
@end
