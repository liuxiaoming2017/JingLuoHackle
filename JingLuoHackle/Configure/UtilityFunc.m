//
//  UtilityFunc.m
//  CustomNavigationBarDemo
//
//  Created by jimple on 14-1-6.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "UtilityFunc.h"
#import "GlobalDefine.h"
#import <CommonCrypto/CommonDigest.h>
@implementation UtilityFunc

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%X%X%X%X%X%X%X%X%X%X%X%X%X%X%X%X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
+ (NSMutableDictionary*)mutableDictionaryFromAppConfig
{
    NSString *filename= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppConfig.plist"];
    NSMutableDictionary* dicFile = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    if (!dicFile) {
        //该plist不存在
        dicFile = [NSMutableDictionary dictionary];
        [dicFile writeToFile:filename atomically:YES];
    }
    NSString* strVersion =@"pwd";
    NSMutableDictionary* dicRet = [dicFile objectForKey:strVersion];
    if (!dicRet) {
        //该plist没有当前版本数据
        dicRet = [NSMutableDictionary dictionary];
        [dicFile setObject:dicRet forKey:strVersion];
        [dicFile writeToFile:filename atomically:YES];
    }
    return dicRet;
}
+ (void)updateAppConfigWithMutableDictionary:(NSMutableDictionary*)aDic
{
    NSString *filename= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/AppConfig.plist"];
    NSMutableDictionary* dicFile = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    // NSLog(@"%@",filename);
    if (!dicFile) {
        //该plist不存在
        dicFile = [NSMutableDictionary dictionary];
        
    }
    NSString* strVersion =@"pwd";
    [dicFile setObject:aDic forKey:strVersion];
    [dicFile writeToFile:filename atomically:YES];
}
/**
 *  存取用户信息
 *
 *  @param dic 信息
 */
+ (void)recordAppUserInfoWithDictionary:(NSMutableDictionary *)dic{
    NSString *filename= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/User.plist"];
    NSLog(@"%@",filename);
    NSMutableDictionary* dicFile = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    // NSLog(@"%@",filename);
    if (!dicFile) {
        //该plist不存在
        dicFile = [NSMutableDictionary dictionary];
        
    }
    NSString* strVersion =@"pwd";
    [dicFile setObject:dic forKey:strVersion];
    [dicFile writeToFile:filename atomically:YES];
    
}

/**
 *  获取用户信息
 *
 *  @return dic 信息
 */
+ (NSMutableDictionary*)mutableDictionaryFromUserInfo
{
    NSString *filename= [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/User.plist"];
    NSMutableDictionary* dicFile = [NSMutableDictionary dictionaryWithContentsOfFile:filename];
    if (!dicFile) {
        //该plist不存在
        dicFile = [NSMutableDictionary dictionary];
        [dicFile writeToFile:filename atomically:YES];
    }
    NSString* strVersion =@"pwd";
    NSMutableDictionary* dicRet = [dicFile objectForKey:strVersion];
    if (!dicRet) {
        //该plist没有当前版本数据
        dicRet = [NSMutableDictionary dictionary];
        [dicFile setObject:dicRet forKey:strVersion];
        [dicFile writeToFile:filename atomically:YES];
    }
    return dicRet;
}

+ (BOOL)fitToEmailWithString:(NSString*)aString
{
    NSString* regex = @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate* pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:aString];
}
+ (BOOL)fitToChineseIDWithString:(NSString*)aString
{
    
    NSString * regex1 = @"^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$";
    NSString * regex2 = @"^[1-9]\\d{5}(19|20)\\d{2}(0\\d|1[0-2])(([0|1|2]\\d)|3[0-1])\\d{3}(x|X|\\d)$";
    //NSString * regex2 = @"^[1-9]\\d{16}(x|X|\\d)$";
    //NSString * regex2 = @"^\\d{18}$";
    NSPredicate* pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex1];
    NSPredicate* pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex2];
    if ([pred1 evaluateWithObject:aString]) {
        //15位身份证号码
        NSString* strTmp;
        NSRange rg;
        //获得省代码
        rg.length = 2;
        rg.location = 0;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 41 || [strTmp intValue] < 11) {
            //省代码不合法
            return NO;
        }
        //获得月份
        rg.location = 8;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 12 || [strTmp intValue] < 1) {
            //月份不合法
            return NO;
        }
        
        //获得日
        rg.location = 10;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 31 || [strTmp intValue] < 1) {
            //日不合法
            return NO;
        }
        
        return YES;
    }
    else if ([pred2 evaluateWithObject:aString])
    {
        //18位身份证号码
        NSString* strTmp;
        NSRange rg;
        //获得省代码
        rg.length = 2;
        rg.location = 0;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 99 || [strTmp intValue] < 1) {
            //省代码不合法
            return NO;
        }
        //获得年
        rg.location = 6;
        rg.length = 4;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 2100 || [strTmp intValue] < 1900) {
            //年不合法
            return NO;
        }
        //获得月份
        rg.location = 10;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 12 || [strTmp intValue] < 1) {
            //月份不合法
            return NO;
        }
        
        //获得日
        rg.location = 12;
        rg.length = 2;
        strTmp = [aString substringWithRange:rg];
        if ([strTmp intValue] > 31 || [strTmp intValue] < 1) {
            //日不合法
            return NO;
        }
        
        NSRange rangeLast;
        rangeLast.length = 1;
        rangeLast.location = 17;
        NSString* strLast = [aString substringWithRange:rangeLast];
        if ([strLast isEqualToString:@"x"]) {
            strLast = @"X";
        }
        
        
        int i = 0;
        int sum = 0;
        int a[17] = {7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2};
        
        for (i = 0; i < 17; i++) {
            NSRange range;
            range.location = i;
            range.length = 1;
            int intValue = [[aString substringWithRange:range]intValue];
            if (intValue >= 0 && intValue <=9) {
                sum += intValue * a[i];
            }
            else
            {
                //非数字
                return NO;
            }
        }
        int y = sum % 11;
        
        NSDictionary* dicTmp = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"1",@"0",
                                @"0",@"1",
                                @"X",@"2",
                                @"9",@"3",
                                @"8",@"4",
                                @"7",@"5",
                                @"6",@"6",
                                @"5",@"7",
                                @"4",@"8",
                                @"3",@"9",
                                @"2",@"10", nil];
        NSString* strCounted = [dicTmp objectForKey:[NSString stringWithFormat:@"%d",y]];
        if ([strLast isEqualToString:strCounted]) {
            return YES;
        }
        else
            return NO;//验证码不匹配
        
    }
    else
    {
        return NO;
    }
}
// 是否4英寸屏幕
+ (BOOL)is4InchScreen
{
    static BOOL bIs4Inch = NO;
    static BOOL bIsGetValue = NO;
    
    if (!bIsGetValue)
    {
        CGRect rcAppFrame = [UIScreen mainScreen].bounds;
        bIs4Inch = (rcAppFrame.size.height == 568.0f);
        
        bIsGetValue = YES;
    }else{}
    
    return bIs4Inch;
}

