//
//  LoginViewControllerViewController.h
//  Voicediagno
//
//  Created by 王锋 on 14-6-12.
//  Copyright (c) 2014年 王锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CustomViewController.h"
@interface LoginViewControllerViewController : CustomViewController<UITextFieldDelegate,MBProgressHUDDelegate>
{
    
    UITextField *userNameBox;
    
    BOOL isCheck;
    MBProgressHUD* progress_;
}
@property (nonatomic,strong) UITextField *passWordBox;

-(void)initViewControl; //初始化界面控件
@end
