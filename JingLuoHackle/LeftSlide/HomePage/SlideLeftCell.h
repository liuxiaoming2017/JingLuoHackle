//
//  SlideLeftCell.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/19.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideLeftCell : UITableViewCell

@property(nonatomic,strong) UIImageView *imageV;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIImageView *lineImageV;

-(void)initCellWithTitleStr:(NSString *)titleStr imageUrl:(NSString *)imageStr;

@end
