//
//  HomeViewController.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/4/19.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "HomeViewController.h"
#import "SidebarViewController.h"
#import "MessageViewController.h"
#import "SongListCell.h"
#import "MySportsView.h"
#import "RecommendReadView.h"
#import "MyaiJiuView.h"
#import "LeyaoView.h"
#import "ZCircleSlider.h"
#import "ReportScrollView.h"
#import "downloadLeyaoController.h"
#import "BlueToothViewController.h"

@interface HomeViewController ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,LeyaoDelegate,reportScrollViewSelegate>

@property (nonatomic, retain) SidebarViewController* sidebarVC;
@property (nonatomic, strong) ZCircleSlider *circleSliderV;
@property (nonatomic, assign) BOOL isDrag;
@property (nonatomic, strong) UIImageView *btnImageV;
@property (nonatomic, assign) BOOL isTap;
@property (nonatomic, assign) BOOL reportTap;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MySportsView *mySportsView;//运动视图
@property (nonatomic, strong) MyaiJiuView *aiJiuView;//艾灸视图
@property (nonatomic, strong) RecommendReadView *recommendView;
@property (nonatomic, strong) LeyaoView *leyaoView;
@property (nonatomic, strong) ReportScrollView *reportScrollV;

@property (nonatomic, strong) UIView *playView;

@property (nonatomic, strong) UIScrollView *scrollView;//上下滑动的scrollview

@property (nonatomic, copy) NSString *leyaoType; //乐药类型
@property (nonatomic, strong) NSArray *leyaoListArr;

@property (nonatomic, copy) NSString *lastFileName;

@property (nonatomic, assign) float lastSliderValue;

@end

@implementation HomeViewController

#pragma -mark 左边侧滑界面
- (void)setLeftSide
{
    // 左侧边栏
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [panGesture delaysTouchesBegan];
   // [self.view addGestureRecognizer:panGesture];
    
//    UIView *topV = [self.view viewWithTag:1001];
//    CGFloat originY = CGRectGetMaxY(topV.frame);
    CGFloat originY = 44+kStatusBarHeight;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, 40, ScreenHeight)];
    [self.view addSubview:leftView];
    [leftView addGestureRecognizer:panGesture];
    
    self.sidebarVC = [[SidebarViewController alloc] init];
    [self.sidebarVC setBgRGB:0x000000];
    [[UIApplication sharedApplication].keyWindow addSubview:self.sidebarVC.view];
//    [self.view addSubview:self.sidebarVC.view];
    self.sidebarVC.view.frame  = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

