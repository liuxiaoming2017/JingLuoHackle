//
//  DownloadLeyaoCell.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/8.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "DownloadLeyaoCell.h"

@implementation DownloadLeyaoCell

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



- (void)layoutSubviews
{
    [super layoutSubviews];
    if(!self.leftImage.hidden){
        self.titleLabel.frame = CGRectMake(self.leftImage.right+20, 15, 160, 30);
    }
    self.selectImgV.frame = CGRectMake(self.width-45, 15, 30, 30);
    if (self.selected) {
        self.selectImgV.image = [UIImage imageNamed:@"leyaoSelect"];
    }else{
        self.selectImgV.image = [UIImage imageNamed:@"leyaoNormal"];
        }
}

- (void)setupUI
{
    self.leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40*0.89)];
    self.leftImage.hidden = YES;
    self.leftImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.leftImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 160, 30)];
    
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel.font=[UIFont systemFontOfSize:16.0];
    self.titleLabel.textColor=UIColorFromHex(0xB0B0B0);
    self.titleLabel.backgroundColor=[UIColor clearColor];
    
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadBtn.frame = CGRectMake(self.width-45, 15, 30, 30);
    [self.downloadBtn setImage:[UIImage imageNamed:@"leyaoNormal"] forState:UIControlStateNormal];
    [self.downloadBtn setImage:[UIImage imageNamed:@"leyaoSelect"] forState:UIControlStateSelected];
    [self.downloadBtn addTarget:self action:@selector(downloadAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectImgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.width-45, 9, 27, 27)];
    [self addSubview:self.selectImgV];
    [self.selectImgV setImage:[UIImage imageNamed:@"leyaoNormal"]];
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60-1, ScreenWidth, 1)];
    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    
    [self addSubview:self.titleLabel];
    //[self addSubview:self.downloadBtn];
    [self addSubview:lineImageV];
}

//- (void)layoutSubviews
//{
//    NSLog(@"width:%f",self.width);
//    self.downloadBtn.frame = CGRectMake(self.width-45, 15, 30, 30);
//}

- (void)downloadAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
