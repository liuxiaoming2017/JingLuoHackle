//
//  BlueToothObject.m
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/29.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import "BlueToothObject.h"


@interface BlueToothObject()
@property (nonatomic,assign) BOOL isTag;
@end

@implementation BlueToothObject


+ (BlueToothObject *)shareOnce
{
    static BlueToothObject *shareOnce = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        shareOnce = [[BlueToothObject alloc] init];
    });
    return shareOnce;
}

#pragma mark ---------------------------------蓝牙相关

/**
 *  蓝牙初始化 连接
 */
- (void)BluetoothConnectionWithTag:(BOOL)isTag{
    self.centralMgr = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    self.isTag = isTag;
    
}

#pragma mark - 蓝牙的状态,扫描设备之前会调用中心管理者状态改变的方法
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"无法获取设备的蓝牙状态");
            if(self.isTag){
                [GlobalCommon showMessage2:@"无法获取设备的蓝牙状态" duration2:1.0];
            }
        }
            break;
        case CBCentralManagerStateResetting:
        {
            NSLog(@"蓝牙重置");
            
        }
            break;
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"该设备不支持蓝牙");
            
        }
            break;
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"未授权蓝牙权限");
            if(self.isTag){
                [GlobalCommon showMessage2:@"未授权蓝牙权限" duration2:1.0];
            }
        }
            break;
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"蓝牙已关闭");
            if(self.isTag){
                [GlobalCommon showMessage2:@"蓝牙已关闭" duration2:1.0];
            }
        }
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"蓝牙已打开");
            //[self.centralMgr scanForPeripheralsWithServices:nil options:nil];
            NSArray *arr = [self.centralMgr retrieveConnectedPeripheralsWithServices:@[[CBUUID UUIDWithString:KUUID_SERVICE]]];
            if(arr.count>0){
                for(CBPeripheral *peripheral in arr){
                   peripheral.delegate = self;
                   self.discoveredPeripheral = peripheral;
                    [self.centralMgr connectPeripheral:self.discoveredPeripheral options:nil];
                }
            }else{
                [self.centralMgr scanForPeripheralsWithServices:nil options:nil];
                }
            
            }
        
            break;
            
        default:
        {
            NSLog(@"未知的蓝牙错误");
        }
            break;
    }
    //[self getConnectState];
    
}


#pragma mark - 主动断开连接
-(void)cancelPeripheralConnection{
    if (self.discoveredPeripheral) {//已经连接外设，则断开
        [self.centralMgr cancelPeripheralConnection:self.discoveredPeripheral];
    }else{//未连接，则停止搜索外设
        [self.centralMgr stopScan];
    }
    
}

#pragma mark -- CBCentralManagerDelegate
#pragma mark- 扫描设备，连接

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"name:%@",peripheral);
    /**
     当扫描到蓝牙数据为空时,停止扫描
     */
    if (!peripheral || !peripheral.name || ([peripheral.name isEqualToString:@""])) {
        return;
    }
    
    /**
     当扫描到服务UUID与设备UUID相等时,进行蓝牙与设备链接
     */
    if ((!self.discoveredPeripheral || (self.discoveredPeripheral.state == CBPeripheralStateDisconnected))&&([peripheral.name isEqualToString:kPERIPHERAL_NAME])) {
        self.discoveredPeripheral = [peripheral copy];
        //self.peripheral.delegate = self;
        NSLog(@"connect peripheral:  %@",peripheral);
        [self.centralMgr connectPeripheral:peripheral options:nil];
    }
//    else{
//        if(self.isTag){
//           [GlobalCommon showMessage2:@"未扫描到相关设备" duration2:1.0];
//            return;
//        }
//
//    }
    
}

#pragma mark - 连接成功,扫描services
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if (!peripheral) {
        return;
    }
    [self.centralMgr stopScan];
    
    NSLog(@"peripheral did connect:  %@",peripheral);
    [self.discoveredPeripheral setDelegate:self];
    [self.discoveredPeripheral discoverServices:nil];
    //[self.peripheral discoverServices:@[KUUID_SERVICE]];
}

#pragma mark- 连接外设失败
- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>连接到名称（%@)的设备－失败:%@",[peripheral name],[error localizedDescription]);
    [GlobalCommon showMessage2:@"连接设备失败" duration2:1.0];
}