#pragma - mark 设置首页上面按钮
- (void)setTopView
{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44+kStatusBarHeight)];
    topView.tag = 1001;
    topView.backgroundColor = UIColorFromHex(0x4FAEFE);
    [self.view addSubview:topView];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 8+kStatusBarHeight, 25, 25);
    [leftBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    
    self.lastSliderValue = 0.0;
    UIButton *middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    middleBtn.frame = CGRectMake(ScreenWidth/2.0-19, 8+kStatusBarHeight, 38, 25);
    [middleBtn setImage:[UIImage imageNamed:@"耳机"] forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(middleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:middleBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(ScreenWidth-20-20, 8+kStatusBarHeight, 20, 25);
    [rightBtn setImage:[UIImage imageNamed:@"语音"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    
}

- (void)leftBtnAction
{
    [self.sidebarVC showHideSidebar];
}
#pragma - mark 蓝牙按钮
- (void)middleBtnAction:(UIButton *)button
{
    if([ShareOnce shareOnce].isBlueToothConnect){
        [self createBlueTooth:button withVolum:self.lastSliderValue];
    }else{
        BlueToothViewController *blueVC = [[BlueToothViewController alloc] init];
        [self.navigationController pushViewController:blueVC animated:YES];
    }
    
}

#pragma mark - 蓝牙强度按钮界面
- (void)createBlueTooth:(UIButton *)btn withVolum:(float)volum
{
    UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    clearView.backgroundColor = [UIColor clearColor];
    clearView.userInteractionEnabled = YES;
    clearView.tag = 1027;
    [self.view addSubview:clearView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [clearView addGestureRecognizer:tapGesture];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(30, btn.bottom+20, ScreenWidth - 30*2, 30)];
    blueView.backgroundColor = [UIColor blueColor];
    blueView.alpha = 0.5;
    blueView.tag = 1028;
    blueView.layer.cornerRadius = 5.0;
    blueView.clipsToBounds = YES;
    [self.view addSubview:blueView];

    
    UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reduceBtn.frame = CGRectMake(5, (blueView.height-25)/2, 25, 25);
    [reduceBtn setTitle:@"—" forState:UIControlStateNormal];
    [reduceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reduceBtn addTarget:self action:@selector(reduceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    reduceBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    reduceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [blueView addSubview:reduceBtn];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(reduceBtn.right+5, 5, blueView.width - reduceBtn.right-5-25-5, blueView.height-10)];
    slider.minimumValue = 0;
    slider.maximumValue = 60;
    slider.enabled = NO;
    slider.value = volum;
    slider.tag = 1029;
    slider.backgroundColor = [UIColor clearColor];
    [slider setThumbImage:[UIImage imageNamed:@"knob"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    slider.continuous = NO;//当手放开时,值才确定下来
    [blueView addSubview:slider];
    
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(blueView.width-25-5, (blueView.height-25)/2, 25, 25);
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:30];
    addBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [blueView addSubview:addBtn];
}

- (void)sliderValueChange:(UISlider *)slider
{
    if(self.lastSliderValue < slider.value){
        [self.circleSliderV volumeWithIncreaseAndReduce:[NSString stringWithFormat:@"%.2ld",(long)slider.value]];
    }else{
        [self.circleSliderV volumeWithReduce:[NSString stringWithFormat:@"%.2ld",(long)slider.value]];
    }
    self.lastSliderValue = slider.value;
}

- (void)reduceBtnAction:(UIButton *)btn
{
    UIView *blueView = [self.view viewWithTag:1028];
    UISlider *slider = (UISlider *)[blueView viewWithTag:1029];
    slider.value = (long)slider.value - 1;
    [self.circleSliderV volumeWithReduce:[NSString stringWithFormat:@"%.2ld",(long)slider.value]];
    self.lastSliderValue = slider.value;
}

- (void)addBtnAction:(UIButton *)btn
{
    UIView *blueView = [self.view viewWithTag:1028];
    UISlider *slider = (UISlider *)[blueView viewWithTag:1029];
    slider.value = (long)slider.value +  1;
    [self.circleSliderV volumeWithIncreaseAndReduce:[NSString stringWithFormat:@"%.2ld",(long)slider.value]];
    self.lastSliderValue = slider.value;
}

- (void)tapGestureAction
{
    UIView *clearView = [self.view viewWithTag:1027];
    UIView *blueView = [self.view viewWithTag:1028];
    [blueView removeFromSuperview];
    [clearView removeFromSuperview];
}



#pragma mark - 录音按钮
- (void)rightBtnAction
{
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)panDetected:(UIPanGestureRecognizer*)recoginzer
{
   
    [self.sidebarVC panDetected:recoginzer];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    //[self setTopView];
    [self setPlayView];
    [self setLeftSide];
    [self setLeyaoView];
    [self setMySportsView];
    [self requestLeyaoListWithSkip:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bianshiSuccess:) name:@"bianshiUploadSuccess" object:nil];
    //en-US zh-Hans-US zh-Hant-US
    NSLog(@"语言:%@",CURRENTLANGUAGE);
}



#pragma -mark 播放圆环
- (void)setPlayView
{
    
    //UIView *topV = [self.view viewWithTag:1001];
    CGFloat originY = 44+kStatusBarHeight;
    
    self.playView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.4-50+44+kStatusBarHeight+8)];
    
    if(IS_IPHONE_6){
        self.playView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight*0.4-32+originY+6);
    }
    if(iPhoneX){
        self.playView.frame = CGRectMake(0, 0, ScreenWidth, originY+8+220+15+20);
    }
    self.playView.frame = CGRectMake(0, 0, ScreenWidth, originY+8+230+15+20);
    self.playView = [self borderForView:self.playView color:UIColorFromHex(0X4FAEFE)];
    self.playView.tag = 1002;
    //self.playView.backgroundColor =  UIColorFromHex(0X4FAEFE);
    self.playView.userInteractionEnabled = YES;
    
    //添加渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.playView.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)UIColorFromHex(0x4FAEFE).CGColor,(id)UIColorFromHex(0x35BAFD).CGColor,(id)UIColorFromHex(0x35BAFD).CGColor,(id)UIColorFromHex(0x4FAEFE).CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.locations = @[@0.25,@0.5,@0.75,@1.0];
    [self.playView.layer addSublayer:gradientLayer];
    [self.view addSubview:self.playView];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 8+kStatusBarHeight, 25, 25);
    [leftBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:leftBtn];
    
    self.lastSliderValue = 0.0;
    UIButton *middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    middleBtn.frame = CGRectMake(ScreenWidth/2.0-19, 8+kStatusBarHeight, 38, 25);
    [middleBtn setImage:[UIImage imageNamed:@"耳机"] forState:UIControlStateNormal];
    [middleBtn addTarget:self action:@selector(middleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:middleBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(ScreenWidth-20-20, 8+kStatusBarHeight, 20, 25);
    [rightBtn setImage:[UIImage imageNamed:@"语音"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.playView addSubview:rightBtn];
    
    self.circleSliderV = [[ZCircleSlider alloc] initWithFrame:CGRectMake((ScreenWidth-230)/2.0, 8+originY, 230, 230)];
    //UIColorFromHex(0x1482f0)
    self.circleSliderV.minimumTrackTintColor = UIColorFromHex(0xFFFFFF);
    //UIColorFromHex(0xFFFFFF)
    self.circleSliderV.maximumTrackTintColor = [UIColor whiteColor];
    self.circleSliderV.backgroundTintColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1];
    self.circleSliderV.circleBorderWidth = 6.0f;
    self.circleSliderV.thumbRadius = 5;
    self.circleSliderV.thumbExpandRadius = 12.5;
    self.circleSliderV.thumbTintColor = [UIColor redColor];
    self.circleSliderV.circleRadius = 230 / 2.0 - 3;
    self.circleSliderV.value = 0.25;
    self.circleSliderV.loadProgress = 0;
    [self.playView addSubview:self.circleSliderV];
    
    UIImageView *circleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"首页_宫%@",[ShareOnce shareOnce].languageStr]]];
    NSLog(@"frame:%@",NSStringFromCGRect(circleImageV.frame));
    circleImageV.frame = CGRectMake((ScreenWidth-circleImageV.frame.size.width/1.1)/2.0, self.circleSliderV.frame.origin.y+(self.circleSliderV.frame.size.height-circleImageV.frame.size.height/1.1)/2.0, circleImageV.frame.size.width/1.1, circleImageV.frame.size.height/1.1);
    circleImageV.tag = 200;
    [self.playView addSubview:circleImageV];
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(circleImageV.width/2.0-40, circleImageV.height/2.0-16, 80, 32)];
    imageV2.contentMode = UIViewContentModeScaleAspectFit;
    imageV2.userInteractionEnabled = YES;
    imageV2.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_上宫%@",[ShareOnce shareOnce].languageStr]];
    imageV2.tag = 201;
    [circleImageV addSubview:imageV2];
    circleImageV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapReport = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReportAct:)];
    [imageV2 addGestureRecognizer:tapReport];
    
    NSInteger status = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_%@",g_userInfo.UserName,leYaoStatus]];
    if(status!=0){
        NSDictionary *dic = [self dicWithFileStatus:status];
        NSString *type = [dic objectForKey:@"type"];
        self.leyaoType = type;
        circleImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_%@",[type substringFromIndex:type.length - 1]]];
        imageV2.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_%@",type]];
    }else{
        self.leyaoType = @"上宫";
    }
    
}

