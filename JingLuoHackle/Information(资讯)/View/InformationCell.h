//
//  InformationCell.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/18.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArticleModel;
@interface InformationCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imageV;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *descriptionLabel;

@property (nonatomic,strong) UILabel *timeLabel;

- (void)setDataWithModel:(ArticleModel *)model;

@end
