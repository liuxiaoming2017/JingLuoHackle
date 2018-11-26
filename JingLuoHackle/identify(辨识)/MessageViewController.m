//
//  MessageViewController.m
//  Voicediagno
//
//  Created by 李传铎 on 15/9/4.
//  Copyright (c) 2015年 李传铎. All rights reserved.
//

#import "MessageViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "LPPopup.h"
#import "MLAudioRecorder.h"
#import "SBJson.h"
#import "LoginViewControllerViewController.h"
#import "CustomNavigationController.h"
#import "UIButton+BACountDown.h"


#define MENU_POPOVER_FRAME  CGRectMake(8, 0, 140, 88)
#define kTabsHeight 46.5
#define LeftWidth 36.5
#define SingWidth 2
#define SflowviewHeight 64
@class STSegmentedControl;
@interface MessageViewController ()<AVAudioRecorderDelegate,AVAudioPlayerDelegate,MBProgressHUDDelegate,ASIHTTPRequestDelegate,ASIProgressDelegate>
{
    UIButton *recordButton;
    int timeNStager;
    BOOL IsShiFan ;
    NSTimer* playTime;
    NSTimer* playmp3;
    NSTimer * bianshiTime;
    NSTimer * bianshiTime1;
    NSTimer * bianshiTime2;
    NSTimer *timerACC;
    AVAudioRecorder *RecorderAcc;
    STSegmentedControl *segmentImg;
    MBProgressHUD* progress_;
    UIView *yincangView;
    UIImageView *imageHong;
}
@property (nonatomic, strong) MLAudioRecorder *recorder;
@property (nonatomic,retain) UIButton* Recordbtn;
@property (nonatomic,retain) UIImageView* RotateImg;
@property (nonatomic, copy) NSString *filePath;
@property( nonatomic,retain) UIImageView* ZhiShiImgView;
@property( nonatomic,retain) UIImageView* ZhiShiImgView1;
@property( nonatomic,retain) UIImageView* ZhiShiImgView2;
@property( nonatomic,retain) UIImageView* ZhiShiImgView3;
@property( nonatomic,retain) UIImageView *image1;
@property( nonatomic,retain) UIImageView *image2;
@property( nonatomic,retain) UIImageView *image3;
@property( nonatomic,retain) UIImageView *image4;
@property( nonatomic,retain) UIImageView *image5;
@property( nonatomic,retain) UIImageView *image6;
@property( nonatomic,retain) UIImageView *image7;

@property(nonatomic,strong) UILabel *duoLabel;
@property(nonatomic,strong) UILabel *ruaiLabel;
@property(nonatomic,strong) UILabel *miLabel;
@property(nonatomic,strong) UILabel *souLabel;
@property(nonatomic,strong) UILabel *laLabel;

@property (nonatomic,assign) CGFloat soundCount;

@end
//@synthesize slideImages,slideImagesYB,slideImages1,slideImages2,slideImages3,slideImages4,slideImages5,slideImages6,slideImages7,slideImages8,segmendatatarray,segTableview,BaoGaoTableview,BaoGaodatatarray,RotateImg;
@implementation MessageViewController
- (void)dealloc{
    [super dealloc];
    [timerACC release];
    [RecorderAcc release];
    [playmp3 release];
    [playTime release];
    [imageHong release];
    [bianshiTime release];
    [bianshiTime1 release];
    [bianshiTime2 release];
    [_recorder release];
    [_Recordbtn release];
    [_filePath release];
    [_ZhiShiImgView release];
    [_ZhiShiImgView1 release];
    [_ZhiShiImgView2 release];
    [_ZhiShiImgView3 release];
    [yincangView release];
    [_image1 release];
    [_image2 release];
    [_image3 release];
    [_image4 release];
    [_image5 release];
    [_image6 release];
    [_image7 release];
}