- (NSDictionary *)dicWithFileStatus:(NSInteger)status
{
    if(status>0){
        NSString *filePath = @"";
        if([[ShareOnce shareOnce].languageStr isEqualToString:@"_en"]){
            filePath = [[NSBundle mainBundle] pathForResource:@"report_en" ofType:@"plist"];
        }else{
            filePath = [[NSBundle mainBundle] pathForResource:@"report" ofType:@"plist"];
        }
        
        NSArray *arr = [NSArray arrayWithContentsOfFile:filePath];
        NSDictionary *dic = [arr objectAtIndex:status - 1];
        return dic;
    }
    return nil;
}

#pragma mark - 创建列表界面
- (void)setLeyaoView
{
    //下方列表展开按钮
    //CGFloat listY = CGRectGetMaxY(self.circleSliderV.frame)+10;
    CGFloat listY = self.playView.bottom-10;
    self.leyaoView = [[LeyaoView alloc] initWithFrame:CGRectMake(23, listY, ScreenWidth - 23*2, 48+45*3+10) withCurrentArr:self.leyaoListArr];
    //UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(23, listY, ScreenWidth - 23*2, 48+45*3+10)];
    self.leyaoView.backgroundColor = UIColorFromHex(0xFFFFFF);
    self.leyaoView.layer.cornerRadius = 12;
    self.leyaoView.tag = 103;
    self.leyaoView.delegate = self;
    
    [self.view addSubview:self.leyaoView];
    
}

