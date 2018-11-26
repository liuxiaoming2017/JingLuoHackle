//
//  RecommendDetailVC.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/7.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "RecommendDetailVC.h"
#import "shareCustomView.h"

@interface RecommendDetailVC ()

@end

@implementation RecommendDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupWebview];
}

- (void)setupWebview
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, self.view.frame.size.width, self.view.frame.size.height - kNavBarHeight)];
    webView.backgroundColor = [UIColor clearColor];
    NSString *url = URL_PRE;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,_dataStr]]];
    [webView setScalesPageToFit:YES];
    [self.view addSubview: webView];
    [webView loadRequest:request];
}

- (void)setupNav
{
    // 设置导航默认标题的颜色及字体大小
    UILabel  *navTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 43)];
    navTitleLabel.text = LocalString(@"资讯详情");
    navTitleLabel.font = [UIFont systemFontOfSize:18];
    navTitleLabel.textColor = [UIColor whiteColor];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = navTitleLabel;
    
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    [preBtn sizeToFit];
    preBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    preBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [preBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:preBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
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

- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnAction
{
//    [shareCustomView shareWithContent:@"" image:@"" title:@"" url:@"" type:2 completion:^(NSString *resultJson){
//
//    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    // self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
