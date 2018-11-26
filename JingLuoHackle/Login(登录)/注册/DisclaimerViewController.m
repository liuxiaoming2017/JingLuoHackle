//
//  DisclaimerViewController.m
//  Voicediagno
//
//  Created by 王锋 on 14-6-19.
//  Copyright (c) 2014年 王锋. All rights reserved.
//

#import "DisclaimerViewController.h"
#import "LBReadingTimeScrollPanel.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
@interface DisclaimerViewController ()<UITextViewDelegate>
@property (strong, nonatomic) LBReadingTimeScrollPanel *scrollPanel;

@end

@implementation DisclaimerViewController
- (void)dealloc{
   
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
   
   [self setNaviBarTitle:LocalString(@"注册说明")];
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"#f2f1ef"];
    
    LBReadingTimeScrollPanel *scrollPanel1 = [[LBReadingTimeScrollPanel alloc] initWithFrame:CGRectZero];
    self.scrollPanel=scrollPanel1;
    
    UITextView* DisclaimerTV=[[UITextView alloc] init];
    DisclaimerTV.frame=CGRectMake(15, 64, SCREEN_WIDTH-30, SCREEN_HEIGHT-124);
    DisclaimerTV.text= LocalString(@"RegistText");
    DisclaimerTV.enableReadingTime = YES;
    DisclaimerTV.userInteractionEnabled=YES;
    DisclaimerTV.scrollEnabled=YES;
    DisclaimerTV.multipleTouchEnabled=YES;
    DisclaimerTV.delegate=self.scrollPanel;
    DisclaimerTV.canCancelContentTouches=YES;
    DisclaimerTV.bounces=YES;
    DisclaimerTV.bouncesZoom=YES;
    DisclaimerTV.delaysContentTouches=YES;
    DisclaimerTV.showsHorizontalScrollIndicator=YES;
    DisclaimerTV.showsVerticalScrollIndicator=YES;
    DisclaimerTV.keyboardType=UIKeyboardTypeDefault;
    [DisclaimerTV setEditable:NO];
    DisclaimerTV.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:26];
    DisclaimerTV.opaque=YES;
    DisclaimerTV.clipsToBounds=YES;
    DisclaimerTV.clearsContextBeforeDrawing=YES;
    DisclaimerTV.font=[UIFont systemFontOfSize:13];
    DisclaimerTV.backgroundColor=[UIColor clearColor];
    DisclaimerTV.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    [self.view addSubview:DisclaimerTV];
    
    // Do any additional setup after loading the view.
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

@end
