//
//  ZCircleSlider.m
//  LoadingView
//
//  Created by ZhangBob on 24/05/2017.
//  Copyright © 2017 JixinZhang. All rights reserved.
//

#import "ZCircleSlider.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "CountDownObject.h"
#import "BlueToothObject.h"

#define marginX 44.0

@interface ZCircleSlider()<AVAudioPlayerDelegate,CBCentralManagerDelegate,CBPeripheralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) UIImageView *thumbView;
@property (nonatomic, assign) CGPoint lastPoint;        //滑块的实时位置

@property (nonatomic, assign) CGFloat radius;           //半径
@property (nonatomic, assign) CGPoint drawCenter;       //绘制圆的圆心
@property (nonatomic, assign) CGPoint circleStartPoint; //thumb起始位置
@property (nonatomic, assign) CGFloat angle;            //转过的角度

@property (nonatomic, assign) BOOL lockClockwise;       //禁止顺时针转动
@property (nonatomic, assign) BOOL lockAntiClockwise;   //禁止逆时针转动

@property (nonatomic, assign) BOOL interaction;

@property (nonatomic, strong) CountDownObject *countDownObj;
/*
 *  蓝牙连接必要对象
*/
//@property (nonatomic, strong) CBCentralManager *centralMgr;
//@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
//@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;

@end

@implementation ZCircleSlider

- (void)dealloc {
    //[super dealloc];
    [self removeObserver:self forKeyPath:@"angle"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}


/**
 设定默认值
 */
- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    self.circleRadius = MIN(self.frame.size.width, self.frame.size.height) - 24;
    
    self.circleBorderWidth = 6.0f;
    self.thumbRadius = 12.0f;
    self.thumbExpandRadius = 25.0f;
    self.maximumTrackTintColor = [UIColor lightGrayColor];
    self.minimumTrackTintColor = [UIColor blueColor];
    
    self.drawCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);
    self.loadProgress = 1.0;
    self.interaction = NO;
    self.canRepeat = NO;
    self.angle = 0;
    self.lockAntiClockwise = YES;
    self.lockClockwise = NO;
    [self addSubview:self.thumbView];
    
    self.minNum = 0;
    self.maxNum = 120*60;
    self.currentNum = 30*60;
    
    //时间label
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-200)/2.0, self.frame.size.height - 36, 200, 20)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.font = [UIFont systemFontOfSize:15.0];
    self.timeLabel.text = [self formatTime:self.currentNum];
    [self addSubview:self.timeLabel];
    
    
    //注册中断通知事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(outputDeviceChanged:)name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
    
    [[BlueToothObject shareOnce] BluetoothConnectionWithTag:NO];
    
    
}
- (void)outputDeviceChanged:(NSNotification *)aNotification

{
    //NSLog(@"haha");
//    NSLog(@"userInfo:%@",[aNotification userInfo]);
//    NSDictionary *infoDic = [aNotification userInfo];
//    if([[infoDic objectForKey:@"AVAudioSessionRouteChangeReasonKey"] longValue] == 2){
//        [ShareOnce shareOnce].isBlueToothConnect = NO;
//    }
    
}
#pragma mark - getter

- (UIImageView *)thumbView {
    if (!_thumbView) {
        _thumbView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        _thumbView.image = [UIImage imageNamed:@"home_play"];
        _thumbView.layer.masksToBounds = YES;
        _thumbView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_thumbView addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [_thumbView addGestureRecognizer:pan];

    }
    return _thumbView;
}

#pragma mark - setter

- (void)setValue:(float)value {
    if (value < 0.025) {
        self.lockClockwise = NO;
    } else {
        self.lockAntiClockwise = NO;
    }
    _value = MIN(MAX(value, 0.0), 0.997648);
    [self setNeedsDisplay];
}

- (void)setLoadProgress:(float)loadProgress {
    _loadProgress = loadProgress;
    [self setNeedsDisplay];
}

