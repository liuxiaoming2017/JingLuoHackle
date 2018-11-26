//
//  HelpViewController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/31.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (nonatomic,strong) UIImage *backImage;
@end

@implementation HelpViewController

-(id)initWithBackgroundImage:(UIImage *)image
{
    self = [super init];
    if(self){
        self.backImage = image;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.frame];
    imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"helpImage%@",[ShareOnce shareOnce].languageStr]];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.alpha = 0.9;
    
    
//    UIImageView *backImageV = [[UIImageView alloc] initWithFrame:self.view.frame];
//    backImageV.image = self.backImage;
//    //backImageV.alpha = 0.1;
//    [self.view addSubview:backImageV];
    
    [self.view addSubview:imageV];
    
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, backImageV.frame.size.width, backImageV.frame.size.height);
//    [backImageV addSubview:effectView];
//    effectView.alpha = 0.8;
    
    [self setupBackView];
}

-(void)setupBackView
{
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    preBtn.frame = CGRectMake(10, kStatusBarHeight+5, 80, 30);
    [preBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    [preBtn setTitle:LocalString(@"return") forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //[preBtn sizeToFit];
    preBtn.titleEdgeInsets = UIEdgeInsetsMake(1, -5, 0, 0);
    preBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [preBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preBtn];
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
