//
//  LoginViewControllerViewController.m
//  Voicediagno
//
//  Created by 王锋 on 14-6-12.
//  Copyright (c) 2014年 王锋. All rights reserved.
//

#import "LoginViewControllerViewController.h"
#import "Global.h"
#import "MessageViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "RegistrationViewController.h"
#import "FindPasswordViewController.h"
#import <sys/utsname.h>
#import "SonAccount.h"
#import "HomeViewController.h"
#import "CustomNavigationController.h"


@interface LoginViewControllerViewController ()
@property (nonatomic ,strong) SonAccount *son;
@end

@implementation LoginViewControllerViewController

@synthesize passWordBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNaviBarLeftBtn:nil];
    [self initViewControl];
   
}


- (void)initViewControl
{
    
    
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"##f2f1ef"];
    [self setNaviBarTitle:LocalString(@"登录")];
    
    //适配iPhone6 ~ 代码重构 hai
    
    UIView* userView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    
    [self.view addSubview:userView];
    
    
    //用户名
    UIImage* nameBg=[UIImage imageNamed:@"UserBoxImg"];
    UITextField *nameF = [[UITextField alloc] init];
    nameF.background = nameBg;
    nameF.frame = CGRectMake(45,100,ScreenWidth-90,45);
    nameF.placeholder = LocalString(@"输入用户名");
    nameF.clearButtonMode = UITextFieldViewModeAlways;
    
    UIView *leftV = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 5, 0)];
    nameF.leftView = leftV;
    nameF.leftViewMode = UITextFieldViewModeAlways;
    
    
    userNameBox = nameF;
    [userView addSubview:nameF];
    
    
    
    //密码
    UITextField *pswF = [[UITextField alloc] init];
    pswF.background = nameBg;
    pswF.frame = CGRectMake(CGRectGetMinX(nameF.frame),CGRectGetMaxY(nameF.frame)+20,nameF.frame.size.width,nameF.frame.size.height);
    pswF.placeholder = LocalString(@"请输入密码");
    UIView *pswV = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 5, 0)];
    pswF.leftView = pswV;
    pswF.leftViewMode = UITextFieldViewModeAlways;
    pswF.clearButtonMode = UITextFieldViewModeAlways;
    pswF.secureTextEntry = YES;
    
    
    passWordBox = pswF;
    [userView addSubview:pswF];
    
    
    //记住我
    UIButton *remBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [remBtn setImage:[UIImage imageNamed:@"checkboxno"] forState:UIControlStateNormal];
    [remBtn setTitle:LocalString(@"记住我") forState:UIControlStateNormal];
    UIFont *font = [UIFont systemFontOfSize:14.0];
    UIColor *color = [UtilityFunc colorWithHexString:@"#9b9b9b"];
    
    [remBtn setTitleColor:color forState:UIControlStateNormal];
    remBtn.titleLabel.font = font;
    
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSFontAttributeName] = font;
    attrDict[NSForegroundColorAttributeName] = color;
    
    CGRect remBtnRect = [remBtn.titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrDict context:nil];
    
    remBtn.frame = CGRectMake(CGRectGetMinX(nameF.frame), CGRectGetMaxY(pswF.frame) + 20,remBtnRect.size.width + remBtn.currentImage.size.width,remBtnRect.size.height);
    //    [remBtn sizeToFit];
    
    [remBtn addTarget:self action:@selector(CheckActive:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:remBtn];
    
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   // [loginBtn setImage:[UIImage imageNamed:@"LoginBtn"] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage createImageWithColor:UIColorFromHex(0X4FAEFE)] forState:UIControlStateNormal];
    
    [loginBtn setTitle:LocalString(@"登录") forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 3.0;
    loginBtn.clipsToBounds = YES;
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    loginBtn.frame = CGRectMake(CGRectGetMinX(nameF.frame), CGRectGetMaxY(remBtn.frame) + 20, nameF.width, 45);
    
    [loginBtn addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:loginBtn];
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitle:LocalString(@"忘记密码") forState:UIControlStateNormal];
    [forgetBtn setTitleColor:color forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = font;
    
    CGRect rect = [forgetBtn.titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil];
    
    forgetBtn.frame = CGRectMake(CGRectGetMinX(nameF.frame), CGRectGetMaxY(loginBtn.frame)+20, rect.size.width, rect.size.height);
    
    [forgetBtn addTarget:self action:@selector(FoggetActive:) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:forgetBtn];
    
    //注册新用户
    UIButton *regiestbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [regiestbtn setTitle:LocalString(@"注册新用户") forState:UIControlStateNormal];
    [regiestbtn setTitleColor:color forState:UIControlStateNormal];
    regiestbtn.titleLabel.font = font;
    
    CGRect rect2 = [regiestbtn.titleLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attrDict context:nil];
    regiestbtn.frame = CGRectMake(CGRectGetMaxX(loginBtn.frame)-rect2.size.width, forgetBtn.frame.origin.y, rect2.size.width, rect2.size.height);
    [regiestbtn addTarget:self action:@selector(userRegistrationButton) forControlEvents:UIControlEventTouchUpInside];
    [userView addSubview:regiestbtn];
    
    
    NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
    NSString* strcheck=[dicTmp objectForKey:@"ischeck"];
    
    if ([strcheck isEqualToString:@"1"])
    {
        UIImage* CheckBoxImg=[UIImage imageNamed:@"checkboxyes"];
        [remBtn setImage:CheckBoxImg forState:UIControlStateNormal];
        isCheck=YES;
        userNameBox.text=[dicTmp objectForKey:@"USERNAME"];
        passWordBox.text=[dicTmp objectForKey:@"PASSWORDAES"];
        if(userNameBox.text.length>0&&passWordBox.text.length>0)
        {
          //  [self userLogin ];
        }
    }
    else
    {
        isCheck=NO;
    }
    
}



-(void) CheckActive:(id)sender
{
    UIButton* btn=(UIButton *)sender;
    
    if (!isCheck) {
        UIImage* CheckBoxImg=[UIImage imageNamed:@"checkboxyes.png"];
        [btn setImage:CheckBoxImg forState:UIControlStateNormal];
        isCheck=YES;
        NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
        if (dicTmp) {
            // [dicTmp setObject:@"1" forKey:@"ischeck"];
            [dicTmp setValue:@"1" forKey:@"ischeck"];
        }
        [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
    }
    else
    {
        UIImage* CheckBoxImg=[UIImage imageNamed:@"checkboxno.png"];
        [btn setImage:CheckBoxImg forState:UIControlStateNormal];
        isCheck=NO;
        NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
        if (dicTmp) {
            // [dicTmp setObject:@"1" forKey:@"ischeck"];
            [dicTmp setValue:@"0" forKey:@"ischeck"];
        }
        [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
    }
    
}


#pragma mark - 登录
-(void) userLogin
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
    if (userNameBox.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"请输入用户名或密码") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        
        return;
    }
    if (passWordBox.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"请输入用户名或密码") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
        
        return;
    }
    
    //[SSWaitView addWaitViewTo:[UIApplication sharedApplication].keyWindow];
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.labelText = LocalString(@"加载中...");
    [progress_ show:YES];
    
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/login/commit.jhtml",UrlPre];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request setPostValue:@"beta1.4" forKey:@"softver"];
    [request setPostValue:[[UIDevice currentDevice] systemVersion] forKey:@"osver"];
    [request setPostValue:widthheight forKey:@"resolution"];
    [request setPostValue:passWordBox.text forKey:@"password"];
    [request setPostValue:devicesname forKey:@"brand"];
    [request setPostValue:timeSp forKey:@"time"];
    [request setPostValue:devicesname forKey:@"devmodel"];
    [request setPostValue:userNameBox.text forKey:@"username"];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestLoginError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestLoginCompleted:)];
    [request startAsynchronous];
}

