//
//  RegistrationViewController.h
//  Voicediagno
//
//  Created by 王锋 on 14-7-3.
//  Copyright (c) 2014年 王锋. All rights reserved.
//

#import "CustomViewController.h"
#import "MBProgressHUD.h"
@interface RegistrationViewController : CustomViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    CGPoint ptCenter;
    NSTimer* timer;
    int pageNo;
    int STtimeer;
    UIButton* YZMbtn;
    NSString* YZMcode;
    BOOL isagreen;
    UIButton* btnagreen;
     MBProgressHUD* progress_;
}
@property(nonatomic,retain) UITextField* pregistrationTF;
@property (nonatomic,retain) UITextField* pRegist_Sec_TF;
@property(nonatomic,retain) UITextField*  pSecTF;
@property( nonatomic,retain) UITextField* pSureTF;
@property(nonatomic,retain) UITextField * pYzmTF;
@end
