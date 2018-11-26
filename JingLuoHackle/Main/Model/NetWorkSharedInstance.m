//
//  NetWorkSharedInstance.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/10.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "NetWorkSharedInstance.h"
#import "SBJson.h"

static NetWorkSharedInstance *shared = nil;

@implementation NetWorkSharedInstance

+(NetWorkSharedInstance *)sharedInstance
{
    @synchronized(self){
        if(!shared){
            shared = [[NetWorkSharedInstance alloc] init];
            return shared;
        }
        return shared;
    }
}

-(void)networkWithRequestUrlStr:(NSString *)urlStr RequestMethod:(NSString *)method PostDictionay:(NSMutableDictionary *)postDictionary headDictionay:(NSDictionary *)headDic Success:(successBlock)success Fail:(failBlock)fail
{
    //**开始网络请求
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:method];
    [request setTimeOutSeconds:30.0f];
    request.delegate = self;
    
    if(_myFailBlock){
        Block_release(_myFailBlock);
        _myFailBlock = 0;
    }
    if(_mySuccessBlock){
        Block_release(_mySuccessBlock);
        _mySuccessBlock = 0;
    }
    _mySuccessBlock = Block_copy(success);
    _myFailBlock = Block_copy(fail);
    
    //**复制给request的成功和失败模块
    request.reqFailBlock = Block_copy(fail);
    request.reqSuccessBlock = Block_copy(success);
    
    for (NSString *key in postDictionary.allKeys) {
        if(!key||[key isEqualToString:@""]){
            //return nil;
            return;
        }
        [request addPostValue:[postDictionary objectForKey:key] forKey:key];
    }
    
    if(headDic != nil && headDic.count >0){
        for(NSString *key in headDic.allKeys){
            if(!key||[key isEqualToString:@""]){
                return;
            }
            [request addRequestHeader:key value:[headDic objectForKey:key]];
        }
    }
    
    [request startAsynchronous];
    //return request;
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString* respodStr = [request responseString];
    NSDictionary * dic = [respodStr JSONValue];
    if (dic == nil && ![respodStr isEqualToString:@""]) {
        
        respodStr = [respodStr substringFromIndex:1];
        respodStr = [respodStr substringToIndex:respodStr.length -1];
        
        dic = [respodStr JSONValue];
    }
    
    request.reqSuccessBlock(dic,YES);
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    
    request.reqFailBlock(request.error,NO);
    
}

@end
