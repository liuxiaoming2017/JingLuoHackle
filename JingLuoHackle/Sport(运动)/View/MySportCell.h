//
//  MySportCell.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/21.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySportCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *bottomView;

- (void)titleHeightWithStr:(NSString *)titleStr;

@end
