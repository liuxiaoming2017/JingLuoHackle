//
//  SSObjects.m
//  Voicediagno
//
//  Created by 王锋 on 14-6-18.
//  Copyright (c) 2014年 王锋. All rights reserved.
//

#import "SSObjects.h"

@implementation SSUserInfo
@synthesize uid;
@synthesize customerNo;
@synthesize regcode;
@synthesize serviceCount;
@synthesize totalHisResultCount;
@synthesize totalResultCount;
@synthesize DeviceToken;
@synthesize UserName;
@synthesize PassWork;
@synthesize token;
@synthesize JSESSIONID;
@synthesize mengberchildId;

@synthesize Name;
@synthesize address;
@synthesize birthday;
@synthesize gender;
@synthesize identityType;
@synthesize idNumber;
@synthesize phone;
@synthesize memberImage;

- (id)init
{
    self = [super init];
    if (self) {
        self.uid=@"";
        self.customerNo=@"";
        self.regcode=@"";
        self.serviceCount=@"";
        self.totalHisResultCount=@"";
        self.totalResultCount=@"";
        self.DeviceToken=@"";
        self.isnew=NO;
        self.UserName=@"";
        self.PassWork=@"";
        self.token=@"";
        self.JSESSIONID=@"";
        self.mengberchildId=@"";
        self.Name=@"";
       
    }
    return self;
}
- (void)clearLoginInfo
{
    self.uid=@"";
    self.customerNo=@"";
    self.regcode=@"";
    self.serviceCount=@"";
    self.totalHisResultCount=@"";
    self.totalResultCount=@"";
    self.isnew=NO;
    self.UserName=@"";
    self.PassWork=@"";
    self.token=@"";
    self.JSESSIONID=@"";
     self.mengberchildId=@"";
}

@end
