//
//  MySportCell.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/21.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "MySportCell.h"

@interface MySportCell()
{
    BOOL _isTap;
}
@end

@implementation MySportCell
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
    self.imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.imageV.layer.cornerRadius = 3;
    self.imageV.image = [UIImage imageNamed:@"New_gf_tp_3_2"];
    [self addSubview:self.imageV];
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.bottomView];

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.bottomView addSubview:self.titleLabel];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [self addGestureRecognizer:tapGesture];
}

- (void)tapGestureAction
{
    _isTap = !_isTap;
    if(_isTap){
        self.bottomView.hidden = YES;
    }else{
        self.bottomView.hidden = NO;
    }
}

- (void)titleHeightWithStr:(NSString *)titleStr
{
    //NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName,nil];
    CGFloat height = [titleStr heightStringwithfontSize:16 andWidth:self.width-10];
    //CGSize titleSize = [titleStr boundingRectWithSize:CGSizeMake(self.width-10, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    self.titleLabel.text = titleStr;
    _isTap = NO;
    self.bottomView.hidden = NO;
    if(height>30){
        self.bottomView.frame = CGRectMake(0, self.height - height - 10, self.width, height + 10);
    }else{
        self.bottomView.frame = CGRectMake(0, self.height - 40, self.width, 40);
    }
    self.titleLabel.frame = CGRectMake(5, 5, ScreenWidth - 10, height);
}

@end