#pragma mark - 创建我的运动视图
- (void)setMySportsView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.leyaoView.bottom+10, ScreenWidth, ScreenHeight-self.leyaoView.bottom-10)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    self.scrollView.contentSize = CGSizeMake(1, ScreenHeight+260);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
    //UIView *listv = [self.scrollView viewWithTag:103];
    self.mySportsView = [[MySportsView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (ScreenWidth-23*2-22)/4.0+65) withLeyaoType:self.leyaoType];
    self.mySportsView.tag = 104;
    self.mySportsView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:self.mySportsView];

   // [self setAijiuView];
    [self setRecommendReadView];
}

#pragma mark - 创建艾灸视图
- (void)setAijiuView
{
    self.aiJiuView = [[MyaiJiuView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mySportsView.frame)+10, ScreenWidth, 140)];
    self.aiJiuView.tag = 105;
    [self.scrollView addSubview:self.aiJiuView];
    
    [self setRecommendReadView];
}

#pragma mark - 创建推荐阅读视图
- (void)setRecommendReadView
{
    
    CGFloat width = (ScreenWidth - 23 - 10)/2.5;
    self.recommendView = [[RecommendReadView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mySportsView.frame)+10, ScreenWidth, width*0.75+7+40+55)];
    [self.scrollView addSubview:self.recommendView];
    self.scrollView.contentSize = CGSizeMake(1, self.recommendView.bottom+10);
    
}

#pragma mark -报告按钮点击事件
- (void)tapReportAct:(UITapGestureRecognizer *)tap
{
    self.reportTap = !self.reportTap;
    if(!self.reportScrollV){
        self.reportScrollV = [[ReportScrollView alloc] initWithFrame:CGRectMake(0, self.playView.bottom-20, ScreenWidth, ScreenHeight-self.playView.bottom+20)];
        self.reportScrollV.listenMusicdelegate = self;
        [self.view addSubview:self.reportScrollV];
        
        NSInteger status = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_%@",g_userInfo.UserName,leYaoStatus]];
        if(status!=0){
            NSDictionary *dic = [self dicWithFileStatus:status];
            if(dic){
                [self.reportScrollV reloadDataWithDic:dic];
            }
        }else{
            NSDictionary *dic = [self dicWithFileStatus:6];
            if(dic){
                [self.reportScrollV reloadDataWithDic:dic];
            }
        }
        
    }else{
        
        [self.reportScrollV removeFromSuperview];
        self.reportScrollV = nil;
    }
    
}


