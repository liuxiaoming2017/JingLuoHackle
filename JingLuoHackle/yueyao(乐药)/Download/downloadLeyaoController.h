//
//  downloadLeyaoController.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/7.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface downloadLeyaoController : CommonViewController
@property (nonatomic,strong) NSArray *dataArr;
@property (nonatomic,assign) CGFloat price;
@property (nonatomic,assign) CGFloat allPrice;

@property (nonatomic,copy) NSString *leyaoType;
- (id) initWithDataArr:(NSArray *)arr;
@end