-(void)setupBackView
{
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    preBtn.frame = CGRectMake(20, kStatusBarHeight+5, 80, 30);
    [preBtn setImage:[UIImage imageNamed:@"nav_bar_back"] forState:UIControlStateNormal];
    [preBtn setTitle:LocalString(@"return") forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [preBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //[preBtn sizeToFit];
    preBtn.titleEdgeInsets = UIEdgeInsetsMake(1, -5, 0, 0);
    preBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [preBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preBtn];
}

- (void)goBack:(UIButton *)btn
{
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupContentView
{
    // 重构代码 适配iPhone6 ~ 机型 hai
    UIView* UpView = [[UIView alloc] init];
    UpView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:UpView];
    [UpView release];
    
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 65-30, kStatusBarHeight+10, 260, 20)];
    titLabel.text = LocalString(@"经络功能状态评估");
    titLabel.textColor = [UIColor whiteColor];
    
    titLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.view addSubview:titLabel];
    
    // 背景图片
    UIImageView* UpImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wenyinBg"]];
    UpImgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [UpView addSubview:UpImgView];
    [UpImgView release];
    
    // 哆
    UIImageView *duoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"duo"]];
    CGFloat duoX = (SCREEN_WIDTH - duoView.frame.size.width*0.6) * 0.5;
    //duoView.frame = CGRectMake(duoX, SCREEN_HEIGHT * 0.2, duoView.bounds.size.width*0.6, duoView.bounds.size.height*0.6);
    if(IS_IPHONE_6){
        duoView.frame = CGRectMake(duoX, SCREEN_HEIGHT * 0.16, duoView.bounds.size.width*0.6, duoView.bounds.size.height*0.6);
    }else{
        duoView.frame = CGRectMake(duoX, SCREEN_HEIGHT * 0.2, duoView.bounds.size.width*0.6, duoView.bounds.size.height*0.6);
    }
    duoView.image = [UIImage imageNamed:@"duo默认"];
    _image1 = duoView;
    [UpView addSubview:duoView];
    [duoView release];
    
    // 文字背景框
    UIImageView *wenBgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(duoView.frame)+75, ScreenWidth-40, 80)];
    if(IS_IPHONE_6){
       wenBgView.frame = CGRectMake(20, ScreenHeight*0.5, ScreenWidth-40, 80);
    }
    [wenBgView setImage:[UIImage imageNamed:@"Wybs_WinZhi_Img_bg.png"]];
    wenBgView.tag = 10086;
    [UpView addSubview:wenBgView];
    [wenBgView release];
    
    
    NSArray *titleArr = @[@"哆",@"唻",@"咪",@"嗦",@"啦"];
    
    CGFloat marin = 10.0;
    CGFloat wenX = wenBgView.bounds.size.width / titleArr.count;
    for (int i = 0; i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(wenX * i + marin, 10, 60, 60)];
        titleLabel.text = [titleArr objectAtIndex:i];
        titleLabel.font = [UIFont systemFontOfSize:50.0];
        titleLabel.textColor = UIColorFromHex(0xFFFFFF);
        titleLabel.tag = 2018+i;
        titleLabel.alpha = 0.44;
        [wenBgView addSubview:titleLabel];
        
        switch (i) {
            case 0:
                self.duoLabel = titleLabel;
                break;
            case 1:
                self.ruaiLabel = titleLabel;
                break;
            case 2:
                self.miLabel = titleLabel;
                break;
            case 3:
                self.souLabel = titleLabel;
                break;
            case 4:
                self.laLabel = titleLabel;
                break;
            default:
                break;
        }
        [titleLabel release];
        //[wenView release];
    }
    
    
    // 开始
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"luyinbegin"] forState:UIControlStateNormal];
    [button setBackgroundColor:UIColorFromHex(0xfac121)];
    //button.currentImage.size.width
    CGFloat startBtnX = (SCREEN_WIDTH - 160) * 0.5;
    
    if(IS_IPHONE_6P){
        button.frame = CGRectMake(startBtnX, CGRectGetMaxY(wenBgView.frame)+75, 160,160);
    }else{
        CGFloat ff = ScreenHeight - CGRectGetMaxY(wenBgView.frame)-160;
        button.frame = CGRectMake(startBtnX, CGRectGetMaxY(wenBgView.frame)+ff/2.0, 160,160);
    }
    
    button.layer.cornerRadius = button.frame.size.width/2.0;
    button.tag=10004;
    [button addTarget:self action:@selector(record:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    timeNStager=0;
    bianshiTime=[NSTimer scheduledTimerWithTimeInterval:0.6f target:self selector:@selector(runTimeBianshi) userInfo:nil repeats:YES];
    [bianshiTime setFireDate:[NSDate distantFuture]];
    
    bianshiTime1=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimeBianshi1) userInfo:nil repeats:YES];
    [bianshiTime1 setFireDate:[NSDate distantFuture]];
    bianshiTime2=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimeBianshi2) userInfo:nil repeats:YES];
    [bianshiTime2 setFireDate:[NSDate distantFuture]];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showLoginView)
     name:@"showLoginView"
     object:nil];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(showQianHuanLogin:)
     
     name:@"QianHuanLogin"
     object:nil];
    yincangView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 51, self.view.frame.size.width, 51)];
    [self.view addSubview:yincangView];
    yincangView.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self setupContentView];
    [self setupBackView];
    
}

