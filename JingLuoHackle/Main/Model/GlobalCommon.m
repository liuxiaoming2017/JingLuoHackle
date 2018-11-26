//
//  GlobalCommon.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/9.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "GlobalCommon.h"

@implementation GlobalCommon

//弹出提示信息，N秒后消失
+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)time
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [GlobalCommon showMessage:message duration:time onView:window];
}

+ (void)showMessage2:(NSString *)message duration2:(NSTimeInterval)time
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [GlobalCommon showMessage2:message duration2:time onView2:window];
}

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)time onView:(UIView *)view
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *lastView = [window viewWithTag:1111111];
    if(lastView){
        [lastView removeFromSuperview];
    }
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.9f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    showview.tag = 1111111;
    [view addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(ScreenWidth/2, 999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
    label.frame = CGRectMake(10, 15, labelSize.width + 20, labelSize.height);
    label.text = message;
    label.numberOfLines = 5;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    [showview addSubview:label];
    
//    showview.frame = CGRectMake((screenSize.width - labelSize.width - 40)/2,
//                                (screenSize.height - labelSize.height - 20)/2,
//                                labelSize.width+40,
//                                labelSize.height+30);
    showview.frame = CGRectMake((screenSize.width - labelSize.width - 40)/2,
                                ScreenHeight-labelSize.height-65,
                                labelSize.width+40,
                                labelSize.height+30);
    
    NSLog(@"show:%@",NSStringFromCGRect(showview.frame));
    
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+ (void)showMessage2:(NSString *)message duration2:(NSTimeInterval)time onView2:(UIView *)view
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *lastView = [window viewWithTag:1111111];
    if(lastView){
        [lastView removeFromSuperview];
    }
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 0.9f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    showview.tag = 1111111;
    [view addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(ScreenWidth/2-20, 999)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes context:nil].size;
    
    label.frame = CGRectMake(10, 15, ScreenWidth/2-20, labelSize.height);
    label.text = message;
    label.numberOfLines = 5;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    [showview addSubview:label];
    
    showview.frame = CGRectMake((screenSize.width - ScreenWidth/2)/2,
                                    (screenSize.height - labelSize.height - 20)/2,
                                    ScreenWidth/2,
                                    labelSize.height+30);
//    showview.frame = CGRectMake((screenSize.width - labelSize.width - 40)/2,
//                                ScreenHeight-labelSize.height-65,
//                                labelSize.width+40,
//                                labelSize.height+30);
    
    NSLog(@"show:%@",NSStringFromCGRect(showview.frame));
    
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+(NSString *)getSubjectSnFrom:(NSString *)subjectName{
    if ([subjectName isEqualToString:@"大宫"]) {
        return @"JLBS-G1";
    }else if ([subjectName isEqualToString:@"加宫"]) {
        return @"JLBS-G2";
    }else if ([subjectName isEqualToString:@"上宫"]) {
        return @"JLBS-G3";
    }else if ([subjectName isEqualToString:@"少宫"]) {
        return @"JLBS-G4";
    }else if ([subjectName isEqualToString:@"左角宫"]) {
        return @"JLBS-G5";
    }else if ([subjectName isEqualToString:@"上商"]) {
        return @"JLBS-S1";
    }else if ([subjectName isEqualToString:@"少商"]) {
        return @"JLBS-S2";
    }else if ([subjectName isEqualToString:@"钛商"]) {
        return @"JLBS-S3";
    }else if ([subjectName isEqualToString:@"右商"]) {
        return @"JLBS-S4";
    }else if ([subjectName isEqualToString:@"左商"]) {
        return @"JLBS-S5";
    }else if ([subjectName isEqualToString:@"大角"]) {
        return @"JLBS-J1";
    }else if ([subjectName isEqualToString:@"判角"]) {
        return @"JLBS-J2";
    }else if ([subjectName isEqualToString:@"上角"]) {
        return @"JLBS-J3";
    }else if ([subjectName isEqualToString:@"少角"]) {
        return @"JLBS-J4";
    }else if ([subjectName isEqualToString:@"钛角"]) {
        return @"JLBS-J5";
    }else if ([subjectName isEqualToString:@"判徵"]) {
        return @"JLBS-Z1";
    }else if ([subjectName isEqualToString:@"上徵"]) {
        return @"JLBS-Z2";
    }else if ([subjectName isEqualToString:@"少徵"]) {
        return @"JLBS-Z3";
    }else if ([subjectName isEqualToString:@"右徵"]) {
        return @"JLBS-Z4";
    }else if ([subjectName isEqualToString:@"质徵"]) {
        return @"JLBS-Z5";
    }else if ([subjectName isEqualToString:@"大羽"]) {
        return @"JLBS-Y1";
    }else if ([subjectName isEqualToString:@"上羽"]) {
        return @"JLBS-Y2";
    }else if ([subjectName isEqualToString:@"少羽"]) {
        return @"JLBS-Y3";
    }else if ([subjectName isEqualToString:@"桎羽"]) {
        return @"JLBS-Y4";
    }else if ([subjectName isEqualToString:@"众羽"]) {
        return @"JLBS-Y5";
    }
    return nil;
}

+(NSString *)getSportTypeFrom:(NSString *)subjectName
{
    if ([subjectName isEqualToString:@"大宫"] || [subjectName isEqualToString:@"加宫"] || [subjectName isEqualToString:@"上宫"] || [subjectName isEqualToString:@"少宫"] || [subjectName isEqualToString:@"左角宫"]) {
        //return @"俯身下探加强式";
        return @"6";
    }else if ([subjectName isEqualToString:@"上商"] || [subjectName isEqualToString:@"钛商"] || [subjectName isEqualToString:@"右商"] || [subjectName isEqualToString:@"左商"]) {
        //return @"剑指后仰式";
        return @"2";
    }else if ([subjectName isEqualToString:@"少商"]) {
        //return @"体侧弯腰式";
        return @"5";
    }else if ([subjectName isEqualToString:@"大角"] || [subjectName isEqualToString:@"上角"] || [subjectName isEqualToString:@"少角"] || [subjectName isEqualToString:@"钛角"] || [subjectName isEqualToString:@"判角"]) {
        //return @"体侧弯腰式";
        return @"5";
    }else if ([subjectName isEqualToString:@"判徵"] || [subjectName isEqualToString:@"上徵"] || [subjectName isEqualToString:@"少徵"] || [subjectName isEqualToString:@"右徵"] || [subjectName isEqualToString:@"质徵"]) {
        //return @"左右扭转式";
        return @"4";
    }else if ([subjectName isEqualToString:@"大羽"] || [subjectName isEqualToString:@"上羽"] || [subjectName isEqualToString:@"少羽"] || [subjectName isEqualToString:@"桎羽"] || [subjectName isEqualToString:@"众羽"]) {
        //return @"俯身下探式";
        return @"3";
    }
    return nil;
}

+(NSString *)getSportNameWithIndex:(NSInteger)index
{
    if(index == 1){
        return LocalString(@"预备");
    }else if(index == 2){
        return LocalString(@"第一式");
    }
    else if(index == 3){
        return LocalString(@"第二式");
    }else if (index == 4){
        return LocalString(@"第三式");
    }else if (index == 5){
        return LocalString(@"第四式");
    }else if (index == 6){
        return LocalString(@"第五式");
    }else if (index == 7){
        return LocalString(@"第六式");
    }else if (index == 8){
        return LocalString(@"第七式");
    }else if (index == 9){
        return LocalString(@"第八式");
    }
    return LocalString(@"全部");
}

+(NSString*) Createfilepath
{
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *str = [GlobalCommon userInfoTmp];
    
    NSString *folderPath = [path stringByAppendingPathComponent:str];
    NSLog(@"%@",folderPath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    if(!fileExists)
    {
        
        [fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [GlobalCommon addSkipBackupAttributeToItemAtPath:folderPath];
    return folderPath;
}

+ (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

+ (NSString *)userInfoTmp{
    NSMutableDictionary *dic = [UtilityFunc mutableDictionaryFromUserInfo];
    
    NSString *str = [NSString stringWithFormat:@"tmp/%@/",dic[@"USERNAME"]];
    
    
    return str;
}

+ (UIImage*)createImageWithColor: (UIColor*) color

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

//对图片尺寸进行压缩--
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