- (void)listenMusicAction:(UIButton *)btn
{
    [self.reportScrollV removeFromSuperview];
    self.reportScrollV = nil;
    [self requestLeyaoListWithSkip:YES];
}

#pragma mark - 获取乐药列表
- (void)requestLeyaoListWithSkip:(BOOL)isSkip
{
    NSString *UrlPre=URL_PRE;
    //测试
    //self.leyaoType = @"加宫";
    NSString *subjectSn = [GlobalCommon getSubjectSnFrom:self.leyaoType];
    if (subjectSn == nil) {
        return ;
    }
    
    NSString *aUrlle= [NSString stringWithFormat:@"%@/resources/listBySubject.jhtml?subjectSn=%@&mediaType=%@",UrlPre,subjectSn,@"audio"];
    
    __block typeof(self) bself = self;
    [[NetWorkSharedInstance sharedInstance] networkWithRequestUrlStr:aUrlle RequestMethod:@"GET" PostDictionay:nil headDictionay:nil  Success:^(id result, int flag) {
        
        id status=[result objectForKey:@"status"];
        if (status!=nil)
        {
            if ([status intValue]==100)
            {
                NSLog(@"线上环境");
                
                NSArray *arr = [result objectForKey:@"data"];
                NSMutableArray *arr2 = [NSMutableArray arrayWithCapacity:0];
                for(NSDictionary *dic in arr){
                    if(![[dic objectForKey:@"status"] isKindOfClass:[NSNull class]] && [dic objectForKey:@"status"] != nil){
                        if([[dic objectForKey:@"status"] isEqualToString:@"unpaid"]){
                            [arr2 addObject:dic];
                        }
                    }
                }
                if(isSkip){
                    if(arr2.count>0){
                        NSArray *dataArr = [arr2 copy];
                        downloadLeyaoController *downloadVC = [[downloadLeyaoController alloc] initWithDataArr:dataArr];
                        [bself.navigationController pushViewController:downloadVC animated:YES];
                    }else{
                        //[bself.reportScrollV removeFromSuperview];
                    }
                }else{
                    self.leyaoView.dataArr = arr;
                }
                
                return;
                
            }
            else if ([status intValue] == 44)
            {
                [self showAlertWarmMessage:@"登录超时，请重新登录"];
                return;
            }else{
                NSString *str = [result objectForKey:@"data"];
                [self showAlertWarmMessage:str];
                return;
            }
        }
        
    } Fail:^(id error, int flag) {
        [self showAlertWarmMessage:@"抱歉，请检查您的网络是否畅通"];
    }];
}

#pragma mark - 语音辨识通知事件
- (void)bianshiSuccess:(NSNotification *)noti
{
    if(!self.reportScrollV){
        self.reportScrollV = [[ReportScrollView alloc] initWithFrame:CGRectMake(0, self.leyaoView.top-15, ScreenWidth, ScreenHeight-self.leyaoView.top+15)];
        self.reportScrollV.listenMusicdelegate = self;
        [self.view addSubview:self.reportScrollV];
    }
    self.reportTap = YES;
    NSInteger status = [[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"%@_%@",g_userInfo.UserName,leYaoStatus]];
    NSDictionary *dic = [self dicWithFileStatus:status];
    if(dic){
        NSString *type = [dic objectForKey:@"type"];
        self.leyaoType = type;
        UIImageView *imgV1 = (UIImageView *)[self.playView viewWithTag:200];
        UIImageView *imgV2 = (UIImageView *)[imgV1 viewWithTag:201];
        imgV1.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_%@%@",[ShareOnce shareOnce].languageStr,[type substringFromIndex:type.length - 1]]];
        imgV2.image = [UIImage imageNamed:[NSString stringWithFormat:@"首页_%@%@",[ShareOnce shareOnce].languageStr,type]];
        [self.mySportsView refreshSportImage:type];
        [self.reportScrollV reloadDataWithDic:dic];
        [self requestLeyaoListWithSkip:NO];
    }
}