- (void)setCanRepeat:(BOOL)canRepeat {
    _canRepeat = canRepeat;
    [self setNeedsDisplay];
}

- (void)setThumbRadius:(CGFloat)thumbRadius {
    _thumbRadius = thumbRadius;
    self.thumbView.frame = CGRectMake(0, 0, thumbRadius * 2, thumbRadius * 2);
    self.thumbView.frame = CGRectMake(0, 0, 30, 30);
    self.thumbView.layer.cornerRadius = thumbRadius;

    [self setNeedsDisplay];
}

- (void)setThumbExpandRadius:(CGFloat)thumbExpandRadius {
    _thumbExpandRadius = thumbExpandRadius;
    [self setNeedsDisplay];
}

- (void)setCircleRadius:(CGFloat)circleRadius {
    _circleRadius = circleRadius;
    self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);
    [self setNeedsDisplay];
}

- (void)setCircleBorderWidth:(CGFloat)circleBorderWidth {
    _circleBorderWidth = circleBorderWidth;
    [self setNeedsDisplay];
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    [self setNeedsDisplay];
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    [self setNeedsDisplay];
}

- (void)setThumbTintColor:(UIColor *)thumbTintColor {
    _thumbTintColor = thumbTintColor;
    self.thumbView.backgroundColor = [UIColor clearColor];
    [self setNeedsDisplay];
}

#pragma mark - drwRect

- (void)drawRect:(CGRect)rect {
    self.drawCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    self.radius = self.circleRadius;
    self.circleStartPoint = CGPointMake(self.drawCenter.x, self.drawCenter.y - self.circleRadius);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //圆形的背景颜色
    CGContextSetStrokeColorWithColor(ctx, self.backgroundTintColor.CGColor);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextAddArc(ctx, self.drawCenter.x, self.drawCenter.y, self.radius, 0, 2 * M_PI, 0);
    CGContextDrawPath(ctx, kCGPathStroke);
  
    //加载的进度
    UIBezierPath *loadPath = [UIBezierPath bezierPath];
    CGFloat loadStart = -M_PI_2;
    CGFloat loadCurre = loadStart + 2 * M_PI * self.loadProgress;
    
    [loadPath addArcWithCenter:self.drawCenter
                        radius:self.radius
                    startAngle:loadStart
                      endAngle:loadCurre
                     clockwise:YES];
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextSetStrokeColorWithColor(ctx, self.maximumTrackTintColor.CGColor);
    CGContextAddPath(ctx, loadPath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    //起始位置做圆滑处理
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetFillColorWithColor(ctx, self.minimumTrackTintColor.CGColor);
    CGContextAddArc(ctx, self.circleStartPoint.x, self.circleStartPoint.y, self.circleBorderWidth / 2.0, 0, M_PI * 2, 0);
    CGContextDrawPath(ctx, kCGPathFill);
    CGContextRestoreGState(ctx);
    
    //value
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    CGFloat originstart = -M_PI_2;
    CGFloat currentOrigin = originstart + 2 * M_PI * self.value;
    [circlePath addArcWithCenter:self.drawCenter
                          radius:self.radius
                      startAngle:originstart
                        endAngle:currentOrigin
                       clockwise:YES];
    CGContextSaveGState(ctx);
    CGContextSetShouldAntialias(ctx, YES);
    CGContextSetLineWidth(ctx, self.circleBorderWidth);
    CGContextSetStrokeColorWithColor(ctx, self.minimumTrackTintColor.CGColor);
    CGContextAddPath(ctx, circlePath.CGPath);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    /*
     * 计算移动点的位置
     * alpha = 移动点相对于起始点顺时针扫过的角度(弧度)
     * x = r * sin(alpha) + 圆心的x坐标, sin在0-PI之间为正，PI-2*PI之间为负
     * y 可以通过r * cos(alpha) + 圆心的y坐标来计算。
     * 不过我这里用了另外一个比较投机的方法，先算出亮点连线在y轴上投影的长度，然后根据移动点在y轴上相对于圆心的位置将这个绝对长度a和圆心y坐标相加减。
     */
    double alpha = self.value * 2 * M_PI;
    double x = self.radius * sin(alpha) + self.drawCenter.x;
    double y = sqrt(self.radius * self.radius - pow((self.drawCenter.x - x), 2)) + self.drawCenter.y;
    double a = y - self.drawCenter.y;
    if (self.value <= 0.25 || self.value > 0.75) {
        y = self.drawCenter.y - a;
    }
    self.lastPoint = CGPointMake(x, y);
    self.thumbView.center = self.lastPoint;
    
}

#pragma mark - 音频播放的设置
- (void)setAudioURL:(NSURL *)audioURL{
    if (audioURL) {
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioURL error:nil];
        self.player.delegate = self;
        self.duration = self.player.duration;
        self.player.numberOfLoops = -1;
        [self.player prepareToPlay];
    }
    _audioURL = audioURL;
}

