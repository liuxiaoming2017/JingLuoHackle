//
//  shareCustomView.m
//  FounderReader-2.5
//
//  Created by 袁野 on 15/9/14.
//
//

#import "shareCustomView.h"
#import <MessageUI/MessageUI.h>
#import "UIView+Extension.h"

@implementation shareCustomView
@synthesize shareView;

//设备物理大小
#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]
//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    ScreenWidth/375.0f

static NSString *_content;
static id _image;
static NSString *_title;
static NSString *_url;
static FinishBlock _finishedBlock = nil;

+ (void)shareWithContentInWeb:(int)platformTag Content:(NSString *)content image:(id)image title:(NSString *)title url:(NSString *)url completion:(FinishBlock)finishBlock{
    int shareType = 0;
    switch (platformTag) {
        case 1:
            shareType = UMSocialPlatformType_WechatTimeLine;
            break;
        case 2:
            shareType = UMSocialPlatformType_WechatSession;
            break;
        case 3:
            shareType = UMSocialPlatformType_Sina;
            break;
        case 4:
            shareType = UMSocialPlatformType_Qzone;
            break;
        case 5:
            shareType = UMSocialPlatformType_QQ;
            break;
        case 6:
            shareType = UMSocialPlatformType_Email;
            break;
        case 7:
            shareType = UMSocialPlatformType_Sms;
            break;
        case 8:
            shareType = UMSocialPlatformType_UnKnown;
            break;
        default:
            break;
    }
    if ([content isKindOfClass:[NSString class]] || [content isEqualToString:@""]) {
        content = [NSString stringWithFormat:@"%@《%@》%@",NSLocalizedString(@"来自", nil),appName(),NSLocalizedString(@"新闻客户端", nil)];
    }
    _content = content;
    _image = image;
    _title = title;
    _url = url;
    _finishedBlock = finishBlock;
    [shareCustomView shareContentWithShareType:shareType];
}

