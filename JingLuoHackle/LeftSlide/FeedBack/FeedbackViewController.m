//
//  MoreProductinfoViewController.m
//  Voicediagno
//
//  Created by wangfeng on 14-9-10.
//  Copyright (c) 2014年 wangfeng. All rights reserved.
//

#import "FeedbackViewController.h"
#import "LBReadingTimeScrollPanel.h"
#import "Global.h"

#import "LoginViewControllerViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
@interface FeedbackViewController ()<UITextViewDelegate>
@property(nonatomic,retain) UITextView* acceptTV;
@property (nonatomic ,retain) UILabel *textLabel;

@end

@implementation FeedbackViewController
@synthesize acceptTV=_acceptTV;
- (void)dealloc{
    [super dealloc];
    [_acceptTV release];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     self.view.backgroundColor=[UtilityFunc colorWithHexString:@"#ffffff"];
    
    self.navTitleLabel.text = LocalString(@"feedback");
    
    UIImage* userImg=[UIImage imageNamed:@"Feedback_UserImg.png"];
    UIImageView* UserImgView=[[UIImageView alloc] init];
    UserImgView.frame=CGRectMake(16.5, 64+10.5, userImg.size.width/2, userImg.size.height/2);
    UserImgView.image=userImg;
    [self.view addSubview:UserImgView];
    [UserImgView release];
    
    UILabel* UserNameLb=[[UILabel alloc ] init];
    UserNameLb.frame=CGRectMake(UserImgView.frame.origin.x+UserImgView.frame.size.width+8.5, 64+10.5, 240, userImg.size.height/2);
    UserNameLb.text=LocalString(@"youradvices");
    UserNameLb.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    UserNameLb.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:UserNameLb];
    [UserNameLb release];

    
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(CancelButtonAction)];
    
    //  NSLog(@"dddd=%f",lb3.frame.origin.y);
    [self.view addGestureRecognizer:tap];
    [ tap release];
    UILabel* Linelb1=[[UILabel alloc] init];
    Linelb1.frame=CGRectMake(0, 64+35, SCREEN_WIDTH, 1);
    Linelb1.backgroundColor=[UtilityFunc colorWithHexString:@"#e7e7e5"];
    [self.view addSubview:Linelb1];
    [Linelb1 release];
    _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 64+41, SCREEN_WIDTH-20, 20)];
    _textLabel.text = LocalString(@"yourcomments");
    _textLabel.font = [UIFont systemFontOfSize:13];
    _textLabel.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    [self.view addSubview:_textLabel];
    _acceptTV=[[UITextView alloc] init];
    _acceptTV.delegate=self;
    //_acceptTV.placeholder=@"";
    _acceptTV.textColor = [UtilityFunc colorWithHexString:@"#666666"];
    _acceptTV.font = [UIFont systemFontOfSize:13];
    _acceptTV.backgroundColor=[UIColor clearColor];
    _acceptTV.keyboardAppearance = UIKeyboardTypePhonePad;
//    _acceptTV.textColor=[UtilityFunc colorWithHexString:@"#676767"];
    UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    grayView.backgroundColor=[UtilityFunc colorWithHexString:@"#f1f3f6"];
    _acceptTV.inputAccessoryView=grayView;
    _acceptTV.tag = 125;
    //_textLabel.hidden = [_acceptTV hasText];
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame=CGRectMake(self.view.frame.size.width - 80, 0, 50, 40);
    //设置按钮的标题UIControlStateNormal是按钮正常显示的状态
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    //改变字体颜色
    [doneButton setTitleColor:[UIColor blackColor] forState : UIControlStateNormal];
    //给按钮响应方法
    [doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanges:) name:UITextViewTextDidChangeNotification object:self.acceptTV];
    [grayView addSubview:doneButton];
    [grayView release];
