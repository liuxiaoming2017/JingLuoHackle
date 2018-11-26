//
//  LeyaoView.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/27.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LeyaoView;
@protocol LeyaoDelegate<NSObject>
- (void)listBtnAction:(UIButton *)btn;
- (void)playMusicAction:(NSString *)fileName;
@optional
    
@end

@interface LeyaoView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,assign) id<LeyaoDelegate> delegate;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,assign) BOOL historyOrCur;

- (id)initWithFrame:(CGRect)frame withCurrentArr:(NSArray *)arr;

@end