#pragma mark 设置视图下面边框
- (UIView *)borderForView:(UIView *)originalView color:(UIColor *)color{
    
    UIBezierPath * bezierPath = [UIBezierPath bezierPath];

//    CGPoint point1 = CGPointMake(0, originalView.frame.size.height);
//    CGPoint point2 = CGPointMake(originalView.frame.size.width/2.0, originalView.frame.size.height+55);
//    if(IS_IPHONE_6){
//        point2 = CGPointMake(originalView.frame.size.width/2.0, originalView.frame.size.height+50);
//    }
//    else if(iPhoneX){
//        point2 = CGPointMake(originalView.frame.size.width/2.0, originalView.frame.size.height+50);
//    }
//    CGPoint point3 = CGPointMake(originalView.frame.size.width, originalView.frame.size.height);
//
//    [bezierPath moveToPoint:point1];
//
//    [bezierPath addQuadCurveToPoint:point3 controlPoint:point2];
//
//    [bezierPath stroke];
    
    CGFloat hh = 20;
    bezierPath.lineCapStyle = kCGLineCapRound;
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(originalView.width,0)];
    [bezierPath addLineToPoint:CGPointMake(originalView.width, originalView.height-hh)];
    [bezierPath addLineToPoint:CGPointMake(0, originalView.height-hh)];
    [bezierPath addLineToPoint:CGPointMake(0, 0)];
    [bezierPath moveToPoint:CGPointMake(0, originalView.height-hh)];
    [bezierPath addQuadCurveToPoint:CGPointMake(originalView.width, originalView.height-hh) controlPoint:CGPointMake(originalView.width/2.0, originalView.height+hh)];
    
    [bezierPath stroke];

    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    
    shapeLayer.strokeColor = color.CGColor;

    shapeLayer.fillColor  = color.CGColor;
    
    shapeLayer.path = bezierPath.CGPath;
    
    shapeLayer.lineWidth = 1.0f;
    
    
   
    
 //   [originalView.layer addSublayer:shapeLayer];
    originalView.layer.mask = shapeLayer;
  
    
    return originalView;
}

#pragma mark - 当前/历史 切换按钮
- (void)currentAction:(UIButton *)btn
{
    if(!btn.selected){
        btn.selected=YES;
    }else{
        return;
    }
    UIView *listV = [self.view viewWithTag:103];
    UIButton *btn1 = (UIButton *)[listV viewWithTag:1003];
    UIButton *btn2 = (UIButton *)[listV viewWithTag:1004];
    if(btn.tag == 1003){
        btn2.selected = NO;
    }else{
        btn1.selected = NO;
    }
}


#pragma mark - 乐药表视图代理方法
- (void)listBtnAction:(UIButton *)btn
{
    self.scrollView.contentSize = CGSizeMake(1, self.recommendView.bottom+10);
    self.scrollView.top = self.leyaoView.bottom+10;
    self.scrollView.height = ScreenHeight - self.scrollView.top;
}

- (void)playMusicAction:(NSString *)fileName
{
    
    fileName = [[GlobalCommon Createfilepath] stringByAppendingPathComponent:fileName];
    fileName = [fileName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    self.circleSliderV.audioURL = [NSURL URLWithString:fileName];
    if(self.lastFileName == nil || [self.lastFileName isEqualToString:@""] || [fileName isEqualToString: self.lastFileName]){
        [self.circleSliderV tapAction];
    }else{
        [self.circleSliderV playMusic];
    }
    self.lastFileName = fileName;
}


- (void)showAlertViewController:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *alertAct12 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:alertAct1];
    [alertVC addAction:alertAct12];
    [self presentViewController:alertVC animated:YES completion:NULL];
}

- (void)showAlertWarmMessage:(NSString *)message
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAct1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:NULL];
    [alertVC addAction:alertAct1];
    [self presentViewController:alertVC animated:YES completion:NULL];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
