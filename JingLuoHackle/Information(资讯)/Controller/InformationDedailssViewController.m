//
//  InformationDedailssViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/22.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "InformationDedailssViewController.h"
#import "shareCustomView.h"
#import "MBProgressHUD.h"

@interface InformationDedailssViewController ()<UIWebViewDelegate>
{
   
}
@end

@implementation InformationDedailssViewController
- (void)dealloc{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupNav2];
    [self setupWebview];
   
}

- (void)setupNav2
{
    
    self.navTitleLabel.text = LocalString(@"资讯详情");
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setImage:[UIImage imageNamed:@"toolbar_sharing_new"] forState:UIControlStateNormal];
    [rightBtn sizeToFit];
    rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    [rightBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationController.navigationBar.barTintColor = UIColorFromHex(0X4FAEFE);
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    
}

- (void)setupWebview
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.view.frame.size.width, self.view.frame.size.height - kNavBarHeight)];
    webView.backgroundColor = [UIColor clearColor];
    NSString *url = URL_PRE;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,_dataStr]]];
    [webView setScalesPageToFit:YES];
    webView.delegate = self;
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)shareBtnAction{

    NSString *urlStr = [NSString stringWithFormat:@"%@%@",URL_PRE,_dataStr];
    [shareCustomView shareWithContent:@"" image:[UIImage imageNamed:@"icon 120x120.png"] title:_titleStr url:urlStr type:0 completion:^(NSString *resultJson) {
        
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
