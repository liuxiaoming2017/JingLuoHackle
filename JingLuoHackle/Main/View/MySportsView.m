//
//  MySportsView.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MySportsView.h"
#import "MySportController.h"

@implementation MySportsView

- (id)initWithFrame:(CGRect)frame withLeyaoType:(NSString *)leyaoType
{
    self = [super initWithFrame:frame];
    if(self){
        if(leyaoType!=nil){
            self.leyaoIndex = [GlobalCommon getSportTypeFrom:leyaoType];
        }else{
            self.leyaoIndex = [GlobalCommon getSportTypeFrom:@"上宫"];
        }
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.backgroundColor = UIColorFromHex(0xFFFFFF);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 200, 25)];
    titleLabel.textColor = UIColorFromHex(0x7D7D7D);
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = LocalString(@"Myexercise");
    [self addSubview:titleLabel];
    
    CGFloat imgWidth = (ScreenWidth-23*2-22)/2.0;
    for(NSInteger i = 0;i<2;i++){
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(23+(imgWidth+22)*i, CGRectGetMaxY(titleLabel.frame)+10, imgWidth, imgWidth*0.5)];
        if(i==0){
            imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"运动式_0%@",[ShareOnce shareOnce].languageStr]];
        }else{
            
            imgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"运动式_%@%@",self.leyaoIndex,[ShareOnce shareOnce].languageStr]];
        }
        imgV.contentMode = UIViewContentModeScaleAspectFit;
        imgV.tag = 200+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgVtapGesture:)];
        [imgV addGestureRecognizer:tap];
        imgV.userInteractionEnabled = YES;
        [self addSubview:imgV];
    }
}

- (void)refreshSportImage:(NSString *)leyaoType
{
    self.leyaoIndex = [GlobalCommon getSportTypeFrom:leyaoType];
    if (@available(iOS 9.0, *)) {
        UIImageView *imageV = [self.viewForLastBaselineLayout viewWithTag:201];
        imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"运动式_%@",self.leyaoIndex]];
    } else {
        // Fallback on earlier versions
    }
}

- (void)imgVtapGesture:(UITapGestureRecognizer *)tap
{
    UIImageView *imageV = (UIImageView *)tap.view;
    if(imageV.tag == 200){
        MySportController *sportVC = [[MySportController alloc] initWithAllSport];
        [self.viewController.navigationController pushViewController:sportVC animated:YES];
    }else if (imageV.tag == 201){
       
        MySportController *sportVC = [[MySportController alloc] initWithSportType:[self.leyaoIndex integerValue]];
        [self.viewController.navigationController pushViewController:sportVC animated:YES];
    }
    
}

@end
