//
//  SlideLeftCell.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/19.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SlideLeftCell.h"
#import "UIImageView+WebCache.h"


@implementation SlideLeftCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    //self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textAlignment=NSTextAlignmentLeft;
    self.titleLabel.font=[UIFont systemFontOfSize:18.0];
    self.titleLabel.textColor=[UIColor blackColor];
    self.titleLabel.backgroundColor=[UIColor clearColor];
    
    self.lineImageV = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lineImageV.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageV];
    [self addSubview:self.lineImageV];
}

- (void)layoutSubviews
{
    
    if(self.frame.size.height == 60.0){
        self.imageV.frame = CGRectMake(25, 12, self.frame.size.height-24, self.frame.size.height-24);
        self.imageV.contentMode = UIViewContentModeScaleAspectFit;
    }else{
        self.imageV.frame = CGRectMake(25, 20, self.frame.size.height-40, self.frame.size.height-40);
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
        self.imageV.layer.masksToBounds = YES;
        self.imageV.layer.cornerRadius = self.imageV.width/2.0;
    }
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageV.frame)+16, (self.frame.size.height-20)/2.0, 120, 20);
    self.lineImageV.frame = CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1);
}

-(void)initCellWithTitleStr:(NSString *)titleStr imageUrl:(NSString *)imageStr
{
    self.titleLabel.text = titleStr;
    if([imageStr isEqualToString:@"我的"]||[imageStr isEqualToString:@"发现"]||[imageStr isEqualToString:@"反馈"]||[imageStr isEqualToString:@"帮助"]||[imageStr isEqualToString:@"关于我们"]){
        self.imageV.image = [UIImage imageNamed:imageStr];
    }else{
        
        [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"我的"]];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
