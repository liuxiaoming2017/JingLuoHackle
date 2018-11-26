//
//  DownloadHandler.m
//  DownloadHandler
//
//  Created by 阿 朱 on 12-4-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DownloadHandler.h"
static DownloadHandler *sharedDownloadhandler = nil;

@implementation DownloadHandler{
    ASIHTTPRequest *_request;
    ASINetworkQueue *_queue;
    NSString *_pathOfTmp;
    ProgressIndicator *_progress;
    UILabel *_label;
    unsigned long long _dataSize;
//    BOOL _downloading;
}
@synthesize downdelegate;
@synthesize url = _url;
@synthesize name = _name;
@synthesize fileType = _fileType;
@synthesize savePath = _savePath;
@synthesize progress = _progress;
@synthesize btnImg=_btnImg;
+(DownloadHandler *)sharedInstance{
    if (!sharedDownloadhandler) {
        sharedDownloadhandler = [[DownloadHandler alloc] init];
    }
    return sharedDownloadhandler;
}
-(void)setButton:(UIButton*)btn
{
    [btn retain];
    
    _btnImg=btn;
    
    [self.btnDic setObject:btn forKey:[NSString stringWithFormat:@"%@",_name]];
}
-(void)setProgress:(ProgressIndicator *)progress
{
    [progress retain];
    _progress=progress;
    [self.progressDic setObject:_progress forKey:[NSString stringWithFormat:@"%@",_name]];
}
-(id)init{
    if (self = [super init]) {
        if (!_queue) {
            _queue = [[ASINetworkQueue alloc] init];
            _queue.showAccurateProgress = YES;
            _queue.shouldCancelAllRequestsOnFailure = NO;
            [_queue go];
        }
        self.downloadingDic = [NSMutableDictionary dictionaryWithCapacity:10];
        self.progressDic=[NSMutableDictionary dictionaryWithCapacity:10];
        self.btnDic=[NSMutableDictionary dictionaryWithCapacity:10];
//        _downloading = NO;
    }
    return self;
}
-(void)start{
    for (ASIHTTPRequest *r in [_queue operations]) {
        NSString *fileName = [r.userInfo objectForKey:@"Name"];
        if ([fileName isEqualToString:_name]) {
            return;//队列中已存在特定request时，退出
        }
    }
//    if (_downloading) {
//        return;
//    }
    NSURL *url = [NSURL URLWithString:_url];
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setTimeOutSeconds:20];
    _request.delegate = self;
    _request.temporaryFileDownloadPath = [self cachesPath];
    _request.downloadDestinationPath = [self actualSavePath];
    _request.downloadProgressDelegate = _progress;
    _request.allowResumeForFileDownloads = YES;
    _request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:_name, @"Name", nil];
    [_queue addOperation:_request];
}
-(NSString *)actualSavePath{
    return [_savePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _name, _fileType]];
}
-(NSString *)cachesPath{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", _name, _fileType]];
    return path;
}
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    
    NSLog(@"total size: %lld", request.contentLength);
    
    for (ASIHTTPRequest *r in [_queue operations]) {
          NSString *fileName = [r.userInfo objectForKey:@"Name"];
         if ([self.progressDic objectForKey:fileName] !=nil) {
             _progress =[self.progressDic objectForKey:fileName];//=request.contentLength/1024.0/1024.0;
              _progress.totalSize = request.contentLength/1024.0/1024.0;
             //[[self.btnDic objectForKey:fileName] addSubview:_progress];
         }
    }
   
}
-(void)requestStarted:(ASIHTTPRequest *)request{
//    _downloading = YES;
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    
    NSString *fileName = [request.userInfo objectForKey:@"Name"];
    
    UIButton *btn = (UIButton *)[self.btnDic objectForKey:fileName];
    if (self.downdelegate && [self.downdelegate respondsToSelector:@selector(DownloadHandlerSelectAtIndex:)]) {
        [self.downdelegate DownloadHandlerSelectAtIndex:btn.tag - 100];
    }
    
        if ([self.btnDic objectForKey:fileName] !=nil) {
            //NSLog(@"wwwwwwwwwwwwwww");
            for (int i=0; i<[btn subviews].count; i++)
            {
                UIView *view = (UIView *)[[btn subviews] objectAtIndex:i];
                [view removeFromSuperview];
            }
            
            [btn removeFromSuperview];
            
            [self.downloadingDic removeObjectForKey:fileName];
            [self.progressDic removeObjectForKey:fileName];
            [self.btnDic removeObjectForKey:fileName];
            [request clearDelegatesAndCancel];
        }
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    

    NSString *fileName = [request.userInfo objectForKey:@"Name"];
    UIButton *btn = (UIButton *)[self.btnDic objectForKey:fileName];
    if (self.downdelegate && [self.downdelegate respondsToSelector:@selector(DoenloadHandlerFailWithIndex:)]) {
        [self.downdelegate DoenloadHandlerFailWithIndex:btn.tag - 100];
    }
    for(UIView *subView in btn.subviews){
        [subView removeFromSuperview];
    }
    UIImageView *downLoadImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 33)];
    downLoadImg.image = [UIImage imageNamed:@"downLoadImage"];
    [btn addSubview:downLoadImg];
    [self.downloadingDic removeObjectForKey:fileName];
    [self.progressDic removeObjectForKey:fileName];
    [self.btnDic removeObjectForKey:fileName];
    [self removeRequestFromQueue];
   
}
-(void)removeRequestFromQueue{
    for (ASIHTTPRequest *r in [_queue operations]) {
        NSString *fileName = [r.userInfo objectForKey:@"Name"];
        if ([fileName isEqualToString:_name]) {
            [r clearDelegatesAndCancel];
        }
    }
}
//-(void)unzipFile{
//    NSString *unzipPath = [_savePath stringByAppendingPathComponent:_name];
//    ZipArchive *unzip = [[ZipArchive alloc] init];
//    if ([unzip UnzipOpenFile:[self actualSavePath]]) {
//        BOOL result = [unzip UnzipFileTo:unzipPath overWrite:YES];
//        if (result) {
//            NSLog(@"unzip successfully");
//        }
//        [unzip UnzipCloseFile];
//    }
//    [unzip release];
//    unzip = nil;
//}
-(void)dealloc{
    [_queue release];
    _queue = nil;
    [_progress release];
    _progress = nil;
    [_label release];
    _label = nil;
    [super dealloc];
}
@end
