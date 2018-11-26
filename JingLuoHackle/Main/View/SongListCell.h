//
//  SongListCell.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongListCell;
@protocol songListCellDelegate<NSObject>
@optional

- (void)downLoadButton:(UIButton *)btn;

@end

@interface SongListCell : UITableViewCell

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIButton *downloadBtn;

@property (nonatomic,assign) id<songListCellDelegate>delegate;

- (void)setDownLoadButton:(BOOL)isHidden;

- (void)setTitleColor:(UIColor *)color;

@end
