//
//  RecommendCollectCell.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/25.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "RecommendCollectCell.h"

@implementation RecommendCollectCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width*0.75)];
    self.imageV.layer.cornerRadius = 3;
    self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    self.imageV.image = [UIImage imageNamed:@"sports01"];
    [self addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.imageV.frame)+7, self.frame.size.width-15*2, 40)];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = UIColorFromHex(0x7D7D7D);
    self.titleLabel.text = @"发卡拉卡";
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    
}

@end
