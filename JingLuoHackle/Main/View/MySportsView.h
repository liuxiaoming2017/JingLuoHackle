//
//  MySportsView.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/24.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySportsView : UIView
@property (nonatomic,copy) NSString *leyaoIndex;

- (id)initWithFrame:(CGRect)frame withLeyaoType:(NSString *)leyaoType;

- (void)refreshSportImage:(NSString *)leyaoType;
@end