- (void)play{
    if (!self.player.playing) {
        
//        if (!self.displayLink) {
//            self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgressCircle)];
//            self.displayLink.frameInterval = 60;//每秒钟调用一次
//            [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//        } else {
//            self.displayLink.paused = NO;
//        }
        if(!self.countDownObj){
            self.countDownObj = [[CountDownObject alloc] init];
            __weak typeof(self) bself = self;
            [self.countDownObj countDownWithTimeInterval:60*120 withBlock:^(NSInteger currentTime) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(bself.currentNum == 0){
                        [bself.thumbView setImage:[UIImage imageNamed:@"home_play"]];
                        [bself.player stop];
                        bself.player.currentTime = 0;
                        [bself.countDownObj cancleTimer];
                        bself.isTap = NO;
                    }
                    bself.currentNum = bself.currentNum - 1;
                    double angle = (bself.currentNum/60.0 - bself.minNum)/(bself.maxNum/60.0 - bself.minNum) * 360;
                    float radian = (M_PI/180.0f)*angle;
                    
                    float x = self.drawCenter.x + sinf(radian)*self.radius;
                    
                    float y = self.drawCenter.y - cosf(radian)*self.radius;
                    
                    CGPoint point2 = CGPointMake(x, y);
                    
                    [bself moveHandlerWithPoint2:point2];
                });
            }];
        }else{
            [self.countDownObj startTimer];
        }
        
        
        [self.player play];
        