-(void)showQianHuanLogin:(NSNotification*)NotiSuc
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)showLoginView {
    
    LoginViewControllerViewController *loginview=[[LoginViewControllerViewController alloc]init];
    CustomNavigationController *nav=[[CustomNavigationController alloc]initWithRootViewController:loginview];
    qiehuanlogin=1;
    [self presentViewController:nav
                       animated:YES
                     completion:^(void){
                         //Code
                     }];
    [nav release];
    [loginview release];
}





-(void)LeftBtnActive:(id)sender
{
    UIButton* btn=(UIButton*)sender;
    [btn setImage:[UIImage imageNamed:@"演示中1.png"] forState:UIControlStateNormal];
    btn.enabled=NO;
    IsShiFan=YES;
    yincangView.hidden = NO;
    UIButton* btn1=(UIButton*)[self.view viewWithTag:10004];
    //[btn1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    btn1.enabled=NO;
    self.ZhiShiImgView.hidden=NO;
    [bianshiTime1 setFireDate:[NSDate distantPast]];
    
}

-(BOOL)checkPermission
{
    AVAudioSessionRecordPermission permission = [[AVAudioSession sharedInstance] recordPermission];
    return permission == AVAudioSessionRecordPermissionGranted;
    
}

- (void)startRecordAudion
{
    if([self checkPermission]){
        [self recordAudio];
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if(granted){
                [self recordAudio];
            }else{
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请打开麦克风权限" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
                [alertVC addAction:alertAct1];
                [self presentViewController:alertVC animated:YES completion:NULL];
            }
        }];
    }
}

