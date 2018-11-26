//
//  MenuTypeView.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/21.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuTypeView;
@protocol MenuTypeDelegate<NSObject>

- (void)selectMenuTypeWithIndex:(NSInteger)index;

@end

@interface MenuTypeView : UIView
@property (nonatomic,strong) NSArray *menuArr;

@property (nonatomic,assign) id<MenuTypeDelegate>delegate;

@end
