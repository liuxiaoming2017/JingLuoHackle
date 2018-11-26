//
//  DownloadHandler.h
//  DownloadHandler
//
//  Created by 阿 朱 on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "ProgressIndicator.h"
@protocol DownloadHandlerDelegate <NSObject>

@required
//代理函数 获取当前下标
- (void)DownloadHandlerSelectAtIndex:(NSInteger)index;
- (void)DoenloadHandlerFailWithIndex:(NSInteger)index;
@end

@interface DownloadHandler : NSObject<ASIHTTPRequestDelegate, ASIProgressDelegate>
@property (assign, nonatomic) id<DownloadHandlerDelegate> downdelegate;
@property(nonatomic,copy)NSString *url;
//下载资源的名称
@property(nonatomic,copy)NSString *name;
//下载资源的类型，即后缀
@property(nonatomic,copy)UIButton *btnImg;
@property(nonatomic,copy)NSString *fileType;
@property(nonatomic,copy)NSString *savePath;
@property (nonatomic,retain) NSMutableDictionary* downloadingDic;
@property (nonatomic,retain) NSMutableDictionary* progressDic;
@property (nonatomic,retain) NSMutableDictionary* btnDic;
@property(nonatomic,retain)ProgressIndicator *progress;
+(DownloadHandler *)sharedInstance;
-(void)start;
-(void)setButton:(UIButton*)btn;
@end
