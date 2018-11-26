//
//  WKWebviewController.m
//  和畅行
//
//  Created by 刘晓明 on 2018/7/20.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "WKWebviewController.h"
#import "shareCustomView.h"
#import "MBProgressHUD.h"

@interface WKWebviewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong) UIProgressView *progressView;
@end

@implementation WKWebviewController

- (void)dealloc
{
    self.wkwebview = nil;
    [self.wkwebview removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    [self customeViewWithStr:self.dataStr];
    
}

- (void)customeViewWithStr:(NSString *)urlStr
{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    
    //config.processPool = [ShareProcessPoll shareOnce];
    
    
    // 通过JS与webview内容交互
    config.userContentController = [[WKUserContentController alloc] init];
    
    self.wkwebview = [[WKWebView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, ScreenWidth, ScreenHeight-kNavBarHeight)
                                              configuration:config];
    // 导航代理
    self.wkwebview.navigationDelegate = self;
    // 与webview UI交互代理
    self.wkwebview.UIDelegate = self;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_PRE,urlStr]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UserShareOnce shareOnce].token,@"token",[UserShareOnce shareOnce].JSESSIONID,@"JSESSIONID", nil];
//    [request addValue:[self readCurrentCookieWith:dic] forHTTPHeaderField:@"Cookie"];
    [self.wkwebview loadRequest:request];
    [self.view addSubview:self.wkwebview];
    
    if(self.progressType == progress2){
        // 添加KVO监听
        [self.wkwebview addObserver:self
                         forKeyPath:@"estimatedProgress"
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        self.progressView.frame = CGRectMake(0, 0, self.wkwebview.frame.size.width, 2);
        self.progressView.trackTintColor = [UIColor clearColor]; // 设置进度条的色彩
        self.progressView.progressTintColor = UIColorFromHex(0x1e82d2);
        // 设置初始的进度
        [self.progressView setProgress:0.05 animated:YES];
        [self.wkwebview addSubview:self.progressView];
       
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    // [GlobalCommon showMBHudWithView:self.view];
}

- (NSString*)readCurrentCookieWith:(NSDictionary*)dic{
    if (dic == nil) {
        return nil;
    }else{
        NSHTTPCookieStorage*cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSMutableString *cookieString = [[NSMutableString alloc] init];
        for (NSHTTPCookie*cookie in [cookieJar cookies]) {
            [cookieString appendFormat:@"%@=%@;",cookie.name,cookie.value];
        }
        //删除最后一个“；”
        [cookieString deleteCharactersInRange:NSMakeRange(cookieString.length - 1, 1)];
        return cookieString;
        
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if(self.progressType == progress2){
        
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    NSLog(@"加载成功");
}


- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    if(self.progressType == progress2){
        
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    [GlobalCommon showMessage:@"请求失败!" duration:2];
    //[self addFailView];
}

- (void)goBack:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([object isEqual:self.wkwebview] && [keyPath isEqualToString:@"estimatedProgress"]) { // 进度条
        
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        //NSLog(@"打印测试进度值：%f", newprogress);
        if (newprogress == 1) { // 加载完成
            // 首先加载到头
            [self.progressView setProgress:newprogress animated:YES];
            // 之后0.3秒延迟隐藏
            __weak typeof(self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                weakSelf.progressView.hidden = YES;
                [weakSelf.progressView setProgress:0 animated:NO];
            });
            
        } else { // 加载中
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
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
