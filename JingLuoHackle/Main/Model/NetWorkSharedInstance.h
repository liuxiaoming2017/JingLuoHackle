//
//  NetWorkSharedInstance.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

//typedef void (^successBlock)(id result,int flag);
//typedef void (^failBlock)(id error,int flag);

@interface NetWorkSharedInstance : NSObject<ASIHTTPRequestDelegate>
{
    successBlock _mySuccessBlock;
    failBlock _myFailBlock;
}

//单例调用
+(NetWorkSharedInstance *)sharedInstance;

//网络请求
-(void)networkWithRequestUrlStr:(NSString *)urlStr RequestMethod:(NSString *)method PostDictionay:(NSMutableDictionary *)postDictionary headDictionay:(NSDictionary *)headDic Success:(successBlock)success Fail:(failBlock)fail;

@end
