//
//  SonAccount.h
//  Voicediagno
//
//  Created by 李传铎 on 15/9/16.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SonAccount : NSObject
@property (nonatomic ,retain) NSString *name;
@property (nonatomic ,retain) NSString *idCard;
@property (nonatomic ,retain) NSString *gender;
@property (nonatomic ,retain) NSString *birthday;
@property (nonatomic ,retain) NSString *mobile;
@property (nonatomic ,retain) NSString *medicare;
@property (nonatomic ,retain) NSString *token;
@property (nonatomic ,retain) NSString *JSESS;
@property (nonatomic ,retain) NSString *sonId;
@property (nonatomic ,retain) NSMutableArray *array;
@end