#pragma mark- 外设断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    NSLog(@"外设断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    
    //重连外设
    
    /**
     *  耳诊仪断开上设备
     */
    [[NSNotificationCenter defaultCenter] postNotificationName:LeyaoBluetoothOFF object:nil userInfo:nil];
    [ShareOnce shareOnce].isBlueToothConnect = NO;
    [GlobalCommon showMessage2:@"设备断开连接" duration2:1.0];
    //蓝牙链接失败
    // [self.centralMgr connectPeripheral:peripheral options:nil];
    
}

#pragma mark - 扫描service
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSArray *services = nil;
    
    if (peripheral != self.discoveredPeripheral) {
        NSLog(@"Wrong Peripheral.\n");
        return ;
    }
    
    if (error != nil) {
        NSLog(@"Error %@\n", error);
        return ;
    }
    
    services = [peripheral services];
    NSLog(@"%@",services);
    if (!services || ![services count]) {
        NSLog(@"No Services");
        return ;
    }
    
    for (CBService *service in services) {
        NSLog(@"该设备的service:%@",service);
        /*
         该设备的service:<CBService: 0x59851a0, isPrimary = YES, UUID = FFE0>
         
         */
        if ([[service.UUID UUIDString] isEqualToString:KUUID_SERVICE]) {
            [peripheral discoverCharacteristics:nil forService:service];
            return ;
        }
    }
    
}

#pragma mark - 搜索特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    
    for (CBCharacteristic *c in service.characteristics)
    {
        NSLog(@"\n>>>\t特征UUID FOUND(in 服务UUID:%@): %@ (data:%@)",service.UUID.description,c.UUID,c.UUID.data);
        /**
         >>>    特征UUID FOUND(in 服务UUID:FFE0): FFE1 (data:<ffe1>)
         
         >>>    特征UUID FOUND(in 服务UUID:FFE0): FFE2 (data:<ffe2>)
         
         */
        /*
         根据特征不同属性去读取或者写
         if (c.properties==CBCharacteristicPropertyRead) {
         }
         if (c.properties==CBCharacteristicPropertyWrite) {
         }
         if (c.properties==CBCharacteristicPropertyNotify) {
         }
         */
        
        //假如你和硬件商量好了，某个UUID时写，某个读的，那就不用判断啦
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:kUUID_CHARACTER_RECEIVE]]) {
            self.writeCharacteristic = c;
            [_discoveredPeripheral setNotifyValue:YES forCharacteristic:self.writeCharacteristic];
            /**
             *  耳诊仪链接上设备
             */
            if(self.isTag){
                [GlobalCommon showMessage2:@"樂樂怡连接成功" duration2:1.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:LeyaoBluetoothON object:nil userInfo:nil];
            }
            [ShareOnce shareOnce].isBlueToothConnect = YES;
        }
        
        
        if([c.UUID isEqual:[CBUUID UUIDWithString:kUUID_CHARACTER_CONFIG]]){
            self.writeCharacteristic = c;
            
        }
        
    }
}

#pragma mark - 读取数据

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didUpdateValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    
    NSData *data = characteristic.value;
    NSLog(@"蓝牙返回值------>%@",data);
    
    NSLog(@"\nFindtheValueis (UUID:%@):%@ ",characteristic.UUID,characteristic.value);
    
    
}


//打印蓝牙返回的错误数据值
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", [error localizedDescription]);
    }
}

//向peripheral中写入数据后的回调函数
- (void)peripheral:(CBPeripheral*)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    if (error) {
        NSLog(@"didWriteValueForCharacteristic error : %@", error.localizedDescription);
        return;
    }
    
    NSLog(@"write value success : %@", characteristic);
}


- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    NSLog(@"peripheralManagerDidUpdateState");
}

/**
 *  增加  强度
 */

- (void)volumeWithIncreaseAndReduce:(NSString *)number{
    
    NSLog(@"%@",number);
    /**
     *  number 为增加的数值
     增大命令 0xFA 0xE3 OxXX  XX---> 增大数字 00~60
     */
    if(!_writeCharacteristic){
        NSLog(@"writeCharacteristic is nil!");
        return;
    }
    
    NSString *increaseStr = [NSString stringWithFormat:@"FAE3%@",number];
    NSData *value = [self stringToByte:increaseStr];
    NSLog(@"%@",value);
    [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
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
    if(!_writeCharacteristic){
        NSLog(@"writeCharacteristic is nil!");
        return;
    }
    
    NSString *reduceStr = [NSString stringWithFormat:@"FAE4%@",number];
    NSData *value = [self stringToByte:reduceStr];
    [self.discoveredPeripheral writeValue:value forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
    
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