// label设置最小字体大小
+ (void)label:(UILabel *)label setMiniFontSize:(CGFloat)fMiniSize forNumberOfLines:(NSInteger)iLines
{
    if (label)
    {
        label.adjustsFontSizeToFitWidth = YES;
        label.minimumScaleFactor = fMiniSize/label.font.pointSize;
        if ((iLines != 1) && (IOSVersion < 7.0f))
        {
            label.adjustsLetterSpacingToFitWidth = YES;
        }else{}
    }else{}
}

// 清除PerformRequests和notification
+ (void)cancelPerformRequestAndNotification:(UIViewController *)viewCtrl
{
    if (viewCtrl)
    {
        //[[viewCtrl class] cancelPreviousPerformRequestsWithTarget:viewCtrl];
        [[NSNotificationCenter defaultCenter] removeObserver:viewCtrl];
    }else{}
}

// 重设scroll view的内容区域和滚动条区域
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar
{
    [[self class] resetScrlView:sclView contentInsetWithNaviBar:bHasNaviBar tabBar:bHasTabBar iOS7ContentInsetStatusBarHeight:0 inidcatorInsetStatusBarHeight:0];
}
+ (void)resetScrlView:(UIScrollView *)sclView contentInsetWithNaviBar:(BOOL)bHasNaviBar tabBar:(BOOL)bHasTabBar iOS7ContentInsetStatusBarHeight:(NSInteger)iContentMulti inidcatorInsetStatusBarHeight:(NSInteger)iIndicatorMulti
{
    if (sclView)
    {
        UIEdgeInsets inset = sclView.contentInset;
        UIEdgeInsets insetIndicator = sclView.scrollIndicatorInsets;
        CGPoint ptContentOffset = sclView.contentOffset;
        CGFloat fTopInset = bHasNaviBar ? NaviBarHeight : 0.0f;
        CGFloat fTopIndicatorInset = bHasNaviBar ? NaviBarHeight : 0.0f;
        CGFloat fBottomInset = bHasTabBar ? TabBarHeight : 0.0f;
        
        fTopInset += StatusBarHeight;
        fTopIndicatorInset += StatusBarHeight;
        
        if (IsiOS7Later)
        {
            fTopInset += iContentMulti * StatusBarHeight;
            fTopIndicatorInset += iIndicatorMulti * StatusBarHeight;
        }else{}
        
        inset.top += fTopInset;
        inset.bottom += fBottomInset;
        [sclView setContentInset:inset];
        
        insetIndicator.top += fTopIndicatorInset;
        insetIndicator.bottom += fBottomInset;
        [sclView setScrollIndicatorInsets:insetIndicator];
        
        ptContentOffset.y -= fTopInset;
        [sclView setContentOffset:ptContentOffset];
    }else{}
}

/**
 *  颜色值转换
 *
 *  @param hexString hexString description
 *
 *  @return return value description
 */
+(UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

+(UILabel *)labelWith:(NSString *)title frame:(CGRect)frame textSize:(CGFloat)size textColor:(UIColor *)color lines:(NSInteger)lines aligment:(NSTextAlignment)aligment{
    
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = title;
    label.textAlignment = aligment;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = color;
    label.numberOfLines = lines;
    return label;
}


@end