#pragma mark - 录音
- (void)recordAudio
{
    
    NSError *error1 = nil;
    AVAudioSession * audioSession = [AVAudioSession sharedInstance]; //得到AVAudioSession单例对象
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error1];//设置类别,表示该应用同时支持播放和录音
    [audioSession setActive:YES error: &error1];//启动音频会话管理,此时会阻断后台音乐的播放.
    
    //录音设置
    NSMutableDictionary *recordSetting = [[[NSMutableDictionary alloc]init] autorelease];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //  [recordSetting setValue:[NSNumber numberWithFloat:9600] forKey:AVEncoderBitRateKey];
    //AVEncoderBitRateKey
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd-mm:hh:ss"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"locationString:%@",locationString);
    [dateformatter release];
    // NSString* path=[self getPathOfDocuments];
    NSString *path = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *imageDir = [path stringByAppendingPathComponent:@"wybs"];
    imageDir = [NSString stringWithFormat:@"%@/Caches/%@", path, g_userInfo.UserName];
    [self addSkipBackupAttributeToItemAtPath:imageDir];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    self.filePath=[imageDir stringByAppendingPathComponent:[NSString stringWithFormat:@"HY%@.aac",locationString]];
    NSLog(@"filepath===%@",self.filePath);
    // NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:self.filePath];
    //urlPlay = url;
    
    NSError *error;
    //初始化
    RecorderAcc = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    RecorderAcc.meteringEnabled = YES;
    RecorderAcc.delegate = self;
    
    //判断设备是否支持录音
    [self luyinWithrecording];
}
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    // assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
- (void)detectionVoices
{
    [RecorderAcc updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [RecorderAcc peakPowerForChannel:0]));
    NSLog(@"%lf",lowPassResults);
    
    self.soundCount += lowPassResults;
    //最大50  0
    //图片 小-》大
}
#pragma mark - 录音按钮
- (IBAction)record:(UIButton *)sender
{
    self.soundCount =0;
    recordButton = sender;
    if (recordButton.selected) {
        recordButton.selected = NO;
        timeNStager=0;
        UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
        btn.enabled=YES;
        // IsShiFan=false;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        _image1.image=[UIImage imageNamed:@"duo默认"];
        [self changeTitleLabelAlphaWithtag:100];
        [recordButton setImage:[UIImage imageNamed:@"luyinbegin"] forState:UIControlStateNormal];
        double cTime = RecorderAcc.currentTime;
        if (cTime > 2) {//如果录制时间<2 不发送
            NSLog(@"发出去");
        }else {
            //删除记录的文件
            [RecorderAcc deleteRecording];
            //删除存储的
        }
        [RecorderAcc stop];
        [timerACC invalidate];
        yincangView.hidden = YES;
    }else{
        //开启一个定时器 三秒后录音
        sender.userInteractionEnabled = NO;
        __block UIButton *btn = sender;
        __block typeof(self) blockSelf = self;
        [btn setImage:nil forState:UIControlStateNormal];
        
        [sender ba_countDownCustomWithTimeInterval:3 block:^(NSInteger currentTime) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setTitle:[NSString stringWithFormat:@"%ld",(long)currentTime] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:90];
               
            });
        }];
        
        [sender setTimeStoppedCallback:^{
            [btn setTitle:nil forState:UIControlStateNormal];
            [blockSelf startRecordAudion];
            recordButton.selected = YES;
            yincangView.hidden = NO;
        }];
        
       
        }
    
}



- (void)luyinWithrecording{
    if (timeNStager!=0) {
        //取消录音
        timeNStager=0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [bianshiTime setFireDate:[NSDate distantFuture]];
            _image1.image=[UIImage imageNamed:@"duo"];
            _image3.image=[UIImage imageNamed:@"WinZhi_Img_duo_1.png"];
            _image4.image=[UIImage imageNamed:@"WinZhi_Img_ruai_1.png"];
            _image5.image=[UIImage imageNamed:@"WinZhi_Img_mi_1.png"];
            _image6.image=[UIImage imageNamed:@"WinZhi_Img_sao_1.png"];
            _image7.image=[UIImage imageNamed:@"WinZhi_Img_la_1.png"];
            _image2.image=[UIImage imageNamed:@"Wybs_duo.png"];
            [recordButton setImage:[UIImage imageNamed:@"luyinbegin"] forState:UIControlStateNormal];
        });
        double cTime = RecorderAcc.currentTime;
        if (cTime > 2) {//如果录制时间<2 不发送
            NSLog(@"发出去");
        }else {
            //删除记录的文件
            [RecorderAcc deleteRecording];
            //删除存储的
        }
        [RecorderAcc stop];
        [timerACC invalidate];
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
            btn.enabled=NO;
            self.RotateImg.hidden=YES;
            [bianshiTime setFireDate:[NSDate distantPast]];
            [recordButton setImage:[UIImage imageNamed:@"luyinover"] forState:UIControlStateNormal];
        });
        //创建录音文件，准备录音
        if ([RecorderAcc prepareToRecord]) {
            //开始
            [RecorderAcc record];
        }
        
        //设置定时检测
        //        if (self.filePath.length == 0) {
        //            [self audio];
        //        }
        timerACC = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoices) userInfo:nil repeats:YES];
       
    }

}

