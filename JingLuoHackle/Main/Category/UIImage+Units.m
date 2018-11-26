//
//  UIImage+Units.m
//  JingLuoHackle
//
//  Created by 刘晓明 on 2018/9/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "UIImage+Units.h"

@implementation UIImage (Units)

+(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
