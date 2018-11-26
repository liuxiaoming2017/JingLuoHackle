//
//  RegistrationViewController.m
//  Voicediagno
//
//  Created by 王锋 on 14-7-3.
//  Copyright (c) 2014年 王锋. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Global.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import <sys/utsname.h>
#import "MessageViewController.h"

#import "LPPopup.h"
#import "DisclaimerViewController.h"
#import <CommonCrypto/CommonDigest.h>
@interface RegistrationViewController ()
@property (nonatomic ,retain) UIView *dishiView;
@end

@implementation RegistrationViewController
@synthesize pregistrationTF;
@synthesize pRegist_Sec_TF;
@synthesize pSecTF;
@synthesize pSureTF;
@synthesize pYzmTF;

- (void)dealloc{
    [super dealloc];
    [pregistrationTF release];
    [pRegist_Sec_TF release];
    [pSecTF release];
    [pSureTF release];
    [pYzmTF release];
    [timer release];
    [_dishiView release];
    [YZMbtn release];
    [YZMcode release];
    
    [btnagreen release];
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
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//-(void)viewWillAppear:(BOOL)animated
//{
//    
//            [UIView beginAnimations:@"resize for input" context:nil];
//            [UIView setAnimationDuration:0.3f];
//            self.view.center = CGPointMake(ptCenter.x, ptCenter.y);
//            [UIView commitAnimations];
//    
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *ReplacementImg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Regist_btn" ofType:@"png"]];
    
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    [self setNaviBarTitle:LocalString(@"注册")];
    
    _dishiView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    //_dishiView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_dishiView];
    [_dishiView release];
    UIImage *registrationImageTextField = [UIImage imageNamed:@"RegistTF_bg.png"];
    //设置手机号框
    UITextField* registrationTF=[[ UITextField alloc] init];
    registrationTF.frame=CGRectMake((SCREEN_WIDTH-ReplacementImg.size.width/2)/2, 64+27, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
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
    registrationTF.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    registrationTF.returnKeyType=UIReturnKeyNext;
    self.pregistrationTF=registrationTF;
    [_dishiView addSubview:self.pregistrationTF];
    [registrationTF release];
    
    //设置密码框
    UITextField* Regist_Sec_TF=[[ UITextField alloc] init];
    Regist_Sec_TF.frame=CGRectMake((SCREEN_WIDTH-ReplacementImg.size.width/2)/2, registrationTF.frame.origin.y+registrationTF.frame.size.height+8, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    Regist_Sec_TF.borderStyle=UITextBorderStyleNone;
    CALayer *SecimageLayer = [CALayer layer];
    SecimageLayer.frame = CGRectMake(0, 0, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    SecimageLayer.contents = (id) registrationImageTextField.CGImage;
    [Regist_Sec_TF.layer addSublayer:SecimageLayer];
    Regist_Sec_TF.font=[UIFont systemFontOfSize:14];
    Regist_Sec_TF.returnKeyType=UIReturnKeyNext;
    Regist_Sec_TF.secureTextEntry=YES;
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
    Regist_Sec_TF.placeholder=LocalString(@"请输入您的密码");
    self.pRegist_Sec_TF=Regist_Sec_TF;
    [_dishiView addSubview:Regist_Sec_TF];
    [Regist_Sec_TF release];

   
    UITextField* sureSecTF=[[ UITextField alloc] init];
    sureSecTF.frame=CGRectMake((SCREEN_WIDTH-ReplacementImg.size.width/2)/2, Regist_Sec_TF.frame.origin.y+Regist_Sec_TF.frame.size.height+8, registrationImageTextField.size.width/2, registrationImageTextField.size.height/2);
    sureSecTF.borderStyle=UITextBorderStyleNone;
    sureSecTF.secureTextEntry=YES;
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
    sureSecTF.returnKeyType=UIReturnKeyNext;
    sureSecTF.placeholder=LocalString(@"请确认您的密码");
    self.pSureTF=sureSecTF;
    [_dishiView addSubview:sureSecTF];
    [sureSecTF release];
 
    
    UIImage* YzmImg=[UIImage imageNamed:@"Regist_yzm_bg.png"];
    
    UITextField* YZMTF=[[ UITextField alloc] init];
    YZMTF.frame=CGRectMake((SCREEN_WIDTH-ReplacementImg.size.width/2)/2, sureSecTF.frame.origin.y+sureSecTF.frame.size.height+8, YzmImg.size.width/2, YzmImg.size.height/2);
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

    YZMTF.font=[UIFont systemFontOfSize:13];
//    YZMTF.delegate=self;
    YZMTF.placeholder=LocalString(@"请输入手机验证码");
    YZMTF.returnKeyType=UIReturnKeyDone;
    self.pYzmTF=YZMTF;
    [_dishiView addSubview:YZMTF];
    [YZMTF release];
    
//
    UIImage* ObtainYzm_img=[UIImage imageNamed:@"Regist_YZM"];
    UIButton *YZMButton=[UIButton buttonWithType:UIButtonTypeCustom];
    YZMButton.frame=CGRectMake(YZMTF.frame.origin.x+YZMTF.frame.size.width+23.5-7,  sureSecTF.frame.origin.y+sureSecTF.frame.size.height+8, ObtainYzm_img.size.width/2+7,ObtainYzm_img.size.height/2);
   // [YZMButton setImage:ObtainYzm_img forState:UIControlStateNormal];
    [YZMButton setBackgroundImage:ObtainYzm_img forState:UIControlStateNormal];
    [YZMButton setTitle:LocalString(@"获取验证码") forState:UIControlStateNormal];
    [YZMButton addTarget:self action:@selector(userYZMButton) forControlEvents:UIControlEventTouchUpInside];
    [YZMButton setTitleColor:[UIColor colorWithRed:112.0f/255.0f green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    YZMButton.titleLabel.font=[UIFont systemFontOfSize:13];
    YZMbtn=YZMButton;
    [_dishiView addSubview:YZMbtn];

    
   
    
    UIImage* tongyiImg=[UIImage imageNamed:@"checkboxyes.png"];
    UIButton* istongyi=[UIButton buttonWithType:UIButtonTypeCustom];
    [istongyi setImage:tongyiImg forState:UIControlStateNormal];
    [istongyi addTarget:self action:@selector(userisagreenButton:) forControlEvents:UIControlEventTouchUpInside];
    istongyi.frame=CGRectMake((SCREEN_WIDTH-ReplacementImg.size.width/2)/2, YZMButton.frame.origin.y+YZMButton.frame.size.height+19, tongyiImg.size.width, tongyiImg.size.height);

    [_dishiView addSubview:istongyi];

    UIButton* agreenxieyi=[UIButton buttonWithType:UIButtonTypeCustom];
    agreenxieyi.frame=CGRectMake(istongyi.frame.origin.x+istongyi.frame.size.width+11, YZMButton.frame.origin.y+YZMButton.frame.size.height+18, 280, 21);
    [agreenxieyi setTitleColor:[UtilityFunc colorWithHexString:@"#9b9b9b"] forState:UIControlStateNormal];
    [agreenxieyi addTarget:self action:@selector(isagreenButton) forControlEvents:UIControlEventTouchUpInside];
    [agreenxieyi setTitle:LocalString(@"我已阅读并同意服务条款") forState:UIControlStateNormal];
    agreenxieyi.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    agreenxieyi.titleLabel.font=[UIFont systemFontOfSize:13];
    [_dishiView addSubview:agreenxieyi];
    
    UIButton *RegistrationButton=[UIButton buttonWithType:UIButtonTypeCustom];
    
    //[RegistrationButton setImage:ReplacementImg forState:UIControlStateNormal];
    [RegistrationButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromHex(0X4FAEFE)] forState:UIControlStateNormal];
    RegistrationButton.layer.cornerRadius = 3.0;
    RegistrationButton.clipsToBounds = YES;
    [RegistrationButton setTitle:LocalString(@"注册并登录") forState:UIControlStateNormal];
    [RegistrationButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    RegistrationButton.frame=CGRectMake((SCREEN_WIDTH-ReplacementImg.size.width/2)/2,istongyi.frame.origin.y+istongyi.frame.size.height+19, ReplacementImg.size.width/2,ReplacementImg.size.height/2);
    [RegistrationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[RegistrationButton setTitleShadowColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f] forState:UIControlStateNormal];
    //RegistrationButton.titleLabel.shadowOffset=CGSizeMake(0.0f, -1.0f);
    //[RegistrationButton.titleLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [RegistrationButton addTarget:self action:@selector(userRegistrationButton) forControlEvents:UIControlEventTouchUpInside];
    [_dishiView addSubview:RegistrationButton];

    pageNo=300;
    STtimeer=60;
    isagreen=YES;
    ptCenter= self.view.center;
    // Do any additional setup after loading the view.
}

-(void)userisagreenButton:(id)sender
{
    UIButton* btn=(UIButton *)sender;
    if (isagreen==YES) {
        isagreen=NO;
        [btn setImage:[UIImage imageNamed:@"checkboxno.png"] forState:UIControlStateNormal];
    }
    else
    {
         isagreen=YES;
         [btn setImage:[UIImage imageNamed:@"checkboxyes.png"] forState:UIControlStateNormal];
    }
}
-(void)isagreenButton
{
    DisclaimerViewController* DisclaView=[[DisclaimerViewController alloc] init];
    [self.navigationController pushViewController:DisclaView animated:YES];
    
}
-(void)userYZMButton
{
    if (self.pregistrationTF.text.length==0) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"登录手机号不能为空") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    [self showHUD];
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/register/captcha.jhtml",UrlPre];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    /**
     *  MD5加密后的字符串
     */
    NSString *iPoneNumber = [NSString stringWithFormat:@"%@xinxijishubu",self.pregistrationTF.text];
    NSString *iPoneNumberMD5 = [self md5:iPoneNumber];
    
    [request setPostValue:self.pregistrationTF.text forKey:@"username"];
    [request setPostValue:iPoneNumberMD5 forKey:@"UserPhoneKey"];
    
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
           
            //[self.pYzmTF setText:[NSString stringWithString:[dic objectForKey:@"data"]]];
            YZMcode= [NSString stringWithString:[dic objectForKey:@"data"]];//;
            timer=[NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(getResults)
                                                 userInfo:nil
                                                  repeats:YES];
        }
        
        else
        {
            NSString *str = [dic objectForKey:@"data"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:str delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
            
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
-(void)userRegistrationButton
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    NSString* widthheight=[NSString stringWithFormat:@"%d*%d",(int)width,(int)height ];
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
   
    if (self.pregistrationTF.text.length==0) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"登录手机号不能为空") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    if (self.pregistrationTF.text.length<11) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"手机号格式错误，请正确输入您的手机号码") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    if (self.pRegist_Sec_TF.text.length==0) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"密码设置不能为空") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    if (self.pRegist_Sec_TF.text.length<6||self.pSecTF.text.length>20) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"数字或字符组合") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    if (self.pSureTF.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"密码确认不能为空") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    if (self.pSureTF.text.length<6||self.pSureTF.text.length>20) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"数字或字符组合") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    if (![self.pRegist_Sec_TF.text isEqualToString:self.pSureTF.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"两次输入的密码不一致") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    if (self.pYzmTF.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"请获取注册码") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    else
    {
    
    }
    
    if (!isagreen) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"请阅读条款") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        [av release];
        return;
    }
    NSString *UrlPre=URL_PRE;
    NSLog(@"手机型号：%@ 系统版本%@",devicesname, [[UIDevice currentDevice] systemVersion]);
    [self showHUD];
    NSString *aUrl = [NSString stringWithFormat:@"%@/register/commit.jhtml",UrlPre];
    NSLog(@"%@",aUrl);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
	[request setPostValue:@"beta1.4" forKey:@"softver"];
	[request setPostValue:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
	[request setPostValue:widthheight forKey:@"resolution"];
    [request setPostValue:self.pregistrationTF.text forKey:@"username"];
    [request setPostValue:devicesname forKey:@"brand"];
    [request setPostValue:devicesname forKey:@"devmodel"];
    [request setPostValue:self.pRegist_Sec_TF.text forKey:@"password"];
    [request setPostValue:self.pSureTF.text forKey:@"password2"];
    [request setPostValue:self.pYzmTF.text forKey:@"code"];
	[request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
	[request setDelegate:self];
	[request setDidFailSelector:@selector(requestRegisError:)];
	[request setDidFinishSelector:@selector(requestRegisCompleted:)];
    [request startAsynchronous];
    
}
- (void)requestRegisCompleted:(ASIHTTPRequest *)request
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
        else
        {
            [self hudWasHidden:nil];
            NSString *str = [dic objectForKey:@"data"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            ;
            [av show];
            [av release];
        }
    }
}
- (void)requestRegisError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];

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
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
	[request setPostValue:@"beta1.4" forKey:@"softver"];
	[request setPostValue:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
	[request setPostValue:widthheight forKey:@"resolution"];
    [request setPostValue:self.pRegist_Sec_TF.text forKey:@"password"];
    [request setPostValue:@"sdk" forKey:@"brand"];
    [request setPostValue:timeSp forKey:@"time"];
    [request setPostValue:devicesname forKey:@"devmodel"];
    [request setPostValue:self.pregistrationTF.text forKey:@"username"];
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
            
            g_userInfo.PassWork=self.pRegist_Sec_TF.text;
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
            NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
            if (dicTmp) {
                // [dicTmp setObject:@"1" forKey:@"ischeck"];
                [dicTmp setValue:@"1" forKey:@"ischeck"];
                [dicTmp setObject:self.pregistrationTF.text forKey:@"USERNAME"];
                [dicTmp setObject:self.pRegist_Sec_TF.text forKey:@"PASSWORDAES"];
            }
            [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
            [self GetMemberChild ];
            
//            MessageViewController *mainview=[[MessageViewController alloc]init];
//            [self.navigationController pushViewController:mainview animated:YES];
//            [mainview release];

        }
        else
        {
            NSString *str = [dic objectForKey:@"data"];
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            
            [av show];
            [av release];
            return;
        }
    }
}

