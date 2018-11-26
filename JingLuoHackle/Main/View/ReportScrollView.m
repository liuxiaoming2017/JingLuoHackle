//
//  ReportScrollV.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/7.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "ReportScrollView.h"
#import "downloadLeyaoController.h"
#import "MySportController.h"

@interface ReportScrollView()
@property (nonatomic,copy) NSString *leyaoType;
@end

@implementation ReportScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
//    self.backgroundColor = UIColorFromHex(0X4FAEFE);
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromHex(0x35BAFD).CGColor,(id)UIColorFromHex(0x4FAEFE).CGColor,(id)UIColorFromHex(0x35BAFD).CGColor,(id)UIColorFromHex(0x4FAEFE).CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.locations = @[@0.25,@0.5,@0.75,@1.0];
    [self.layer addSublayer:gradientLayer];
    
    self.showsVerticalScrollIndicator = YES;
    
    self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5+15, self.width-20*2, 20)];
    self.typeLabel.textColor = [UIColor whiteColor];
    self.typeLabel.numberOfLines = 0;
    self.typeLabel.textAlignment = NSTextAlignmentLeft;
    self.typeLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.typeLabel];
    
    self.symptomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.left, self.typeLabel.bottom+5, self.typeLabel.width, 20)];
    self.symptomLabel.textColor = [UIColor whiteColor];
    self.symptomLabel.numberOfLines = 0;
    self.symptomLabel.textAlignment = NSTextAlignmentLeft;
    self.symptomLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.symptomLabel];
    
    self.helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.left, self.symptomLabel.bottom+5, self.typeLabel.width, 30)];
    self.helpLabel.textColor = [UIColor whiteColor];
    self.helpLabel.numberOfLines = 0;
    self.helpLabel.textAlignment = NSTextAlignmentLeft;
    self.helpLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.helpLabel];
    
    UIButton *listenMusicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    listenMusicBtn.frame = CGRectMake(25, self.helpLabel.bottom+10, self.width-25*2, 40);
    
    [listenMusicBtn setTitle:LocalString(@"现在就去试试音乐") forState:UIControlStateNormal];
    listenMusicBtn.tag = 101;
    [listenMusicBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [listenMusicBtn setBackgroundImage:[GlobalCommon createImageWithColor:UIColorFromHex(0xDADADA)] forState:UIControlStateNormal];
    [listenMusicBtn setBackgroundImage:[GlobalCommon createImageWithColor:[UIColor orangeColor]] forState:UIControlStateHighlighted];
    listenMusicBtn.layer.cornerRadius = 5.0;
    listenMusicBtn.clipsToBounds = YES;
    [listenMusicBtn addTarget:self action:@selector(listenMusicAct:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:listenMusicBtn];
    
    self.suggestLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.left, listenMusicBtn.bottom+10, self.typeLabel.width, 20)];
    self.suggestLabel.textColor = [UIColor whiteColor];
    self.suggestLabel.numberOfLines = 0;
    self.suggestLabel.textAlignment = NSTextAlignmentLeft;
    self.suggestLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.suggestLabel];
    
    
    UIButton *sportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sportBtn.frame = CGRectMake(listenMusicBtn.left, self.suggestLabel.bottom+5, listenMusicBtn.width, listenMusicBtn.height);
    [sportBtn setTitle:LocalString(@"现在就去经络运动") forState:UIControlStateNormal];
    [sportBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sportBtn.tag = 102;
    //[sportBtn setBackgroundColor:[UIColor orangeColor]];
    [sportBtn setBackgroundImage:[GlobalCommon createImageWithColor:UIColorFromHex(0xDADADA)] forState:UIControlStateNormal];
    sportBtn.layer.cornerRadius = 5.0;
    sportBtn.clipsToBounds = YES;
    [sportBtn addTarget:self action:@selector(sportAct:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sportBtn];
    [sportBtn addTarget:self action:@selector(didBtnColorChange:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(self.width-30/2.0, self.height-40, 30, 30);
    [cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleBtn];
    
}

- (void)reloadDataWithDic:(NSDictionary *)dic
{
        NSString *type = [dic objectForKey:[NSString stringWithFormat:@"type%@",[ShareOnce shareOnce].languageStr]];
        NSString *symptom = [dic objectForKey:@"symptom"];
        NSString *music = [dic objectForKey:@"music"];
        NSString *sport = [dic objectForKey:@"sport"];
    
    self.leyaoType = type;
        NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName,nil];
        CGSize musicSize = [music boundingRectWithSize:CGSizeMake(self.typeLabel.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
        CGSize sportSize = [sport boundingRectWithSize:CGSizeMake(self.typeLabel.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    NSString *str111 = LocalString(@"您的经络功能状态类型");
        self.typeLabel.text = [NSString stringWithFormat:@"%@:%@",str111,type];
    self.typeLabel.numberOfLines = 0;
        self.symptomLabel.text =symptom;
    CGFloat height = [symptom heightStringwithfontSize:16 andWidth:self.symptomLabel.width];
    self.symptomLabel.top = self.typeLabel.bottom+5;
    self.symptomLabel.height = height;
    
        self.helpLabel.text = [NSString stringWithFormat:@"%@",music];;
        
        self.suggestLabel.text = [NSString stringWithFormat:@"%@",sport];
    
        self.helpLabel.height = musicSize.height;
        self.suggestLabel.height = sportSize.height;
    
     self.helpLabel.top = self.symptomLabel.bottom;
    
    
        UIButton *btn1 = [self viewWithTag:101];
        UIButton *btn2 = [self viewWithTag:102];
        btn1.top = self.helpLabel.bottom + 10;
    
        self.suggestLabel.top = btn1.bottom + 10;
        
        btn2.top = self.suggestLabel.bottom + 10;
    
    self.contentSize = CGSizeMake(1, btn2.bottom+10);
    
}

- (void)listenMusicAct:(UIButton *)btn
{
    
    if([self.listenMusicdelegate respondsToSelector:@selector(listenMusicAction:)]){
        [self.listenMusicdelegate listenMusicAction:btn];
    }
//    downloadLeyaoController *downloadVC = [[downloadLeyaoController alloc] init];
//    downloadVC.leyaoType = self.leyaoType;
//    [self.viewController.navigationController pushViewController:downloadVC animated:YES];
    
}


- (void)sportAct:(UIButton *)btn
{
    MySportController *sportVC = [[MySportController alloc] initWithAllSport];
    [self.viewController.navigationController pushViewController:sportVC animated:YES];
}

- (void)cancleAction:(UIButton *)btn
{
    [self removeFromSuperview];
}

- (void)didBtnColorChange:(UIButton *)button
{
    
}



@end
