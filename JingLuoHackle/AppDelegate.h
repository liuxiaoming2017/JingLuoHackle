//
//  AppDelegate.h
//  JingLuoHackle
//
//  Created by 刘晓明 on 2018/6/19.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,ReturnMainPage>
{
    UIBackgroundTaskIdentifier _bgTaskId;
}
@property (strong, nonatomic) UIWindow *window;
- (void)loadFasterStart;

@end

