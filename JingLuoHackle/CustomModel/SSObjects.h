//
//  SSObjects.h
//  Voicediagno
//
//  Created by 王锋 on 14-6-18.
//  Copyright (c) 2014年 王锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface SSUserInfo : NSObject
@property (nonatomic, copy) NSString* uid;//用户ID
@property (nonatomic,copy) NSString * UserName;
@property (nonatomic,copy) NSString * PassWork;
@property (nonatomic,copy) NSString * token;
@property (nonatomic,copy) NSString * JSESSIONID;
@property (nonatomic,copy) NSString * Name;
@property (nonatomic,copy) NSString * gender;
@property (nonatomic,copy) NSString * birthday;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * identityType;
@property (nonatomic ,retain) NSString *sonId;
@property (nonatomic,copy) NSString * idNumber;
@property (nonatomic,copy) NSString * isMedicare;
@property (nonatomic,copy) NSString * memberImage;
@property( nonatomic,strong) AVAudioPlayer* mp3;
@property (nonatomic,copy) NSString * mengberchildId;
@property (nonatomic, copy) NSString* customerNo;//健康空间客户号
@property (nonatomic, copy) NSString* regcode;//软件注册码
@property (nonatomic, copy) NSString* serviceCount;//可用服务次数
@property (nonatomic, copy) NSString* totalHisResultCount;//已读辨识结果总数
@property (nonatomic, copy) NSString* totalResultCount;//未读辨识结果总数
@property (nonatomic, copy) NSString* DeviceToken;//未读辨识结果总数
@property (nonatomic,assign) BOOL isnew;

- (void)clearLoginInfo;
@end
