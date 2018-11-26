//
//  ReportScrollV.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/7.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportScrollView;
@protocol reportScrollViewSelegate<NSObject>
- (void)listenMusicAction:(UIButton *)btn;
@optional

@end


@interface ReportScrollView : UIScrollView

@property (nonatomic,strong) UILabel *typeLabel;

@property (nonatomic,strong) UILabel *symptomLabel;

@property (nonatomic,strong) UILabel *helpLabel;

@property (nonatomic,strong) UILabel *suggestLabel;

@property (nonatomic, assign) id<reportScrollViewSelegate> listenMusicdelegate;

- (void)reloadDataWithDic:(NSDictionary *)dic;

@end
