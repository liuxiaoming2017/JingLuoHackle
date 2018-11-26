//
//  CommonViewController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/8.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
}


-(void)setupNav
{
    //self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:243/255.0 blue:246/255.0 alpha:1.0];
    self.navigationController.navigationBar.barTintColor = UIColorFromHex(0X4FAEFE);
    
    // 设置导航默认标题的颜色及字体大小
    self.navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 43)];
    self.navTitleLabel.text = @"提交订单";
    self.navTitleLabel.font = [UIFont systemFontOfSize:18];
    self.navTitleLabel.textColor = [UIColor whiteColor];
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = self.navTitleLabel;
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //preBtn.frame = CGRectMake(0, kStatusBarHeight+5, 80, 30);
    [preBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    [preBtn setTitle:LocalString(@"return") forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //preBtn.adjustsImageWhenHighlighted = NO;
    [preBtn sizeToFit];
    preBtn.titleEdgeInsets = UIEdgeInsetsMake(1, -5, 0, 0);
    preBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    preBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [preBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:preBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}



- (void)showAlertViewController:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:alertAct1];
    [alertVC addAction:alertAct12];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)showAlertWarmMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
    [alertVC addAction:alertAct1];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)goBack:(UIButton *)btn
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //self.navigationController.navigationBar.translucent = NO;
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
