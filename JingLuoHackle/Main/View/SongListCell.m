//
//  SongListCell.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SongListCell.h"

@implementation SongListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 220, 25)];
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel.font=[UIFont systemFontOfSize:16.0];
    self.titleLabel.textColor=UIColorFromHex(0xB0B0B0);
    self.titleLabel.backgroundColor=[UIColor clearColor];
    
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadBtn.frame = CGRectMake(self.width-140, 8, 29, 30);
//    self.downloadBtn.layer.cornerRadius = 6;
//    self.downloadBtn.layer.borderWidth = 1.0;
//    self.downloadBtn.layer.borderColor = UIColorFromHex(0xFAC93E).CGColor;
//    [self.downloadBtn setTitle:@"￥1.90" forState:UIControlStateNormal];
//    [self.downloadBtn setTitleColor:UIColorFromHex(0xFAC93E) forState:UIControlStateNormal];
    //self.downloadBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.downloadBtn setImage:[UIImage imageNamed:@"downLoadImage"] forState:UIControlStateNormal];
    [self.downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-15, 8, 50, self.height-16)];
    imageV.layer.cornerRadius = 6;
    imageV.layer.borderWidth = 1.0;
    
    imageV.layer.borderColor = UIColorFromHex(0xFAC93E).CGColor;
    //[self addSubview:imageV];
    
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45-1, ScreenWidth-46, 1)];
    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.downloadBtn];
    [self addSubview:lineImageV];
    
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if(selected){
        self.titleLabel.textColor = UIColorFromHex(0X4FAEFE);
    }else{
        self.titleLabel.textColor = UIColorFromHex(0xB0B0B0);
    }
    NSLog(@"selected:%d",selected);
}

- (void)setDownLoadButton:(BOOL)isHidden
{
    if(isHidden){
        self.downloadBtn.hidden = YES;
        //self.selectionStyle = UITableViewCellSelectionStyleGray;
    }else{
        self.downloadBtn.hidden = NO;
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
}



- (void)setTitleColor:(UIColor *)color
{
    self.titleLabel.textColor = color;
}

- (void)layoutSubviews
{
    self.downloadBtn.frame = CGRectMake(self.width-40, (self.height-30)/2.0, 30, 30);
}

- (void)downloadAction:(UIButton *)btn
{
    if([self.delegate respondsToSelector:@selector(downLoadButton:)]){
        [self.delegate downLoadButton:btn];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