-(void)runTimeBianshi1
{
    timeNStager++;
    if (timeNStager==5) {
        timeNStager=0;
        [bianshiTime1 setFireDate:[NSDate distantFuture]];
        [bianshiTime setFireDate:[NSDate distantPast]];
        [self ShiFanYinPlay];
    }
    
}
-(void)ShiFanYinPlay
{
    NSString *audioPath = [[NSBundle mainBundle] pathForResource:@"WY_bssf.mp3" ofType:@"wav"];
    NSURL *audioUrl = [NSURL fileURLWithPath:audioPath];
    if (g_userInfo.mp3)
    {
        if (g_userInfo.mp3.playing) {
            [g_userInfo.mp3 pause];
        }
        [g_userInfo.mp3 release];
        g_userInfo.mp3 =nil;
    }
    g_userInfo.mp3 = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    [g_userInfo.mp3 setDelegate:self];//设置代理
    g_userInfo.mp3.volume = 0.9;//播放音量
    [g_userInfo.mp3 prepareToPlay];
    playmp3= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(paly) userInfo:nil repeats:NO];
}
-(void) paly
{
    [g_userInfo.mp3 play];//播放音乐
    [playmp3 invalidate];
    
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"finish");//设置代理的AVAudioPlayer对象每次播放结束都会触发这个函数
}

-(void)runTimeBianshi2
{
    timeNStager++;
    if (timeNStager==5) {
        timeNStager=0;
        self.ZhiShiImgView2.hidden=YES;
        self.ZhiShiImgView3.hidden=YES;
        UIButton* btn1=(UIButton*)[self.view viewWithTag:10007];
        btn1.enabled=YES;
        [btn1 setImage:[UIImage imageNamed:@"演示前1.png"] forState:UIControlStateNormal];
        UIButton* btn=(UIButton*)[self.view viewWithTag:10004];
        btn.enabled=YES;
         yincangView.hidden = YES;
        [bianshiTime2 setFireDate:[NSDate distantFuture]];
    }
}

