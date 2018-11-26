//
//  SportScrollView.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/21.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "SportScrollView.h"

@interface SportScrollView()

@end

@implementation SportScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
}

@end
