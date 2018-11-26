//
//  BlueToothViewController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/22.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "BlueToothViewController.h"
#import "BlueToothDetailController.h"

@interface BlueToothViewController ()

@end

@implementation BlueToothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)createUI
{
    [self setupView];
    self.view.backgroundColor = UIColorFromHex(0x4FAEFE);
    
}

-(void)setupView
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
    
    [preBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preBtn];
    
    //还没用樂絡怡？点我了解
    
    UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, preBtn.bottom+20, 10, 10)];
    img1.backgroundColor = UIColorFromHex(0xFAC93E);
    img1.layer.cornerRadius = img1.width/2.0;
    [self.view addSubview:img1];
    
    UILabel *label1 = [[UILabel alloc] init];
    NSString *str1 = LocalString(@"还没有樂絡怡");
    CGFloat width = [str1 widthStringwithfontSize:17 andHeight:200];
    
    label1.frame = CGRectMake(img1.right+5, img1.top-5, width, 20);
    label1.font = [UIFont systemFontOfSize:17];
    label1.text = str1;
    label1.textColor = [UIColor whiteColor];
    [self.view addSubview:label1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *str2 = LocalString(@"点我了解");
     CGFloat width2 = [str2 widthStringwithfontSize:17 andHeight:200];
    btn.frame = CGRectMake(label1.right, label1.top, width2, 20);
    [btn setTitle:LocalString(@"点我了解") forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromHex(0xFAC93E) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.view addSubview:btn];
    
    UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, label1.bottom +30, 10, 10)];
    img2.backgroundColor = UIColorFromHex(0xFAC93E);
    img2.layer.cornerRadius = img1.width/2.0;
    [self.view addSubview:img2];
    
    NSString *titleStr = LocalString(@"没连接上");
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17], NSFontAttributeName,nil];
    CGSize titleSize = [titleStr boundingRectWithSize:CGSizeMake(ScreenWidth - img1.right-5-10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(img1.right+5, img2.top-5, ScreenWidth - img1.right-5-10, titleSize.height)];
    label2.numberOfLines = 0;
    label2.font = [UIFont systemFontOfSize:17];
    label2.text = titleStr;
    label2.textColor = [UIColor whiteColor];
    [self.view addSubview:label2];
    
    img2.top = label2.top + label2.height/2.0-5;
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(label1.left, label2.bottom+30, label2.width, label2.width*0.923)];
    imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"耳机_01%@",[ShareOnce shareOnce].languageStr]];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageV];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake((ScreenWidth-220)/2.0, imageV.bottom+30, 220, 40);
    [nextBtn setTitle:LocalString(@"下一步") forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:UIColorFromHex(0xFAC93E)];
    nextBtn.layer.cornerRadius = 5.0;
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)nextAction
{
    BlueToothDetailController *vc = [[BlueToothDetailController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
