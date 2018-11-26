//
//  MyaiJiuView.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/25.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MyaiJiuView.h"

@implementation MyaiJiuView

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
    self.backgroundColor = UIColorFromHex(0xFFFFFF);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, 15, 200, 25)];
    titleLabel.textColor = UIColorFromHex(0x7D7D7D);
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"我的艾灸";
    [self addSubview:titleLabel];
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+10, 100, 80)];
    self.imageV.image = [UIImage imageNamed:@"sports01"];
    [self addSubview:self.imageV];
    
    self.subLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageV.frame)+15, self.imageV.frame.origin.y+10, 200, 25)];
    self.subLabel.textColor = UIColorFromHex(0x7D7D7D);
    self.subLabel.font = [UIFont systemFontOfSize:15];
    self.subLabel.text = @"moxibusstion";
    [self addSubview:self.subLabel];
    
    self.connectLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.subLabel.frame.origin.x, CGRectGetMaxY(self.subLabel.frame)+10, 200, 25)];
    self.connectLabel.textColor = UIColorFromHex(0x7D7D7D);
    self.connectLabel.font = [UIFont systemFontOfSize:15];
    self.connectLabel.text = @"not connected";
    [self addSubview:self.connectLabel];
    
}

@end