#pragma mark - 录音文字图片变换
-(void)runTimeBianshi
{
    if (timeNStager==0)
    {
        if (IsShiFan)
        {
            self.ZhiShiImgView.hidden=YES;
            self.ZhiShiImgView1.hidden=NO;
        }
        _image1.image=[UIImage imageNamed:@"duo"];
        //_image3.image=[UIImage imageNamed:@"WinZhi_Img_duo_2.png"];
        [self changeTitleLabelAlphaWithtag:2018];
        _image2.image=[UIImage imageNamed:@"Wybs_duo.png"];
        timeNStager++;
        return;
    }
    if (timeNStager==1)
    {
        _image1.image=[UIImage imageNamed:@"duo"];
        //_image3.image=[UIImage imageNamed:@"WinZhi_Img_duo_2.png"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_1_duo.png"] forSegmentAtIndex:0];
        timeNStager++;
        return;
    }
    
    if (timeNStager==2) {
        _image1.image=[UIImage imageNamed:@"ruai"];
//        _image3.image=[UIImage imageNamed:@"WinZhi_Img_duo_1.png"];
//        _image4.image=[UIImage imageNamed:@"WinZhi_Img_ruai_2.png"];
        [self changeTitleLabelAlphaWithtag:2018+1];
        _image2.image=[UIImage imageNamed:@"Wybs_ruai.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_2_ruai.png"] forSegmentAtIndex:1];
        timeNStager++;
        return;
    }
    if (timeNStager==3) {
        _image1.image=[UIImage imageNamed:@"ruai"];
        // _image4.image=[UIImage imageNamed:@"WinZhi_Img_ruai_2.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_1_ruai.png"] forSegmentAtIndex:1];
        timeNStager++;
        return;
    }
    if (timeNStager==4) {
        
        _image1.image=[UIImage imageNamed:@"ruai"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_2_ruai.png"] forSegmentAtIndex:1];
        timeNStager++;
        return;
    }
    if (timeNStager==5) {
        
        _image1.image=[UIImage imageNamed:@"mi"];
//        _image4.image=[UIImage imageNamed:@"WinZhi_Img_ruai_1.png"];
//        _image5.image=[UIImage imageNamed:@"WinZhi_Img_mi_2.png"];
        [self changeTitleLabelAlphaWithtag:2018+2];
        _image2.image=[UIImage imageNamed:@"Wybs_mi.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_2_mi.png"] forSegmentAtIndex:2];
        timeNStager++;
        return;
    }
    if (timeNStager==6) {
        
        _image1.image=[UIImage imageNamed:@"mi"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_1_mi.png"] forSegmentAtIndex:2];
        timeNStager++;
        return;
    }
    if (timeNStager==7) {
        
        _image1.image=[UIImage imageNamed:@"mi"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_2_mi.png"] forSegmentAtIndex:2];
        timeNStager++;
        return;
    }
    
    if (timeNStager==8) {
        
        _image1.image=[UIImage imageNamed:@"sou"];
//        _image5.image=[UIImage imageNamed:@"WinZhi_Img_mi_1.png"];
//        _image6.image=[UIImage imageNamed:@"WinZhi_Img_sao_2.png"];
        [self changeTitleLabelAlphaWithtag:2018+3];
        _image2.image=[UIImage imageNamed:@"Wybs_sao.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_2_sao.png"] forSegmentAtIndex:3];
        timeNStager++;
        return;
    }
    if (timeNStager==9) {
        
        _image1.image=[UIImage imageNamed:@"sou"];
        
        timeNStager++;
        return;
    }
    if (timeNStager==10) {
        
        _image1.image=[UIImage imageNamed:@"sou"];
        
        timeNStager++;
        return;
    }
    
    if (timeNStager==11) {
        _image1.image=[UIImage imageNamed:@"la"];
//        _image6.image=[UIImage imageNamed:@"WinZhi_Img_sao_1.png"];
//        _image7.image=[UIImage imageNamed:@"WinZhi_Img_la_2.png"];
        [self changeTitleLabelAlphaWithtag:2018+4];
        _image2.image=[UIImage imageNamed:@"Wybs_la.png"];
        //[segmentImg setImage:[UIImage imageNamed:@"bs_6_2_la.png"] forSegmentAtIndex:4];
        timeNStager++;
        return;
    }
    if (timeNStager==12) {
        
        _image1.image=[UIImage imageNamed:@"la"];
        
        timeNStager++;
        return;
    }
    if (timeNStager==13) {
        
        _image1.image=[UIImage imageNamed:@"la"];
        [segmentImg setImage:[UIImage imageNamed:@"bs_6_2_la.png"] forSegmentAtIndex:4];
        timeNStager++;
        return;
    }
    if (timeNStager==14) {
        
        _image1.image=[UIImage imageNamed:@"duo"];
        
        //_image7.image=[UIImage imageNamed:@"la"];
        [self changeTitleLabelAlphaWithtag:100];
        
        _image2.image=[UIImage imageNamed:@"Wybs_duo.png"];
        //_image7.image=[UIImage imageNamed:@"WinZhi_Img_la_2.png"];
        // [segmentImg setImage:[UIImage imageNamed:@"bs_6_3_la.png"] forSegmentAtIndex:4];
        timeNStager=0;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        //if (RecorderAcc.isRecording)
        {
            
            //self.RotateImg.hidden=NO;
            UIButton* btn=(UIButton*)[self.view viewWithTag:10004];
            
            [btn setImage:[UIImage imageNamed:@"luyinbegin"] forState:UIControlStateNormal];
            
            if (IsShiFan)
            {
                IsShiFan=NO;
                self.ZhiShiImgView1.hidden=YES;
                self.ZhiShiImgView2.hidden=NO;
                self.ZhiShiImgView3.hidden=NO;
                //UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
                
                NSFileManager *fileMgr = [NSFileManager defaultManager];
                
                BOOL bRet = [fileMgr fileExistsAtPath:self.filePath];
                if (bRet) {
                    NSError *err;
                    [fileMgr removeItemAtPath:self.filePath error:&err];
                }
                [bianshiTime2 setFireDate:[NSDate distantPast]];
                return;
            }
            else{
                double cTime = RecorderAcc.currentTime;
                if (cTime > 2) {//如果录制时间<2 不发送
                    NSLog(@"发出去");
                }else {
                    //删除记录的文件
                    [RecorderAcc deleteRecording];
                    //删除存储的
                }
                [RecorderAcc stop];
                [timerACC invalidate];
            }
            
            NSLog(@" soundCount : %f",self.soundCount);
            
            [ self testMp3Upload];
            
            
        }
    }
}

