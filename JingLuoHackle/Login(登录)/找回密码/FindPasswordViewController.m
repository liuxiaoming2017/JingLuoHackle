//
//  FindPassword.m
//  Voicediagno
//
//  Created by wangfeng on 14-7-24.
//  Copyright (c) 2014年 wangfeng. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "Global.h"
#import "SBJson.h"
#import "ASIFormDataRequest.h"
#import <sys/utsname.h>
#import "SonAccount.h"
#import <CommonCrypto/CommonDigest.h>
SonAccount *son;
@interface FindPasswordViewController ()
@property (nonatomic ,retain) UIView *dishiView;
@end

@implementation FindPasswordViewController
@synthesize RepInputphoneTF;
@synthesize TtempInputsecTF;
@synthesize NewInputSecTF;
- (void)dealloc{
    [super dealloc];
    [RepInputphoneTF release];
    [TtempInputsecTF release];
    [NewInputSecTF release];
    [_AgainInputSecTF release];
    [_pYzmTF release];
    [TempSec release];
    [timer release];
    [_dishiView release];
    [YZMbtn release];
    [YZMcode release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.labelText = LocalString(@"加载中...");
    [progress_ show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    [progress_ release];
    progress_ = nil;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  //  [self setNaviBarTitle:[UIImage imageNamed:@"a_wangjimima"]];
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    [self setNaviBarTitle:LocalString(@"忘记密码")];
        _dishiView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
       // self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_dishiView];
        [_dishiView release];

    UIImage *registrationImageTextField = [UIImage imageNamed:@"RegistTF_bg.png"];
    CGFloat x = (SCREEN_WIDTH - registrationImageTextField.size.width * 0.5) * 0.5;
    
    NSLog(@"x = %f",x);
    //设置手机号框
    UITextField* registrationTF=[[ UITextField alloc] init];
    registrationTF.frame=CGRectMake(x, 64+27, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    registrationTF.borderStyle=UITextBorderStyleNone;
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    imageLayer.contents = (id) registrationImageTextField.CGImage;
    [registrationTF.layer addSublayer:imageLayer];
    registrationTF.font=[UIFont systemFontOfSize:14];
    UIImage* Regist_Tele=[UIImage imageNamed:@"Regist_Tele.png"];
    CGRect frame = [registrationTF frame];  //为你定义的UITextField
    frame.size.width = Regist_Tele.size.width/2+16.5+11.5;
    UIImageView* RegistImgView=[[UIImageView alloc] init];
    RegistImgView.frame=CGRectMake(16.5, 12.5, Regist_Tele.size.width/2, Regist_Tele.size.height/2);
    RegistImgView.image=Regist_Tele;
    UIView *leftview1 = [[UIView alloc] initWithFrame:frame];
    [leftview1 addSubview:RegistImgView];
    [RegistImgView release];
    registrationTF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    registrationTF.leftView = leftview1;
    [leftview1 release];
    registrationTF.delegate=self;
    registrationTF.placeholder=LocalString(@"请输入您的手机号");
    registrationTF.returnKeyType=UIReturnKeyNext;
    registrationTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    self.RepInputphoneTF=registrationTF;
    [_dishiView addSubview:self.RepInputphoneTF];
    [registrationTF release];

    
    //设置密码框
    UITextField* Regist_Sec_TF=[[ UITextField alloc] init];
    Regist_Sec_TF.frame=CGRectMake(x, registrationTF.frame.origin.y+registrationTF.frame.size.height+8, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    Regist_Sec_TF.borderStyle=UITextBorderStyleNone;
    CALayer *SecimageLayer = [CALayer layer];
    SecimageLayer.frame = CGRectMake(0, 0, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    SecimageLayer.contents = (id) registrationImageTextField.CGImage;
    [Regist_Sec_TF.layer addSublayer:SecimageLayer];
    Regist_Sec_TF.font=[UIFont systemFontOfSize:14];
    Regist_Sec_TF.returnKeyType=UIReturnKeyNext;
    UIImage* Regist_Sec=[UIImage imageNamed:@"Regist_passwork.png"];
    CGRect frame_sec = [Regist_Sec_TF frame];  //为你定义的UITextField
    frame_sec.size.width = Regist_Sec.size.width/2+16.5+11.5;
    UIImageView* Regist_sec_ImgView=[[UIImageView alloc] init];
    Regist_sec_ImgView.frame=CGRectMake(16.5, 12.5, Regist_Sec.size.width/2, Regist_Sec.size.height/2);
    Regist_sec_ImgView.image=Regist_Sec;
    UIView *left_secview = [[UIView alloc] initWithFrame:frame_sec];
    [left_secview addSubview:Regist_sec_ImgView];
    [Regist_sec_ImgView release];
    Regist_Sec_TF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    Regist_Sec_TF.leftView = left_secview;
    [left_secview release];
    Regist_Sec_TF.delegate=self;
    Regist_Sec_TF.secureTextEntry=YES;
    Regist_Sec_TF.placeholder=LocalString(@"请输入您的新密码");
    self.TtempInputsecTF=Regist_Sec_TF;
    [_dishiView addSubview:Regist_Sec_TF];
    [Regist_Sec_TF release];
    
   
    
    
    UITextField* sureSecTF=[[ UITextField alloc] init];
    sureSecTF.frame=CGRectMake(x, Regist_Sec_TF.frame.origin.y+Regist_Sec_TF.frame.size.height+8, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    sureSecTF.borderStyle=UITextBorderStyleNone;
    
    CALayer *Sure_SecimageLayer = [CALayer layer];
    Sure_SecimageLayer.frame = CGRectMake(0, 0, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    Sure_SecimageLayer.contents = (id) registrationImageTextField.CGImage;
    [sureSecTF.layer addSublayer:Sure_SecimageLayer];
    
    sureSecTF.font=[UIFont systemFontOfSize:14];
    sureSecTF.delegate=self;
    
    UIImage* Regist_Sure_Sec=[UIImage imageNamed:@"Regist_surepass.png"];
    CGRect frame__Sure_sec = [sureSecTF frame];  //为你定义的UITextField
    frame__Sure_sec.size.width = Regist_Sure_Sec.size.width/2+16.5+11.5;
    UIImageView* Regist_Sure_sec_ImgView=[[UIImageView alloc] init];
    Regist_Sure_sec_ImgView.frame=CGRectMake(16.5, 12.5, Regist_Sure_Sec.size.width/2, Regist_Sure_Sec.size.height/2);
    Regist_Sure_sec_ImgView.image=Regist_Sure_Sec;
    UIView *left_Sure_secview = [[UIView alloc] initWithFrame:frame__Sure_sec];
    [left_Sure_secview addSubview:Regist_Sure_sec_ImgView];
    [Regist_Sure_sec_ImgView release];
    sureSecTF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    sureSecTF.leftView = left_Sure_secview;
    [left_Sure_secview release];
    sureSecTF.secureTextEntry=YES;
    sureSecTF.returnKeyType=UIReturnKeyNext;
    sureSecTF.placeholder=LocalString(@"请确认您的新密码");
    self.NewInputSecTF=sureSecTF;
    [_dishiView addSubview:sureSecTF];
    [sureSecTF release];
    
    
    UIImage* YzmImg=[UIImage imageNamed:@"Regist_yzm_bg.png"];
    
    UITextField* YZMTF=[[ UITextField alloc] init];
    YZMTF.frame=CGRectMake(x, sureSecTF.frame.origin.y+sureSecTF.frame.size.height+8, YzmImg.size.width/2, YzmImg.size.height/2);
    YZMTF.borderStyle=UITextBorderStyleNone;
    
    CALayer *YzmimageLayer = [CALayer layer];
    YzmimageLayer.frame = CGRectMake(0, 0, YzmImg.size.width/2, YzmImg.size.height/2);
    YzmimageLayer.contents = (id) YzmImg.CGImage;
    [YZMTF.layer addSublayer:YzmimageLayer];
    
    UIImage* Regist_Yzm=[UIImage imageNamed:@"Regist_SMS.png"];
    CGRect frame_Yzm = [YZMTF frame];  //为你定义的UITextField
    frame_Yzm.size.width = Regist_Yzm.size.width/2+16.5+11.5;
    UIImageView* Regist_Yzm_ImgView=[[UIImageView alloc] init];
    Regist_Yzm_ImgView.frame=CGRectMake(16.5, 12.5, Regist_Yzm.size.width/2, Regist_Yzm.size.height/2);
    Regist_Yzm_ImgView.image=Regist_Yzm;
    UIView *left_Yzm_view = [[UIView alloc] initWithFrame:frame_Yzm];
    [left_Yzm_view addSubview:Regist_Yzm_ImgView];
    [Regist_Yzm_ImgView release];
    YZMTF.leftViewMode = UITextFieldViewModeAlways;  //左边距为15pix
    YZMTF.leftView = left_Yzm_view;
    [left_Yzm_view release];
    
    YZMTF.font=[UIFont systemFontOfSize:14];
    YZMTF.delegate=self;
    YZMTF.placeholder=LocalString(@"请输入手机验证码");
    YZMTF.returnKeyType=UIReturnKeyDone;
    self.pYzmTF=YZMTF;
    [_dishiView addSubview:YZMTF];
    [YZMTF release];
    //
    UIImage* ObtainYzm_img=[UIImage imageNamed:@"Regist_YZM.png"];
    UIButton *YZMButton=[UIButton buttonWithType:UIButtonTypeCustom];
    YZMButton.frame=CGRectMake(YZMTF.frame.origin.x+YZMTF.frame.size.width+23.5-7,  sureSecTF.frame.origin.y+sureSecTF.frame.size.height+8, ObtainYzm_img.size.width/2+7,ObtainYzm_img.size.height/2);
    [YZMButton setBackgroundImage:ObtainYzm_img forState:UIControlStateNormal];
    [YZMButton setTitle:LocalString(@"获取验证码") forState:UIControlStateNormal];
    [YZMButton addTarget:self action:@selector(userYZMButton) forControlEvents:UIControlEventTouchUpInside];
    [YZMButton setTitleColor:[UIColor colorWithRed:112.0f/255.0f green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    YZMButton.titleLabel.font=[UIFont systemFontOfSize:13];
    YZMbtn=YZMButton;
    [_dishiView addSubview:YZMbtn];

    UIButton *findpsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *findImg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Find_Btn" ofType:@"png"]];
    //[findpsButton setImage:findImg forState:UIControlStateNormal];
    [findpsButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromHex(0X4FAEFE)] forState:UIControlStateNormal];
   // findpsButton.frame=CGRectMake((SCREEN_WIDTH-findImg.size.width/2)/2,YZMButton.frame.origin.y+YZMButton.frame.size.height+19, findImg.size.width/2,findImg.size.height/2);
    findpsButton.frame = CGRectMake(YZMTF.left, YZMButton.frame.origin.y+YZMButton.frame.size.height+19, sureSecTF.width, 45);
    [findpsButton setTitle:LocalString(@"提交") forState:UIControlStateNormal];
    findpsButton.layer.cornerRadius = 3.0;
    findpsButton.clipsToBounds = YES;
    [findpsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[findpsButton setTitleShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f] forState:UIControlStateNormal];
    //findpsButton.titleLabel.shadowOffset=CGSizeMake(0.0f, -1.0f);
    [findpsButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [findpsButton addTarget:self action:@selector(userfindpasswordButton) forControlEvents:UIControlEventTouchUpInside];
    [_dishiView addSubview:findpsButton];
    ptCenter= self.view.center;
    pageNo=300;
    STtimeer=60;
    // Do any additional setup after loading the view.
}



-(void)userYZMButton
{
    if (self.RepInputphoneTF.text.length==0) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"登录手机号不能为空") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/password/captchaPassword.jhtml",UrlPre];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    
    /**
     *  MD5加密后的字符串
     */
    NSString *iPoneNumber = [NSString stringWithFormat:@"%@xinxijishubu",self.RepInputphoneTF.text];
    NSString *iPoneNumberMds = [self md5:iPoneNumber];
    
    [request setPostValue:self.RepInputphoneTF.text forKey:@"username"];
    [request setPostValue:timeSp forKey:@"time"];
    [request setPostValue:iPoneNumberMds forKey:@"UserPhoneKey"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    
    [request setDidFailSelector:@selector(requestYZMError:)];
    [request setDidFinishSelector:@selector(requestYZMCompleted:)];
    [request startAsynchronous];

}

- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

- (void)requestYZMError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"短信验证码发送失败，请重试") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
    [av show];
    [av release];
    return;
}
- (void)requestYZMCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    if (status!=nil)
    {
        if ([status intValue]==100) {
            
            LPPopup *popup = [LPPopup popupWithText:LocalString(@"请在300秒内输入验证码")];
            CGPoint point=self.view.center;
            point.y=point.y+130;
            [popup showInView:self.view
                centerAtPoint:point
                     duration:5.0f
                   completion:nil];
            
           YZMcode= [NSString stringWithString:[dic objectForKey:@"data"]];//;
            timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(getResults)
                                                 userInfo:nil
                                                  repeats:YES];
        }
        
        else if ([status intValue]==44)
        {
            [self hudWasHidden:nil];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"登录超时，请重新登录") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
            av.tag = 100008;
            [av show];
            [av release];
            return;
        }else{
            [self hudWasHidden:nil];
            NSString *str = [dic objectForKey:@"data"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:str delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
            //av.tag = 100008;
            [av show];
            [av release];
            return;
        }
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"短信验证码发送失败，请重试") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
        
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==100008)
    {
//        LoginsViewController *loginVC = [[LoginsViewController alloc]init];
//        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
-(void)getResults
{
    if (pageNo==0)
    {
        [timer invalidate];
        pageNo=300;
        YZMbtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [YZMbtn setTitle:LocalString(@"获取验证码") forState:UIControlStateNormal];
        return;
    }
    YZMbtn.titleLabel.font=[UIFont systemFontOfSize:7];
    [YZMbtn setTitle:[NSString stringWithFormat:@"请在%i秒内输入验证码",pageNo--] forState:UIControlStateNormal];
}


-(void)userfindpasswordButton
{
    if (self.TtempInputsecTF.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"临时密码不能为空") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    if (self.TtempInputsecTF.text.length<6||self.TtempInputsecTF.text.length>20)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"数字或字符组合") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    
  
    if (self.NewInputSecTF.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"新密码不能为空") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    if (self.NewInputSecTF.text.length<6||self.NewInputSecTF.text.length>20) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"请数字或字符组合") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
   
    
    if (![self.NewInputSecTF.text isEqualToString:self.TtempInputsecTF.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"两次输入的密码不一致") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
   // NSString* md5str=[UtilityFunc md5:self.AgainInputSecTF.text];
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/password/resetPassword.jhtml",UrlPre];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request setPostValue:self.RepInputphoneTF.text forKey:@"username"];
    [request setPostValue:self.pYzmTF.text forKey:@"code"];
    [request setPostValue:self.TtempInputsecTF.text forKey:@"newPassword"];
    [request setPostValue:timeSp forKey:@"time"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestFindPassError:)];
    [request setDidFinishSelector:@selector(requestFindPassCompleted:)];
    [request startAsynchronous];
}


- (void)requestFindPassError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"抱歉,修改密码失败,请重试") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
    [av show];
    [av release];
    return; 
}
- (void)requestFindPassCompleted:(ASIHTTPRequest *)request
{
    
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    if (status!=nil)
    {
        if ([status intValue]==100) {
        
            [self userLogin];
        }
        else if ([status intValue]==44)
        {
            [self hudWasHidden:nil];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"登录超时，请重新登录") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
            av.tag = 100008;
            [av show];
            [av release];
            return;
        }else{
            [self hudWasHidden:nil];
            NSString *str = [dic objectForKey:@"data"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:str delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
            //av.tag = 100008;
            [av show];
            [av release];
            return;
        }

//        else
//        {
//            [self hudWasHidden:nil];
//            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
//            av.tag  = 100008;
//            [av show];
//            [av release];
//            return;
//        }
    }
}
//登录功能
-(void) userLogin
{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString* devicesname=NULL;
    if ([deviceString isEqualToString:@"iPhone1,1"]) {
        devicesname=@"iPhone 2G";
    }
    else if ([deviceString isEqualToString:@"iPhone1,2"])
    {
        devicesname=@"iPhone 3G";
    }
    else if ([deviceString isEqualToString:@"iPhone2,1"])
    {
        devicesname=@"iPhone 3GS";
    }
    else if ([deviceString isEqualToString:@"iPhone3,1"])
    {
        devicesname=@"iPhone 4";
    }
    else if ([deviceString isEqualToString:@"iPhone3,2"])
    {
        devicesname=@"iPhone 4";
    }
    else if ([deviceString isEqualToString:@"iPhone3,3"])
    {
        devicesname=@"iPhone 4";
    }
    else if ([deviceString isEqualToString:@"iPhone4,1"])
    {
        devicesname=@"iPhone 4S";
    }
    else if ([deviceString isEqualToString:@"iPhone5,1"])
    {
        devicesname=@"iPhone 5";
    }
    else if ([deviceString isEqualToString:@"iPhone5,2"])
    {
        devicesname=@"iPhone 5";
    }
    else if ([deviceString isEqualToString:@"iPhone5,3"])
    {
        devicesname=@"iPhone 5c";
    }
    else if ([deviceString isEqualToString:@"iPhone5,4"])
    {
        devicesname=@"iPhone 5c";
    }
    else if ([deviceString isEqualToString:@"iPhone6,1"])
    {
        devicesname=@"iPhone 5s";
    }
    else if ([deviceString isEqualToString:@"iPhone6,2"])
    {
        devicesname=@"iPhone 5s";
    }
    else if ([deviceString isEqualToString:@"iPod1,1"])
    {
        devicesname=@"iPod touch 2G";
    }
    else if ([deviceString isEqualToString:@"iPod2,1"])
    {
        devicesname=@"iPod touch 2G";
    }
    else if ([deviceString isEqualToString:@"iPod3,1"])
    {
        devicesname=@"iPod touch 3G";
    }
    else if ([deviceString isEqualToString:@"iPod4,1"])
    {
        devicesname=@"iPod touch 4G";
    }
    else if ([deviceString isEqualToString:@"iPod5,1"])
    {
        devicesname=@"iPod touch 5G";
    }
    else
    {
        devicesname=@"";
    }
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSString* widthheight=[NSString stringWithFormat:@"%d*%d",(int)width,(int)height ];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/login/commit.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request setPostValue:@"beta1.4" forKey:@"softver"];
    [request setPostValue:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
    [request setPostValue:widthheight forKey:@"resolution"];
    [request setPostValue:self.TtempInputsecTF.text forKey:@"password"];
    [request setPostValue:self.RepInputphoneTF.text forKey:@"username"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestLoginError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestLoginCompleted:)];
    [request startAsynchronous];
}
- (void)requestLoginCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    
    if (status!=nil)
    {
        if ([status intValue]==100) {
         
            id data=[dic objectForKey:@"data"];
         
            g_userInfo.token=[data objectForKey:@"token"];
            g_userInfo.JSESSIONID=[data objectForKey:@"JSESSIONID"];
            id member=[data objectForKey:@"member"];
            g_userInfo.uid=[member objectForKey:@"id"];
            // id menberchild=[member objectForKey:@"mengberchild"];
            g_userInfo.UserName=[member objectForKey:@"username"];
            g_userInfo.Name=[member objectForKey:@"name"];
            g_userInfo.address=[member objectForKey:@"address"];
            g_userInfo.birthday=[member objectForKey:@"birthday"];
            g_userInfo.gender=[member objectForKey:@"gender"];
            g_userInfo.idNumber=[member objectForKey:@"idNumber"];
            g_userInfo.identityType=[member objectForKey:@"identityType"];
            g_userInfo.isMedicare=[member objectForKey:@"isMedicare"];
            g_userInfo.phone=[member objectForKey:@"phone"];
            g_userInfo.memberImage=[member objectForKey:@"memberImage"];
             g_userInfo.PassWork=self.TtempInputsecTF.text;
//            MainViewController *mainview=[[MainViewController alloc]init];
//            [self.navigationController pushViewController:mainview animated:YES];
//            [mainview release];
        }
        else if ([status intValue]==44)
        {
            [self hudWasHidden:nil];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"登录超时，请重新登录") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
            av.tag = 100008;
            [av show];
            [av release];
            return;
        }else{
            [self hudWasHidden:nil];
            NSString *str = [dic objectForKey:@"data"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:str delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
            //av.tag = 100008;
            [av show];
            [av release];
            return;
        }
    }
}