//        if(!_writeCharacteristic){
//            NSLog(@"writeCharacteristic is nil!");
//        }else{
//            Byte byte[] = {0xFA,0xE1,0x00};
//            printf("%s",byte);
//            NSData *value = [NSData dataWithBytes:byte length:3];
//            NSLog(@"Witedata: %@",value);
//            [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
//        }
        if(![BlueToothObject shareOnce].writeCharacteristic){
            NSLog(@"writeCharacteristic is nil!");
        }else{
            Byte byte[] = {0xFA,0xE1,0x00};
            NSData *value = [NSData dataWithBytes:byte length:3];
            [[BlueToothObject shareOnce].discoveredPeripheral writeValue:value forCharacteristic:[BlueToothObject shareOnce].writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

- (void)pause{
    if (self.player.playing) {
        //self.displayLink.paused = YES;
        [self.player pause];
        [self.countDownObj pauseTimer];
//        if(!_writeCharacteristic){
//            NSLog(@"writeCharacteristic is nil!");
//        }else{
//            Byte byte[] = {0xFA,0xE2,0x00};
//            NSData *value = [NSData dataWithBytes:byte length:3];
//            [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
//        }
        if(![BlueToothObject shareOnce].writeCharacteristic){
            NSLog(@"writeCharacteristic is nil!");
        }else{
            Byte byte[] = {0xFA,0xE2,0x00};
            NSData *value = [NSData dataWithBytes:byte length:3];
            [[BlueToothObject shareOnce].discoveredPeripheral writeValue:value forCharacteristic:[BlueToothObject shareOnce].writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
        }
    }
}

- (void)stop{
    [self.player stop];
    self.player.currentTime = 0;
    [self.countDownObj cancleTimer];
    self.countDownObj = nil;
//    [self.displayLink invalidate];
//    self.displayLink = nil;
}

-(void)handleInterreption:(NSNotification *)sender
{
    if(!self.audioURL){
        return;
    }
    if(self.isTap){
        [_thumbView setImage:[UIImage imageNamed:@"home_stop"]];
        [self play];
    }else{
        [_thumbView setImage:[UIImage imageNamed:@"home_play"]];
        [self pause];
    }
    self.isTap = !self.isTap;
}

#pragma mark - 播放更改进度条
- (void)updateProgressCircle{
    //update progress value
    //    self.progress = (float) (self.player.currentTime / self.player.duration);
    //    if (self.delegate && [self.delegate conformsToProtocol:@protocol(CircularProgressViewDelegate)]) {
    //        [self.delegate updateProgressViewWithPlayer:self.player];
    //    }
    if(self.currentNum == 0){
        [self.player stop];
        self.player.currentTime = 0;
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
    self.currentNum = self.currentNum - 1;
    double angle = (self.currentNum/60.0 - self.minNum)/(self.maxNum/60.0 - self.minNum) * 360;
    float radian = (M_PI/180.0f)*angle;
    
    float x = self.drawCenter.x + sinf(radian)*self.radius;
    
    float y = self.drawCenter.y - cosf(radian)*self.radius;
    
    CGPoint point2 = CGPointMake(x, y);
    
    NSLog(@"point:%@",NSStringFromCGPoint(point2));
    
    [self moveHandlerWithPoint2:point2];
}

#pragma mark AVAudioPlayerDelegate method
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (flag) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        //restore progress value
    }
}

- (void)tapAction
{
    if(!self.audioURL){
        return;
    }
    self.isTap = !self.isTap;
    if(self.isTap){
        [_thumbView setImage:[UIImage imageNamed:@"home_stop"]];
         [self play];
    }else{
        [_thumbView setImage:[UIImage imageNamed:@"home_play"]];
        [self pause];
    }
}

- (void)playMusic
{
    if(!self.audioURL){
        return;
    }
    self.isTap = YES;
    [_thumbView setImage:[UIImage imageNamed:@"home_stop"]];
    [self play];
}

- (void) handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint starTouchPoint = [pan locationInView:self];
    self.thumbView.center = self.lastPoint;
    [self moveHandlerWithPoint:starTouchPoint];
}

#pragma mark - Handle move
- (void)moveHandlerWithPoint:(CGPoint)point {
    self.interaction = YES;
    CGFloat centerX = self.drawCenter.x;
    CGFloat centerY = self.drawCenter.y;
    
    CGFloat moveX = point.x;
    CGFloat moveY = point.y;
    
    if (!self.canRepeat) {
        //到300度，禁止移动到第一，二，三象限
        if (self.lockClockwise) {
            if ((moveX >= centerX && moveY <= centerY) ||
                (moveX >= centerX && moveY >= centerY) ||
                (moveX <= centerX && moveY >= centerY)) {
                return;
            }
        }
        
        //小于60度的时候，禁止移动到第二，三，四象限
        if (self.lockAntiClockwise) {
            if ((moveX <= centerX && moveY >= centerY) ||
                (moveX <= centerX && moveY <= centerY) ||
                (moveX >= centerX && moveY >= centerY)) {
                return;
            }
        }
    }
    
    double dist = sqrt(pow((moveX - centerY), 2) + pow(moveY - centerY, 2));
    if (fabs(dist - self.radius) > marginX) {
        return;
    }
    /*
     * 计算移动点的坐标
     * sinAlpha = 亮点在x轴上投影的长度 ／ 距离
     * xT = r * sin(alpha) + 圆心的x坐标
     * yT 算法同上
     */
    double sinAlpha = (moveX - centerX) / dist;
    double xT = self.radius * sinAlpha + centerX;
    double yT = sqrt((self.radius * self.radius - (xT - centerX) * (xT - centerX))) + centerY;
    if (moveY < centerY) {
        yT = centerY - fabs(yT - centerY);
    }
    self.lastPoint = self.thumbView.center = CGPointMake(xT, yT);
    
    CGFloat angle = [ZCircleSlider calculateAngleWithRadius:self.radius
                                                     center:self.drawCenter
                                                startCenter:self.circleStartPoint
                                                  endCenter:self.lastPoint];
    if (angle >= 300) {
        //当当前角度大于等于300度时禁止移动到第一、二、三象限
        self.lockClockwise = YES;
    } else {
        self.lockClockwise = NO;
    }
    
    if (angle <= 60.0) {
        //当当前角度小于等于60度时，禁止移动到第二、三、四象限
        self.lockAntiClockwise = YES;
    } else {
        self.lockAntiClockwise = NO;
    }
    self.angle = angle;
    self.value = angle / 360;
    
    self.currentNum = self.minNum + (self.maxNum - self.minNum)*(angle/360.0);
    
    self.timeLabel.text = [self formatTime:self.currentNum];
    
}

- (NSString *)formatTime:(int)num{
    
    int sec = num % 60;
    int min = num / 60;
    if (num < 60) {
        return [NSString stringWithFormat:@"-00:%02d",num];
    }
    return [NSString stringWithFormat:@"-%02d:%02d",min,sec];
}

#pragma mark - Util

/**
 计算圆上两点间的角度

 @param radius 半径
 @param center 圆心
 @param startCenter 起始点坐标
 @param endCenter 结束点坐标
 @return 圆上两点间的角度
 */
+ (CGFloat)calculateAngleWithRadius:(CGFloat)radius
                             center:(CGPoint)center
                        startCenter:(CGPoint)startCenter
                          endCenter:(CGPoint)endCenter {
    //a^2 = b^2 + c^2 - 2bccosA;
    CGFloat cosA = (2 * radius * radius - powf([ZCircleSlider distanceBetweenPointA:startCenter pointB:endCenter], 2)) / (2 * radius * radius);
    CGFloat angle = 180 / M_PI * acosf(cosA);
    if (startCenter.x > endCenter.x) {
        angle = 360 - angle;
    }
    return angle;
}

/**
 两点间的距离

 @param pointA 点A的坐标
 @param pointB 点B的坐标
 @return 两点间的距离
 */
+ (double)distanceBetweenPointA:(CGPoint)pointA pointB:(CGPoint)pointB {
    double x = fabs(pointA.x - pointB.x);
    double y = fabs(pointA.y - pointB.y);
    return hypot(x, y);//hypot(x, y)函数为计算三角形的斜边长度
}


- (void)moveHandlerWithPoint2:(CGPoint)point {
    self.interaction = YES;
    CGFloat centerX = self.drawCenter.x;
    CGFloat centerY = self.drawCenter.y;
    
    CGFloat moveX = point.x;
    CGFloat moveY = point.y;
    
    if (!self.canRepeat) {
        //到300度，禁止移动到第一，二，三象限
        if (self.lockClockwise) {
            if ((moveX >= centerX && moveY <= centerY) ||
                (moveX >= centerX && moveY >= centerY) ||
                (moveX <= centerX && moveY >= centerY)) {
                return;
            }
        }
        
        //小于60度的时候，禁止移动到第二，三，四象限
        if (self.lockAntiClockwise) {
            if ((moveX <= centerX && moveY >= centerY) ||
                (moveX <= centerX && moveY <= centerY) ||
                (moveX >= centerX && moveY >= centerY)) {
                return;
            }
        }
    }
    
    double dist = sqrt(pow((moveX - centerY), 2) + pow(moveY - centerY, 2));
    if (fabs(dist - self.radius) > marginX) {
        return;
    }
    /*
     * 计算移动点的坐标
     * sinAlpha = 亮点在x轴上投影的长度 ／ 距离
     * xT = r * sin(alpha) + 圆心的x坐标
     * yT 算法同上
     */
    double sinAlpha = (moveX - centerX) / dist;
    double xT = self.radius * sinAlpha + centerX;
    double yT = sqrt((self.radius * self.radius - (xT - centerX) * (xT - centerX))) + centerY;
    if (moveY < centerY) {
        yT = centerY - fabs(yT - centerY);
    }
    self.lastPoint = self.thumbView.center = CGPointMake(xT, yT);
    
    CGFloat angle = [ZCircleSlider calculateAngleWithRadius:self.radius
                                                     center:self.drawCenter
                                                startCenter:self.circleStartPoint
                                                  endCenter:self.lastPoint];
    if (angle >= 300) {
        //当当前角度大于等于300度时禁止移动到第一、二、三象限
        self.lockClockwise = YES;
    } else {
        self.lockClockwise = NO;
    }
    
    if (angle <= 60.0) {
        //当当前角度小于等于60度时，禁止移动到第二、三、四象限
        self.lockAntiClockwise = YES;
    } else {
        self.lockAntiClockwise = NO;
    }
    self.angle = angle;
    self.value = angle / 360;
    
    self.timeLabel.text = [self formatTime:self.currentNum];
    
}


#pragma mark ---------------------------------蓝牙相关

/**
*  蓝牙初始化 连接
*/

//- (void)BluetoothConnection{
//    self.centralMgr = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
//
//}
//
//#pragma mark - 蓝牙的状态,扫描设备之前会调用中心管理者状态改变的方法
//-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
//    switch (central.state) {
//        case CBCentralManagerStateUnknown:
//        {
//            NSLog(@"无法获取设备的蓝牙状态");
//        }
//            break;
//        case CBCentralManagerStateResetting:
//        {
//            NSLog(@"蓝牙重置");
//
//        }
//            break;
//        case CBCentralManagerStateUnsupported:
//        {
//            NSLog(@"该设备不支持蓝牙");
//
//        }
//            break;
//        case CBCentralManagerStateUnauthorized:
//        {
//            NSLog(@"未授权蓝牙权限");
//        }
//            break;
//        case CBCentralManagerStatePoweredOff:
//        {
//            NSLog(@"蓝牙已关闭");
//        }
//            break;
//        case CBCentralManagerStatePoweredOn:
//        {
//            NSLog(@"蓝牙已打开");
//            //[self.centralMgr scanForPeripheralsWithServices:nil options:nil];
//            NSArray *arr = [self.centralMgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:KUUID_SERVICE]]];
//            if(arr.count>0){
//                for(CBPeripheral *peripheral in arr){
//                    peripheral.delegate = self;
//                    self.discoveredPeripheral = peripheral;
//                    [self.centralMgr connectPeripheral:self.discoveredPeripheral options:nil];
//                }
//            }else{
//               [self.centralMgr scanForPeripheralsWithServices:nil options:nil];
//            }
//
//        }
//            break;
//
//        default:
//        {
//            NSLog(@"未知的蓝牙错误");
//        }
//            break;
//    }
//    //[self getConnectState];
//
//}
//
//
//#pragma mark - 主动断开连接
//-(void)cancelPeripheralConnection{
//    if (self.discoveredPeripheral) {//已经连接外设，则断开
//        [self.centralMgr cancelPeripheralConnection:self.discoveredPeripheral];
//    }else{//未连接，则停止搜索外设
//        [self.centralMgr stopScan];
//    }
//
//}
//
//#pragma mark -- CBCentralManagerDelegate
//#pragma mark- 扫描设备，连接
//
//- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
//{
//    NSLog(@"name:%@",peripheral);
//    /**
//     当扫描到蓝牙数据为空时,停止扫描
//     */
//    if (!peripheral || !peripheral.name || ([peripheral.name isEqualToString:@""])) {
//        return;
//    }
//
//    /**
//     当扫描到服务UUID与设备UUID相等时,进行蓝牙与设备链接
//     */
//    if ((!self.discoveredPeripheral || (self.discoveredPeripheral.state == CBPeripheralStateDisconnected))&&([peripheral.name isEqualToString:kPERIPHERAL_NAME])) {
//        self.discoveredPeripheral = [peripheral copy];
//        //self.peripheral.delegate = self;
//        NSLog(@"connect peripheral:  %@",peripheral);
//        [self.centralMgr connectPeripheral:peripheral options:nil];
//    }
//
//}
//
//#pragma mark - 连接成功,扫描services
//- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
//{
//    if (!peripheral) {
//        return;
//    }
//    [self.centralMgr stopScan];
//
//    NSLog(@"peripheral did connect:  %@",peripheral);
//    [self.discoveredPeripheral setDelegate:self];
//    [self.discoveredPeripheral discoverServices:nil];
//    //[self.peripheral discoverServices:@[KUUID_SERVICE]];
//}
//
//#pragma mark- 连接外设失败
//- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
//    NSLog(@">>>连接到名称（%@)的设备－失败:%@",[peripheral name],[error localizedDescription]);
//}
//
//#pragma mark- 外设断开连接
//- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
//    NSLog(@"外设断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
//
//    //重连外设
//
//    /**
//     *  耳诊仪断开上设备
//     */
//    [[NSNotificationCenter defaultCenter] postNotificationName:LeyaoBluetoothOFF object:nil userInfo:nil];
//    [ShareOnce shareOnce].isBlueToothConnect = NO;
//    //蓝牙链接失败
//    // [self.centralMgr connectPeripheral:peripheral options:nil];
//
//}
//
//#pragma mark - 扫描service
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
//{
//    NSArray *services = nil;
//
//    if (peripheral != self.discoveredPeripheral) {
//        NSLog(@"Wrong Peripheral.\n");
//        return ;
//    }
//
//    if (error != nil) {
//        NSLog(@"Error %@\n", error);
//        return ;
//    }
//
//    services = [peripheral services];
//    NSLog(@"%@",services);
//    if (!services || ![services count]) {
//        NSLog(@"No Services");
//        return ;
//    }
//
//    for (CBService *service in services) {
//        NSLog(@"该设备的service:%@",service);
//        /*
//         该设备的service:<CBService: 0x59851a0, isPrimary = YES, UUID = FFE0>
//
//         */
//        if ([[service.UUID UUIDString] isEqualToString:KUUID_SERVICE]) {
//            [peripheral discoverCharacteristics:nil forService:service];
//            return ;
//        }
//    }
//
//}
//
//#pragma mark - 搜索特征
//- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
//{
//    if (error)
//    {
//        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
//        return;
//    }
//
//    for (CBCharacteristic *c in service.characteristics)
//    {
//        NSLog(@"\n>>>\t特征UUID FOUND(in 服务UUID:%@): %@ (data:%@)",service.UUID.description,c.UUID,c.UUID.data);
//        /**
//         >>>    特征UUID FOUND(in 服务UUID:FFE0): FFE1 (data:<ffe1>)
//
//         >>>    特征UUID FOUND(in 服务UUID:FFE0): FFE2 (data:<ffe2>)
//
//         */
//        /*
//         根据特征不同属性去读取或者写
//         if (c.properties==CBCharacteristicPropertyRead) {
//         }
//         if (c.properties==CBCharacteristicPropertyWrite) {
//         }
//         if (c.properties==CBCharacteristicPropertyNotify) {
//         }
//         */
//
//        //假如你和硬件商量好了，某个UUID时写，某个读的，那就不用判断啦
//
//        if ([c.UUID isEqual:[CBUUID UUIDWithString:kUUID_CHARACTER_RECEIVE]]) {
//            self.writeCharacteristic = c;
//            [_discoveredPeripheral setNotifyValue:YES forCharacteristic:self.writeCharacteristic];
//            /**
//             *  耳诊仪链接上设备
//             */
//            [[NSNotificationCenter defaultCenter] postNotificationName:LeyaoBluetoothON object:nil userInfo:nil];
//            [ShareOnce shareOnce].isBlueToothConnect = YES;
//        }
//
//
//        if([c.UUID isEqual:[CBUUID UUIDWithString:kUUID_CHARACTER_CONFIG]]){
//            self.writeCharacteristic = c;
//
//        }
//
//    }
//}
//
//#pragma mark - 读取数据
//
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
//{
//    if (error)
//    {
//        NSLog(@"didUpdateValueForCharacteristic error : %@", error.localizedDescription);
//        return;
//    }
//
//    NSData *data = characteristic.value;
//    NSLog(@"蓝牙返回值------>%@",data);
//
//    NSLog(@"\nFindtheValueis (UUID:%@):%@ ",characteristic.UUID,characteristic.value);
//
//
//}
//
//
////打印蓝牙返回的错误数据值
//- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
//    if (error) {
//        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
//    }
//}
//
////向peripheral中写入数据后的回调函数
//- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//
//    if (error) {
//        NSLog(@"didWriteValueForCharacteristic error : %@", error.localizedDescription);
//        return;
//    }
//
//    NSLog(@"write value success : %@", characteristic);
//}
//
//- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
//{
//    NSLog(@"peripheralManagerDidUpdateState");
//}
//
/**
 *  增加  强度
 */

- (void)volumeWithIncreaseAndReduce:(NSString *)number{

    NSLog(@"%@",number);
    /**
     *  number 为增加的数值
     增大命令 0xFA 0xE3 OxXX  XX---> 增大数字 00~60
     */
//    if(!_writeCharacteristic){
//        NSLog(@"writeCharacteristic is nil!");
//        return;
//    }
    if(![BlueToothObject shareOnce].writeCharacteristic){
        return;
    }

    NSString *increaseStr = [NSString stringWithFormat:@"FAE3%@",number];
    NSData *value = [self stringToByte:increaseStr];
    NSLog(@"%@",value);
//    [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    [[BlueToothObject shareOnce].discoveredPeripheral writeValue:value forCharacteristic:[BlueToothObject shareOnce].writeCharacteristic type:CBCharacteristicWriteWithoutResponse];

}


/**
 *  减少 强度
 *
 */
- (void)volumeWithReduce:(NSString *)number{
    NSLog(@"%@",number);
    /**
     *  number 减少的数值
     减少命令 0xFA 0xE4 OxXX  XX---> 减少数字 00~60

     */
//    if(!_writeCharacteristic){
//        NSLog(@"writeCharacteristic is nil!");
//        return;
//    }
    if(![BlueToothObject shareOnce].writeCharacteristic){
        return;
    }

    NSString *reduceStr = [NSString stringWithFormat:@"FAE4%@",number];
    NSData *value = [self stringToByte:reduceStr];
    //[self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    [[BlueToothObject shareOnce].discoveredPeripheral writeValue:value forCharacteristic:[BlueToothObject shareOnce].writeCharacteristic type:CBCharacteristicWriteWithoutResponse];

}


/**
 *  设备给蓝牙传输数据 必须以十六进制数据传给蓝牙 蓝牙设备才会执行
 因为iOS 蓝牙库中方法 传输书记是以NSData形式 这个方法 字符串 ---> 十六进制数据 ---> NSData数据
 *
 *  @param string 传入字符串命令
 *
 *  @return 将字符串 ---> 十六进制数据 ---> NSData数据
 */

-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;

        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;

        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}


@end