- (void)changeTitleLabelAlphaWithtag:(NSInteger)tag
{
    UIImageView *bgView = (UIImageView *)[self.view viewWithTag:10086];
    for(UILabel *titleLabel in bgView.subviews){
        if(titleLabel.tag == tag){
            titleLabel.alpha = 1.0;
        }else{
            titleLabel.alpha = 0.44;
        }
    }
}

-(void)testMp3Upload
{
    [self showHUD];
    NSString *UrlPre=URL_PRE;
   
    //NSString *aUrlle= [NSString stringWithFormat:@"%@/member/fileUpload/upload.jhtml?fileType=media&convert=convert&memberChildId=%@",UrlPre,g_userInfo.mengberchildId];
    NSString *aUrlle= [NSString stringWithFormat:@"%@/member/fileUpload/diagnosis.jhtml?fileType=media&convert=convert&memberChildId=%@",UrlPre,g_userInfo.mengberchildId];
    NSLog(@"aurlle===%@",aUrlle);
    aUrlle = [aUrlle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url1 = [NSURL URLWithString:aUrlle];
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:url1];
    [request addRequestHeader:@"token" value:g_userInfo.token];
    [request addRequestHeader:@"Cookie" value:[NSString stringWithFormat:@"token=%@;JSESSIONID＝%@",g_userInfo.token,g_userInfo.JSESSIONID]];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request addPostValue:g_userInfo.token forKey:@"token"];
    [request setFile:self.filePath forKey:@"file"];   //可以上传图片
    [request setDidFailSelector:@selector(requestUpLoadError:)];//requestLoginError
    [request setDidFinishSelector:@selector(requestUpLoadCompleted:)];
    [request startAsynchronous];
    [request release];
}