- (void)requestLoginError:(ASIHTTPRequest *)request
{
   [self hudWasHidden:nil];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"抱歉登录失败，请重试") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
    [av show];
    [av release];
    return;
    NSString* reqstr=[request responseString];
    NSLog(@"返回数据==%@",reqstr);
};
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField!=self.RepInputphoneTF) {
    [self performSelector:@selector(resizeViewForInput:) withObject:textField];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.RepInputphoneTF) {
        [self.TtempInputsecTF becomeFirstResponder];
    }
    if (textField==self.TtempInputsecTF) {
        [self.NewInputSecTF becomeFirstResponder];
    }
    if (textField==self.NewInputSecTF) {
        [self.pYzmTF becomeFirstResponder];
       
    }
    if (textField==self.pYzmTF) {
        [textField resignFirstResponder];
        [self restoreView];
    }
    
  
    return YES;
}

-(void)resizeViewForInput:(id)sender
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    if (iPhone5) {
        
        _dishiView.center = CGPointMake(ptCenter.x, ptCenter.y-50);
    }
    else
    {
        _dishiView.center = CGPointMake(ptCenter.x, ptCenter.y-120);
    }
    
    [UIView commitAnimations];
}
-(void)restoreView
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    _dishiView.center = CGPointMake(ptCenter.x, ptCenter.y);
    [UIView commitAnimations];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
