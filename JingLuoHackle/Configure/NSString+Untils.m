//
//  NSString+Untils.m
//  JingLuoHackle
//
//  Created by 刘晓明 on 2018/9/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "NSString+Untils.h"

@implementation NSString (Untils)
-(float)widthStringwithfontSize:(float)fontSize andHeight:(float)height

{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName,nil];
    CGSize sizeToFit = [self boundingRectWithSize:CGSizeMake(2000, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return sizeToFit.width;
    
}

-(float)heightStringwithfontSize:(float)fontSize andWidth:(float)width
{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName,nil];
    CGSize sizeToFit = [self boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    
    return sizeToFit.height;
}

@end
