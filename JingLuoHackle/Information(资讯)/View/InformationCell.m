//
//  InformationCell.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "InformationCell.h"
#import "ArticleModel.h"
#import "UIImageView+WebCache.h"

@implementation InformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.frame = CGRectMake(0, 0, ScreenWidth, 100);
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    NSLog(@"frame:%@",NSStringFromCGRect(self.frame));
    
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, self.height-20)];
    self.imageV.layer.cornerRadius = 3;
    self.imageV.image = [UIImage imageNamed:@"sports01"];
    [self addSubview:self.imageV];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageV.right + 10, self.imageV.top+5, self.width - self.imageV.right - 20, 20)];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom + 10, self.titleLabel.width, 20)];
    self.descriptionLabel.font = [UIFont systemFontOfSize:15];
    self.descriptionLabel.textAlignment = NSTextAlignmentLeft;
    self.descriptionLabel.textColor = UIColorFromHex(0x7D7D7D);
    [self addSubview:self.descriptionLabel];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 130, self.descriptionLabel.bottom + 10, 120, 20)];
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = UIColorFromHex(0x7D7D7D);
    [self addSubview:self.timeLabel];
    
    UIImageView *lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
    lineImageV.alpha = 0.5;
    lineImageV.backgroundColor = UIColorFromHex(0xDADADA);
    [self addSubview:lineImageV];
    
}

- (void)setDataWithModel:(ArticleModel *)model
{
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.picture]];
    self.titleLabel.text = model.title;
    self.descriptionLabel.text = model.seoDescription;
    
    NSDate *data = [[NSDate alloc]initWithTimeIntervalSince1970:model.createDate/1000.00];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]];//location设置为中国
    NSString *confromTimespStr = [formatter stringFromDate:data];
    //confromTimespStr = [[confromTimespStr componentsSeparatedByString:@" "] objectAtIndex:0];
    self.timeLabel.text = confromTimespStr;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
