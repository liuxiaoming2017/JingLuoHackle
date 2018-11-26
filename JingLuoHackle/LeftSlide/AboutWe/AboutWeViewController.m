//
//  AboutWeViewController.m
//  Voicediagno
//
//  Created by 王锋 on 14-6-19.
//  Copyright (c) 2014年 王锋. All rights reserved.
//

#import "AboutWeViewController.h"
#import "LBReadingTimeScrollPanel.h"
#import <QuartzCore/QuartzCore.h>
#import "Global.h"
@interface AboutWeViewController ()<UITextViewDelegate>
@property (strong, nonatomic) LBReadingTimeScrollPanel *scrollPanel;

@end

@implementation AboutWeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navTitleLabel.text = LocalString(@"关于我们");
    self.view.backgroundColor=[UtilityFunc colorWithHexString:@"#f2f1ef"];

    LBReadingTimeScrollPanel *scrollPanel1 = [[LBReadingTimeScrollPanel alloc] initWithFrame:CGRectZero];
    self.scrollPanel=scrollPanel1;
    
    
    UITextView* AboutWeTV=[[UITextView alloc] init];
    AboutWeTV.frame=CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-69);
    AboutWeTV.text=LocalString(@"AboutWe");
    AboutWeTV.enableReadingTime = YES;
    AboutWeTV.userInteractionEnabled=YES;
    AboutWeTV.scrollEnabled=YES;
    AboutWeTV.multipleTouchEnabled=YES;
    AboutWeTV.delegate=self.scrollPanel;
    AboutWeTV.canCancelContentTouches=YES;
    AboutWeTV.bounces=YES;
    AboutWeTV.bouncesZoom=YES;
    AboutWeTV.delaysContentTouches=YES;
    AboutWeTV.showsHorizontalScrollIndicator=YES;
    AboutWeTV.showsVerticalScrollIndicator=YES;
    AboutWeTV.keyboardType=UIKeyboardTypeDefault;
    [AboutWeTV setEditable:NO];
    AboutWeTV.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:26];
    AboutWeTV.opaque=YES;
    AboutWeTV.clipsToBounds=YES;
    AboutWeTV.clearsContextBeforeDrawing=YES;
    AboutWeTV.font=[UIFont systemFontOfSize:13];
    AboutWeTV.backgroundColor=[UIColor clearColor];
    AboutWeTV.textColor=[UtilityFunc colorWithHexString:@"#333333"];
    AboutWeTV.textContainerInset = UIEdgeInsetsMake(10, 15, 10, 15);
    AboutWeTV.bounces = NO;
    [self.view addSubview:AboutWeTV];
    

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