//    [_acceptTV.layer setMasksToBounds:YES];
    _acceptTV.frame=CGRectMake(10, 64+36, SCREEN_WIDTH-20, (SCREEN_HEIGHT-64-36)/2);
    [self.view addSubview:_acceptTV];
    
    UILabel* Linelb2=[[UILabel alloc] init];
    Linelb2.frame=CGRectMake(0, _acceptTV.frame.origin.y+_acceptTV.frame.size.height+1, SCREEN_WIDTH, 1);
    Linelb2.backgroundColor=[UtilityFunc colorWithHexString:@"#e7e7e5"];
    [self.view addSubview:Linelb2];
    [Linelb2 release];
    
    UIButton *findpsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *findImg=[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Feedback_btn" ofType:@"png"]];
    [findpsButton setBackgroundImage:[UIImage createImageWithColor:UIColorFromHex(0X4FAEFE)] forState:UIControlStateNormal];
    //[findpsButton setImage:findImg forState:UIControlStateNormal];
    findpsButton.frame=CGRectMake((SCREEN_WIDTH-150)/2,Linelb2.frame.origin.y+Linelb2.frame.size.height+(((SCREEN_HEIGHT-64-36)/2)-40)/2, 150,40);
    [findpsButton setTitle:LocalString(@"提交") forState:UIControlStateNormal];
    findpsButton.layer.cornerRadius = 3.0;
    findpsButton.titleLabel.font = [UIFont systemFontOfSize:16];
    findpsButton.clipsToBounds = YES;
    [findpsButton addTarget:self action:@selector(userFeedbackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:findpsButton];
       // Do any additional setup after loading the view.
}
- (void)textDidChanges:(NSNotificationCenter*)notifi{
    _textLabel.hidden = [_acceptTV hasText];
}

- (void)doneButtonAction:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    //点击此按钮，就撤出按钮，键盘收回
    //    第一步，找到键盘响应者
    UITextView *_textField=(UITextView *)[self.view viewWithTag:125];
    //找到之后，释放第一响应者
    [_textField resignFirstResponder];
    
    //移除一个响应事件
    //    [sender removeTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if(![text isEqualToString:@""])
//    {
//        [_textLabel setHidden:YES];
//    }
//    if([text isEqualToString:@""]&&range.length==1&&range.location==0){
//        [_textLabel setHidden:NO];
//    }
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        
//        return NO;
//    }
//    return YES;
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)userFeedbackButton
{
    if (_acceptTV.text.length==0) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:LocalString(@"提示") message:LocalString(@"请填写反馈意见") delegate:nil cancelButtonTitle:LocalString(@"确定") otherButtonTitles:nil,nil];
        av.tag = 1000;
        [av show];
        [av release];
        return;

    }
    NSString *UrlPre=URL_PRE;
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member_suggest/commit.jhtml?memberId=%@&content=%@",UrlPre,g_userInfo.uid,_acceptTV.text];
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url1];
   // [request addRequestHeader:@"token" value:g_userInfo.token];
   // [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    [request setDelegate:self];
    [request setRequestMethod:@"GET"];
    [request setDidFailSelector:@selector(requestFeedbackError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestFeedbackCompleted:)];
    [request startAsynchronous];
    [request release];
}
- (void)requestFeedbackError:(ASIHTTPRequest *)request
{
    //[self hudWasHidden:nil];
    //[SSWaitViewEx removeWaitViewFrom:self.view];
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抱歉，请检查您的网络是否畅通" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    [av show];
    [av release];
}
- (void)requestFeedbackCompleted:(ASIHTTPRequest *)request
{
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"意见反馈成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag = 1000;
        [av show];
        [av release];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
        av.tag =  100008;
        [av show];
        [av release];
    }
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // alert.tag=10002;
    if (alertView.tag==100008)
    {
        LoginViewControllerViewController *loginVC = [[LoginViewControllerViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    if (alertView.tag==1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)CancelButtonAction
{
    
}
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    
//    [textView resignFirstResponder];
//    [self restoreView ];
//    
//}
//-(void)textViewDidBeginEditing:(UITextView *)textView {
//    
//    [self performSelector:@selector(resizeViewForInput:) withObject:textView];
//    
//}
-(void)resizeViewForInput:(id)sender
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-60,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
-(void)restoreView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    CGRect rect=CGRectMake(0.0f,0,width,height);
    self.view.frame=rect;
    //  NSLog(@"%f %f %f %f",self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark - UITextView Delegate Methods
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}
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