- (void)requestLoginCompleted:(ASIHTTPRequest *)request
{
    
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    id status=[dic objectForKey:@"status"];
    
    if ([status intValue]==100)
    {
        if (isCheck)
        {
            NSMutableDictionary* dicTmp = [UtilityFunc mutableDictionaryFromAppConfig];
            if (dicTmp) {
                [dicTmp setObject:userNameBox.text forKey:@"USERNAME"];
                [dicTmp setObject:passWordBox.text forKey:@"PASSWORDAES"];
            }
            [UtilityFunc updateAppConfigWithMutableDictionary:dicTmp];
        }
        NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
        [userDic setObject:userNameBox.text forKey:@"USERNAME"];
        [userDic setObject:passWordBox.text forKey:@"PASSWORDAES"];
        [UtilityFunc recordAppUserInfoWithDictionary:userDic];
        
        _son = [[SonAccount alloc]init];
        g_userInfo.PassWork=passWordBox.text;
        id data=[dic objectForKey:@"data"];
        _son.token = [data objectForKey:@"token"];
        _son.JSESS = [data objectForKey:@"JSESSIONID"];
        
        g_userInfo.token=[data objectForKey:@"token"];
        g_userInfo.JSESSIONID=[data objectForKey:@"JSESSIONID"];
        id member=[data objectForKey:@"member"];
        g_userInfo.uid=[member objectForKey:@"id"];
        id menberchild=[member objectForKey:@"mengberchild"];
        _son.sonId = [menberchild[0] objectForKey:@"id"];
        g_userInfo.sonId = [menberchild[0] objectForKey:@"id"];
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
        g_userInfo.Name = [member objectForKey:@"name"];
        [self GetMemberChild];
    }
    else
    {
        [self hudWasHidden:nil];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:[dic objectForKey:@"data"] delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        [av show];
       
        return;
    }
}

