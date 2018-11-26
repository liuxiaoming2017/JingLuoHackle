//
//  BlueToothObject.h
//  Voicediagno
//
//  Created by 刘晓明 on 2018/5/29.
//  Copyright © 2018年 刘晓明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothObject : NSObject<CBCentralManagerDelegate,CBPeripheralManagerDelegate,CBPeripheralDelegate>

/*
 *  蓝牙连接必要对象
 */
@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) CBPeripheral *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic *writeCharacteristic;

+ (BlueToothObject *)shareOnce;

- (void)BluetoothConnectionWithTag:(BOOL)isTag;

@end