+(void)shareWithContent:(NSString *)content image:(id)image title:(NSString *)title url:(NSString *)url type:(int)type completion:(FinishBlock)finishedBlock
{
    if ([content isKindOfClass:[NSString class]] || [content isEqualToString:@""]) {
        content = [NSString stringWithFormat:@"%@《%@》%@",NSLocalizedString(@"来自", nil),appName(),NSLocalizedString(@"经络梳理", nil)];
    }
    _content = content;
    _image = image;
    _title = title;
    _url = url;
    
    _finishedBlock = finishedBlock;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.0;
    blackView.tag = 440;
    [window addSubview:blackView];
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-230);
    button.tag = 500;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [blackView addSubview:button];

    CGFloat BGIMG_H = 130;
    if (IS_IPHONE_6) {
        BGIMG_H = 145;
    }else if (IS_IPHONE_6P) {
        BGIMG_H = 170;
    }
     UIView *_shareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight , ScreenWidth, BGIMG_H)];
    _shareView.backgroundColor = [UIColor whiteColor];
    _shareView.tag = 441;
    [window addSubview:_shareView];
    NSArray *btnImages = nil;
    NSArray *btnTitles = nil;
    NSArray *btnTypes = nil;
        btnImages = @[@"logo_wechat.png",@"logo_wechatmoments.png", @"logo_sinaweibo.png"];
        btnTitles = @[NSLocalizedString(@"微信好友",nil), NSLocalizedString(@"微信朋友圈",nil),  NSLocalizedString(@"新浪微博",nil)];
        btnTypes = [NSArray arrayWithObjects:
                             [NSNumber numberWithUnsignedInteger:UMSocialPlatformType_WechatSession],
                             [NSNumber numberWithUnsignedInteger:UMSocialPlatformType_WechatTimeLine],
                    
                             [NSNumber numberWithUnsignedInteger:UMSocialPlatformType_Sina],
                             nil];
 
    


    for (int i = 0; i < btnTypes.count; i++) {
    
        //row排数;col列数
        int row = i/4;
        int col = i%4;
        CGFloat ICON_W = 40*proportion;
        CGFloat MARGIN = 40*proportion;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30*proportion + col * (40+33)*proportion, 25 + row * (ICON_W + MARGIN), ICON_W, ICON_W)];
        [button setImage:[UIImage imageNamed:btnImages[i]] forState:UIControlStateNormal];
        
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [button setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

        UILabel *name = [[UILabel alloc]init];
        name.text = btnTitles[i];
        name.frame = CGRectMake(30 + col * (40+MARGIN), CGRectGetMaxY(button.frame )+ 7, 120, 15);
        name.font =[UIFont systemFontOfSize:15];
        name.textColor = [UIColor blackColor];
        name.centerX = button.centerX;
        name.textAlignment = NSTextAlignmentCenter;
        [_shareView addSubview:name];
        button.tag = 3000 + [btnTypes[i] integerValue];
        [button addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:button];
    }

    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(10*proportion,_shareView.height - 40*proportion,ScreenWidth - 20*proportion,36*proportion)];
    cancleBtn.layer.cornerRadius = 3*proportion;
    cancleBtn.layer.borderWidth = 1;
    cancleBtn.layer.borderColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0].CGColor;
    [cancleBtn setTitle:NSLocalizedString(@"取消",nil) forState:UIControlStateNormal];
    [cancleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    cancleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancleBtn.tag = 339;
    [cancleBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_shareView addSubview:cancleBtn];
    
    blackView.alpha = 0;
    [UIView animateWithDuration:0.35f animations:^{
        _shareView.y -= _shareView.height;
        blackView.alpha = 0.6;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)shareBtnClick:(UIButton *)btn
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [window viewWithTag:440];
    UIView *shareView = [window viewWithTag:441];

    [UIView animateWithDuration:0.35f animations:^{
        blackView.alpha = 0;
        shareView.y += shareView.height;
    } completion:^(BOOL finished) {
        [shareView removeFromSuperview];
        [blackView removeFromSuperview];
    }];
    //取消按钮
    if(btn.tag == 339 || btn.tag == 500){
        return;
    }
    
    UMSocialPlatformType shareType = (UMSocialPlatformType)(btn.tag - 3000);
    [shareCustomView shareContentWithShareType:shareType];
}

//友盟分享
+(void)shareContentWithShareType:(UMSocialPlatformType)shareType{
    
    if([_image isKindOfClass:[NSString class]]){
        NSString *imageUrl = (NSString *)_image;
        NSLog(@"%@", imageUrl);
        
        //针对微信，先从客户端得到图片数据再分享，解决部分图片无法分享的问题
        if([imageUrl rangeOfString:@"newaircloud.com"].location != NSNotFound
           ){
            NSRange range = [imageUrl rangeOfString:@"@!"];
            if(range.location == NSNotFound){
                imageUrl = [imageUrl stringByAppendingString:@"@!sm"];
            }
            else{
                imageUrl = [imageUrl substringToIndex:range.location];
                imageUrl = [imageUrl stringByAppendingString:@"@!sm"];
            }
            
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
            NSData *jpgData = UIImageJPEGRepresentation([UIImage imageWithData:data], 0.7);
            UIImage *imageT1 = [UIImage imageWithData:jpgData];
            if(imageT1 == nil){
                _image = [UIImage imageNamed:@"app_icon"];
            }
            else{
                _image = [UIImage imageWithData:jpgData];
            }
        }
    }
     UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if(shareType == UMSocialPlatformType_WechatSession || shareType == UMSocialPlatformType_WechatTimeLine || shareType == UMSocialPlatformType_QQ || shareType == UMSocialPlatformType_Qzone || shareType == UMSocialPlatformType_Sina){
        
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_title descr:_content thumImage:_image];
    shareObject.webpageUrl = _url;
    messageObject.shareObject = shareObject;
   
    }else if (shareType == UMSocialPlatformType_Sms || shareType == UMSocialPlatformType_Email){
        NSString *msgContent = [NSString stringWithFormat:@"%@", _title];
        if(_url){
            
            msgContent = [msgContent stringByAppendingString:[NSString stringWithFormat:@"  %@: ", NSLocalizedString(@"链接", nil)]];
            msgContent = [msgContent stringByAppendingString:_url];
        }
        messageObject.text = msgContent;
    }else{//复制链接
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _url;
       // [Global showTip:NSLocalizedString(@"复制成功",nil)];
        [shareCustomView showMessage:@"复制成功" duration:2];
        return;
    }
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    [[UMSocialManager defaultManager] shareToPlatform:shareType messageObject:messageObject currentViewController:nil completion:^(id result, NSError *error) {
        if(error){
            [shareCustomView showMessage:[error description] duration:2];
//            [Global showTip:[error description]];
//            [UIAlertView showAlert:[error description]];
        }else{
            [shareCustomView showMessage:@"分享成功" duration:2];
            }
        /* 返回结果到网页 */
        int platformType = 0;
        switch (shareType) {
            case UMSocialPlatformType_WechatTimeLine:
                platformType = 1;
                break;
            case UMSocialPlatformType_WechatSession:
                platformType = 2;
                break;
            case UMSocialPlatformType_Sina:
                platformType = 3;
                break;
            case UMSocialPlatformType_Qzone:
                platformType = 4;
                break;
            case UMSocialPlatformType_QQ:
                platformType = 5;
                break;
            case UMSocialPlatformType_Email:
                platformType = 6;
                break;
            case UMSocialPlatformType_Sms:
                platformType = 7;
                break;
            case UMSocialPlatformType_UnKnown:
                platformType = 8;
                break;
            default:
                break;
        }
    }];
    
}

- (BOOL)isNilOrEmpty:(NSString *)str {
    
    if(![str isKindOfClass:[NSString class]])
        return YES;
    
    return (str == nil || str.length == 0);
}

NSString *appName()
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (void)showMessage:(NSString *)message duration:(NSTimeInterval)time {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [shareCustomView showMessage:message duration:time onView:window];
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
    
    showview.frame = CGRectMake((screenSize.width - labelSize.width - 40)/2,
                                (screenSize.height - labelSize.height - 20)/2,
                                labelSize.width+40,
                                labelSize.height+30);
    [UIView animateWithDuration:time animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end
