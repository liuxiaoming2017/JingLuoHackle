//
//  AppDelegate.m
//  JingLuoHackle
//
//  Created by 刘晓明 on 2018/6/19.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewControllerViewController.h"
#import "HomeViewController.h"
#import "RootRequestController.h"
#import "CustomNavigationController.h"
#import <UMSocialCore/UMSocialCore.h>

@interface AppDelegate ()

@end

SSUserInfo* g_userInfo;
NSInteger pindex=0;
NSString* LeYaotype=@"";
NSInteger qiehuanlogin=0;
BOOL isJY=NO;
BOOL isSF=NO;
BOOL isBF=NO;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //[NSThread sleepForTimeInterval:3];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    g_userInfo = [[SSUserInfo alloc]init];
    NSUserDefaults *user=[NSUserDefaults standardUserDefaults];
    //国际化版本
    if ([CURRENTLANGUAGE hasPrefix:@"en"]){
        [ShareOnce shareOnce].languageStr = @"_en";
    }else if ([CURRENTLANGUAGE hasPrefix:@"zh-Hant"]){
        
    }else{
        [ShareOnce shareOnce].languageStr = @"";
    }
    if(![user valueForKey:@"first"])
    {
        StartViewController *startController=[[StartViewController alloc]init];
        startController.delegate=self;
        self.window.rootViewController=startController;
        
        [user setBool:YES forKey:@"first"];
        
    }
    else
    {
        [self returnMainPage2];
    }
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 初始化友盟分享
- (void)configUSharePlatforms
{
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"5605026be0f55a84f400284a"];
    [[UMSocialManager defaultManager] openLog:YES];
    
    //[[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_Sina appKey:[AppConfig sharedAppConfig].kMobWeiboAppKey appSecret:[AppConfig sharedAppConfig].kMobWeiboAppSecret redirectURL:[AppConfig sharedAppConfig].kMobWeiboURL];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" redirectURL:nil];
    
}

-(void)returnMainPage{
    
    LoginViewControllerViewController *login=[[LoginViewControllerViewController alloc] init];
    login.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //HomeViewController *homeVc = [[HomeViewController alloc] init];
    CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:login];
    self.window.rootViewController =nav;
}

-(void)returnMainPage2{
    RootRequestController *homeVc = [[RootRequestController alloc] init];
    //CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:homeVc];
    self.window.rootViewController = homeVc;
    
}

- (void)loadFasterStart
{
    HomeViewController *homeVc = [[HomeViewController alloc] init];
    CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:homeVc];
    self.window.rootViewController =nav;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    //开启后台处理多媒体事件
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
    _bgTaskId=[AppDelegate backgroundPlayerID:_bgTaskId];
    
}

+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId
{
    //设置并激活音频会话类别
    AVAudioSession *session=[AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid)
    {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}




- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