- (void)requestUpLoadCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        g_userInfo.isnew=YES;
        LPPopup *popup = [LPPopup popupWithText:@"您的录音已成功上传，正在进行分析。分析报告审核完成后，会发送至您的手机上，请注意查收。"];
        CGPoint point=self.view.center;
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        BOOL bRet = [fileMgr fileExistsAtPath:self.filePath];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:self.filePath error:&err];
        }
        UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
        btn.enabled=YES;
         yincangView.hidden = YES;
        self.filePath = nil;
        recordButton.selected = NO;
        /**
         *  延迟30秒使小圆点出现
            服务器算法变化,时间缩短至五秒
         *
         */
        [self performSelector:@selector(delayTime30S) withObject:nil afterDelay:5.0];
        
        //完成后发生通知
        [self.navigationController popViewControllerAnimated:YES];
        //保存乐药状态
        NSInteger code = [[[dic objectForKey:@"data"] objectForKey:@"code"] integerValue];
        [[NSUserDefaults standardUserDefaults] setInteger:code forKey:[NSString stringWithFormat:@"%@_%@",g_userInfo.UserName,leYaoStatus]];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bianshiUploadSuccess" object:self userInfo:nil];
        
        return;
    }
    else
    {
        
        UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
        btn.enabled=YES;
        //未采集到有效声音,请录制有效声音
        LPPopup *popup = [LPPopup popupWithText:@"抱歉，由于长时间无法连接到网络，系统将您的录音放在了“我的”的“未发出声的文件”里，您可以选择手工上传或删除。"];
        //[GlobalCommon showMessage:@"抱歉，由于长时间无法连接到网络，系统将您的录音放在了“我的”的“未发出声的文件”里，您可以选择手工上传或删除。" duration:2];
        timeNStager=0;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        [self.Recordbtn setImage:[UIImage imageNamed:@"bs_an_kaishishibian.png"] forState:UIControlStateNormal];
        [self.recorder stopRecording];
        CGPoint point=self.view.center;
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
        self.filePath = nil;
         yincangView.hidden = YES;
        recordButton.selected = NO;
        return;
        
    }
}

- (void)delayTime30S{
    imageHong.hidden = NO;

}
- (void)requestUpLoadError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    UIButton* btn=(UIButton*)[self.view viewWithTag:10007];
    btn.enabled=YES;
    LPPopup *popup = [LPPopup popupWithText:@"抱歉，由于长时间无法连接到网络，系统将您的录音放在了“我的”的“未发出声的文件”里，您可以选择手工上传或删除。"];
    CGPoint point=self.view.center;
    point.y=point.y+130;
    [popup showInView:self.view
        centerAtPoint:point
             duration:5.0f
           completion:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    NSLog(@"dic==%@",dic);
    recordButton.selected = NO;
    self.filePath = nil;
     yincangView.hidden = YES;
    return;
}

- (void)requestConverAndParseError:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
}
- (void)requestConverAndParseCompleted:(ASIHTTPRequest *)request
{
    [self hudWasHidden:nil];
    NSString* reqstr=[request responseString];
    NSDictionary * dic=[reqstr JSONValue];
    id status=[dic objectForKey:@"status"];
    if ([status intValue]==100)
    {
        g_userInfo.isnew=YES;
        LPPopup *popup = [LPPopup popupWithText:@"您的录音已成功上传，正在进行分析。分析报告审核完成后，会发送至您的手机上，请注意查收。"];
        CGPoint point=self.view.center;
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        BOOL bRet = [fileMgr fileExistsAtPath:self.filePath];
        if (bRet) {
            NSError *err;
            [fileMgr removeItemAtPath:self.filePath error:&err];
        }
        
        timeNStager=0;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        [self.Recordbtn setImage:[UIImage imageNamed:@"bs_an_kaishishibian.png"] forState:UIControlStateNormal];
        [self.recorder stopRecording];
    }
    else
    {
        LPPopup *popup = [LPPopup popupWithText:@"抱歉，由于长时间无法连接到网络，系统将您的录音放在了“更多”的“闻音文件”里，您可以选择手工上传或删除。"];
        CGPoint point=self.view.center;
        timeNStager=0;
        [bianshiTime setFireDate:[NSDate distantFuture]];
        [self.Recordbtn setImage:[UIImage imageNamed:@"bs_an_kaishishibian.png"] forState:UIControlStateNormal];
        [self.recorder stopRecording];
        point.y=point.y+130;
        [popup showInView:self.view
            centerAtPoint:point
                 duration:5.0f
               completion:nil];
    }
}

-(void) showHUD
{
    progress_ = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progress_];
    [self.view bringSubviewToFront:progress_];
    progress_.delegate = self;
    progress_.labelText = @"加载中...";
    [progress_ show:YES];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    NSLog(@"Hud: %@", hud);
    // Remove HUD from screen when the HUD was hidded
    [progress_ removeFromSuperview];
    [progress_ release];
    progress_ = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