- (void)requestLoginError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"抱歉登录失败，请重试") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
    [av show];
    
    return;
};
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [progress_ removeFromSuperview];
    
    progress_ = nil;
}
-(void)GetMemberChild
{
    NSString *UrlPre=URL_PRE;
    NSString *aUrl = [NSString stringWithFormat:@"%@/member/memberModifi/selectMemberChild.jhtml?mobile=%@",UrlPre,g_userInfo.UserName];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:aUrl]];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    [request setTimeOutSeconds:20];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(requestMemberChildError:)];
    [request setDidFinishSelector:@selector(requestMemberChildCompleted:)];
    [request startAsynchronous];
}
- (void)requestMemberChildError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"抱歉登录失败，请重试") delegate:self cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
    [av show];
   
    return;
};

- (void)requestMemberChildCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        id data=[dic objectForKey:@"data"];
        g_userInfo.mengberchildId=[data objectForKey:@"id"];
        
        NSString *welcomeStr = LocalString(@"登录成功,欢迎");
        
        NSString *greetStr = [NSString stringWithFormat:@"%@%@",welcomeStr,userNameBox.text];

        
            HomeViewController *mainview = [[HomeViewController alloc] init];
             CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:mainview];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;

        
        
            [GlobalCommon showMessage:greetStr duration:2.0];
    }
};
//注册功能
-(void)userRegistrationButton
{
    RegistrationViewController *Registview=[[RegistrationViewController alloc]init];
    [self.navigationController pushViewController:Registview animated:YES];
    
}

//忘记密码
-(void)FoggetActive:(id)sender
{
    FindPasswordViewController* findpasswordview=[[FindPasswordViewController alloc] init];
    [self.navigationController pushViewController:findpasswordview animated:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==userNameBox)
    {
        [passWordBox becomeFirstResponder];
    }
    if (textField==passWordBox) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