- (void)requestLoginError:(ASIHTTPRequest *)request
{
     [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSLog(@"返回数据==%@",reqstr);
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉登录失败，请重试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];
    return;
};
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.pYzmTF)
    {
        [self performSelector:@selector(resizeViewForInput:) withObject:textField];
    }
}
-(void)resizeViewForInput:(id)sender
{
    [UIView beginAnimations:@"resize for input" context:nil];
    [UIView setAnimationDuration:0.3f];
    _dishiView.center = CGPointMake(ptCenter.x, ptCenter.y-50);
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField==self.pregistrationTF)
    {
        [self.pRegist_Sec_TF becomeFirstResponder];
    }
    if (textField==self.pRegist_Sec_TF) {
        [self.pSureTF becomeFirstResponder];
    }
    if (textField == self.pSureTF) {
         [self.pYzmTF becomeFirstResponder];
    }
    if (textField==self.pYzmTF) {
        [textField resignFirstResponder];
        [self restoreView];
    }
   
    return YES;
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
-(void)GetMemberChild
{
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/memberModifi/selectMemberChild.jhtml?mobile=%@",UrlPre,g_userInfo.UserName];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestMemberChildError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestMemberChildCompleted:)];
    [request startAsynchronous];
    
}
- (void)requestMemberChildError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];
};
- (void)requestMemberChildCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    
    if ([status intValue]==100)
    {
        id data=[dic objectForKey:@"data"];
        g_userInfo.mengberchildId=[data objectForKey:@"id"];
        
        MessageViewController *mainview=[[MessageViewController alloc]init];
        [self.navigationController pushViewController:mainview animated:YES];
        [mainview release];

    }
    
};


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
