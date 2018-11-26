//
//  StartViewController.h
//  Voicediagno
//
//  Created by 李传铎 on 15/10/13.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReturnMainPage<NSObject>
@optional
-(void)returnMainPage;
@end
@interface StartViewController : UIViewController
@property(nonatomic,assign)id<ReturnMainPage> delegate;
@end
