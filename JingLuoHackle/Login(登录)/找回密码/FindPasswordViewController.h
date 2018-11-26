//
//  FindPassword.h
//  Voicediagno
//
//  Created by wangfeng on 14-7-24.
//  Copyright (c) 2014年 wangfeng. All rights reserved.
//

#import "CustomViewController.h"
#import "LPPopup.h"
#import "MBProgressHUD.h"
@interface FindPasswordViewController : CustomViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    CGPoint ptCenter;
    NSString* TempSec;
    NSTimer* timer;
    int pageNo;
    int STtimeer;
    UIButton* YZMbtn;
    NSString* YZMcode;
    MBProgressHUD* progress_;
}
@property( nonatomic,retain) UITextField* RepInputphoneTF;
@property( nonatomic,retain) UITextField* TtempInputsecTF;
@property(nonatomic,retain) UITextField * NewInputSecTF;
@property(nonatomic,retain) UITextField* AgainInputSecTF;
@property(nonatomic,retain) UITextField * pYzmTF;
@end
