//
//  GlobalCommon.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalCommon : NSObject

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)time;

+ (void)showMessage2:(NSString *)message duration2:(NSTimeInterval)time;

+(NSString *)getSubjectSnFrom:(NSString *)subjectName;

+(NSString*) Createfilepath;

+(NSString *)getSportTypeFrom:(NSString *)nameStr;

+(NSString *)getSportNameWithIndex:(NSInteger)index;

//颜色转图片
+ (UIImage*)createImageWithColor: (UIColor*) color;

+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end
