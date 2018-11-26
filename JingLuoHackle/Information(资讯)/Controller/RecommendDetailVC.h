//
//  RecommendDetailVC.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/7.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface RecommendDetailVC : UIViewController
@property (nonatomic ,copy) NSString *dataStr;
@property (nonatomic ,copy) NSString *titleStr;

@property (nonatomic,strong) WKWebView *wkwebview;
@property (nonatomic, strong) UIProgressView *progressView;

@end
