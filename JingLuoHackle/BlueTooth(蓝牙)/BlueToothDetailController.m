//
//  BlueToothDetailController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/23.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "BlueToothDetailController.h"
#import "BlueToothObject.h"

@interface BlueToothDetailController ()

@end

@implementation BlueToothDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = UIColorFromHex(0x4FAEFE);
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
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(preBtn.right, preBtn.bottom+30, ScreenWidth-preBtn.right*2, 50)];
    label1.textColor = [UIColor whiteColor];
    label1.numberOfLines = 0;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text =LocalString(@"蓝牙设置");
    [self.view addSubview:label1];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(label1.left, label1.bottom+20, label1.width, 400)];
    imageV.image = [UIImage imageNamed:@"耳机_02"];
    [self.view addSubview:imageV];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake((ScreenWidth-220)/2.0, imageV.bottom+30, 220, 40);
    [nextBtn setTitle:LocalString(@"连接设备") forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setBackgroundColor:UIColorFromHex(0xFAC93E)];
    nextBtn.layer.cornerRadius = 5.0;
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LeyaoBluetoothConnectSuccess) name:LeyaoBluetoothON object:nil];
}

- (void)LeyaoBluetoothConnectSuccess
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextAction
{
//    //NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//     NSURL*  url = [NSURL URLWithString: @"App-Prefs:root=General&path=Bluetooth"];
//    [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES} completionHandler:NULL];
    [[BlueToothObject shareOnce] BluetoothConnectionWithTag:YES];
    
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
