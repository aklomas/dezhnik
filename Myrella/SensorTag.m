//
//  SensorTag.m
//  Myrella
//
//  Created by Filip Kralj on 18/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "SensorTag.h"

@implementation SensorTag

-(id) init {
    self = [super init];
    if (self) {
        self.device = nil;
        
        self.magSensor = [[sensorMAG3110 alloc] init];        
        self.gyroSensor = [[sensorIMU3000 alloc] init];

        self.currentVal = [[sensorTagValues alloc] init];
        self.vals = [[NSMutableArray alloc]init];
        
        self.logInterval = 1.0; //1000 ms
        
        self.m = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
        self.nDevices = [[NSMutableArray alloc]init];
        self.sensorTags = [[NSMutableArray alloc]init];
        
        self.sensorsEnabled = [[NSMutableArray alloc] init];
        self.isConnected = false;
    }
    return self;
}

-(void) deinit {
    [self deconfigureSensorTag];
}

-(void) configureSensorTag {
    // Configure sensortag, turning on Sensors and setting update period for sensors etc ...
    
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"])) {
        // Enable Temperature sensor
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"IR temperature config UUID"]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        
        if ([self sensorEnabled:@"Ambient temperature active"]) [self.sensorsEnabled addObject:@"Ambient temperature"];
        if ([self sensorEnabled:@"IR temperature active"]) [self.sensorsEnabled addObject:@"IR temperature"];
        
    }
    
    if ([self sensorEnabled:@"Gyroscope active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Gyroscope service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Gyroscope config UUID"]];
        CBUUID *pUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Gyroscope period UUID"]];
        NSInteger period = [[self.device.setupData valueForKey:@"Gyroscope period"] integerValue];
        uint8_t periodData = (uint8_t)(period / 10);
        NSLog(@"%d",periodData);
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Gyroscope data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Gyroscope"];
    }
    
    if ([self sensorEnabled:@"Humidity active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Humidity service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Humidity config UUID"]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Humidity data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Humidity"];
    }
    
    if ([self sensorEnabled:@"Barometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer config UUID"]];
        //Issue calibration to the device
        uint8_t data = 0x02;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        
        cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer calibration UUID"]];
        [BLEUtility readCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID];
        [self.sensorsEnabled addObject:@"Barometer"];
    }
    if ([self sensorEnabled:@"Accelerometer active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Accelerometer service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Accelerometer config UUID"]];
        uint8_t data = 0x07;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Accelerometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Accelerometer"];
    }
    
    if ([self sensorEnabled:@"Magnetometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Magnetometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Magnetometer config UUID"]];
        CBUUID *pUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Magnetometer period UUID"]];
        NSInteger period = [[self.device.setupData valueForKey:@"Magnetometer period"] integerValue];
        uint8_t periodData = (uint8_t)(period / 10);
        NSLog(@"%d",periodData);
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:pUUID data:[NSData dataWithBytes:&periodData length:1]];
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Magnetometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:YES];
        [self.sensorsEnabled addObject:@"Magnetometer"];
    }
    
}

-(void) deconfigureSensorTag {
    if (([self sensorEnabled:@"Ambient temperature active"]) || ([self sensorEnabled:@"IR temperature active"])) {
        // Enable Temperature sensor
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"IR temperature service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"IR temperature config UUID"]];
        unsigned char data = 0x00;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"IR temperature data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Accelerometer active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Accelerometer service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Accelerometer config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Accelerometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Humidity active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Humidity service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Humidity config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Humidity data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Magnetometer active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Magnetometer service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Magnetometer config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Magnetometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Gyroscope active"]) {
        CBUUID *sUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Gyroscope service UUID"]];
        CBUUID *cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Gyroscope config UUID"]];
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Gyroscope data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
    }
    if ([self sensorEnabled:@"Barometer active"]) {
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer config UUID"]];
        //Disable sensor
        uint8_t data = 0x00;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        cUUID =  [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer data UUID"]];
        [BLEUtility setNotificationForCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID enable:NO];
        
    }
}

-(bool)sensorEnabled:(NSString *)Sensor {
    NSString *val = [self.device.setupData valueForKey:Sensor];
    if (val) {
        if ([val isEqualToString:@"1"]) return TRUE;
    }
    return FALSE;
}

-(int)sensorPeriod:(NSString *)Sensor {
    NSString *val = [self.device.setupData valueForKey:Sensor];
    return (int)[val integerValue];
}



#pragma mark - CBCentralManager delegate functions


-(void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Disconnected from SensorTag");
    self.isConnected = false;
    self.sensorsEnabled = [[NSMutableArray alloc] init];
    [self.rssiTimer invalidate];
    [self.logTimer invalidate];
    [central scanForPeripheralsWithServices:nil options:nil];
}


- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Failed to connect to SensorTag");
    self.isConnected = false;
    [self.rssiTimer invalidate];
    [self.logTimer invalidate];
    self.sensorsEnabled = [[NSMutableArray alloc] init];
    [central scanForPeripheralsWithServices:nil options:nil];
}


-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLE not supported !" message:[NSString stringWithFormat:@"CoreBluetooth return state: %ld",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}




-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Found a BLE Device : %@",peripheral);
    
    /* iOS 6.0 bug workaround : connect to device before displaying UUID !
     The reason for this is that the CFUUID .UUID property of CBPeripheral
     here is null the first time an unkown (never connected before in any app)
     peripheral is connected. So therefore we connect to all peripherals we find.
     */
    
    peripheral.delegate = self;
    [central connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey : @YES}];
    
    [self.nDevices addObject:peripheral];

//    NSLog(@"Found Device: %@",[peripheral.name lowercaseString]);
//    
//    if([[peripheral.name lowercaseString] isEqualToString:@"ti ble sensor tag"] || [[peripheral.name lowercaseString] isEqualToString:@"sensortag"]) {
//        NSLog(@"Found SensorTag");
//        [central stopScan];
//        
//        self.device = [[BLEDevice alloc]init];
//        
//        self.device.p = peripheral;
//        self.device.p.delegate = self;
//        [central connectPeripheral:self.device.p options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey : @YES}];
//        
//        self.device.manager = self.m;
//        self.device.setupData = [self makeSensorTagConfiguration];
//        
//        [self configureSensorTag];
//        
//        [self.magSensor calibrate];
//        [self.gyroSensor calibrate];
//    }

}


#pragma mark - SensorTag configuration

-(NSMutableDictionary *) makeSensorTagConfiguration {
    NSMutableDictionary *d = [[NSMutableDictionary alloc] init];
    // First we set ambient temperature
    [d setValue:@"1" forKey:@"Ambient temperature active"];
    // Then we set IR temperature
    [d setValue:@"1" forKey:@"IR temperature active"];
    // Append the UUID to make it easy for app
    [d setValue:@"F000AA00-0451-4000-B000-000000000000"  forKey:@"IR temperature service UUID"];
    [d setValue:@"F000AA01-0451-4000-B000-000000000000" forKey:@"IR temperature data UUID"];
    [d setValue:@"F000AA02-0451-4000-B000-000000000000"  forKey:@"IR temperature config UUID"];
    // Then we setup the Gyroscope
    [d setValue:@"1" forKey:@"Gyroscope active"];
    [d setValue:@"500" forKey:@"Gyroscope period"];
    [d setValue:@"F000AA10-0451-4000-B000-000000000000"  forKey:@"Gyroscope service UUID"];
    [d setValue:@"F000AA11-0451-4000-B000-000000000000"  forKey:@"Gyroscope data UUID"];
    [d setValue:@"F000AA12-0451-4000-B000-000000000000"  forKey:@"Gyroscope config UUID"];
    [d setValue:@"F000AA13-0451-4000-B000-000000000000"  forKey:@"Gyroscope period UUID"];
    
    //Then we setup the rH sensor
    [d setValue:@"1" forKey:@"Humidity active"];
    [d setValue:@"F000AA20-0451-4000-B000-000000000000"   forKey:@"Humidity service UUID"];
    [d setValue:@"F000AA21-0451-4000-B000-000000000000" forKey:@"Humidity data UUID"];
    [d setValue:@"F000AA22-0451-4000-B000-000000000000" forKey:@"Humidity config UUID"];
    
    //Then we setup the magnetometer
    [d setValue:@"1" forKey:@"Magnetometer active"];
    [d setValue:@"500" forKey:@"Magnetometer period"];
    [d setValue:@"F000AA30-0451-4000-B000-000000000000" forKey:@"Magnetometer service UUID"];
    [d setValue:@"F000AA31-0451-4000-B000-000000000000" forKey:@"Magnetometer data UUID"];
    [d setValue:@"F000AA32-0451-4000-B000-000000000000" forKey:@"Magnetometer config UUID"];
    [d setValue:@"F000AA33-0451-4000-B000-000000000000" forKey:@"Magnetometer period UUID"];
    
    //Then we setup the barometric sensor
    [d setValue:@"1" forKey:@"Barometer active"];
    [d setValue:@"F000AA40-0451-4000-B000-000000000000" forKey:@"Barometer service UUID"];
    [d setValue:@"F000AA41-0451-4000-B000-000000000000" forKey:@"Barometer data UUID"];
    [d setValue:@"F000AA42-0451-4000-B000-000000000000" forKey:@"Barometer config UUID"];
    [d setValue:@"F000AA43-0451-4000-B000-000000000000" forKey:@"Barometer calibration UUID"];
    
    [d setValue:@"1" forKey:@"Accelerometer active"];
    [d setValue:@"F000AA50-0451-4000-B000-000000000000" forKey:@"Accelerometer service UUID"];
    [d setValue:@"F000AA51-0451-4000-B000-000000000000" forKey:@"Accelerometer data UUID"];
    [d setValue:@"F000AA52-0451-4000-B000-000000000000" forKey:@"Accelerometer config UUID"];
    [d setValue:@"F000AA13-0451-4000-B000-000000000000"  forKey:@"Accelerometer period UUID"];
    
    //NSLog(@"%@",d);
    
    return d;
}


#pragma mark - CBperipheral delegate functions

-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    BOOL replace = NO;
    BOOL found = NO;
    NSLog(@"Services scanned !");
    //[self.m cancelPeripheralConnection:peripheral];
    for (CBService *s in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:s];
        if ([s.UUID isEqual:[CBUUID UUIDWithString:@"F000AA00-0451-4000-B000-000000000000"]])  {
            NSLog(@"Found SensorTag !");
            found = YES;
        }
    }
    if (found) {
        // Match if we have this device from before
        for (int ii=0; ii < self.sensorTags.count; ii++) {
            CBPeripheral *p = [self.sensorTags objectAtIndex:ii];
            if ([p isEqual:peripheral]) {
                //[self.sensorTags replaceObjectAtIndex:ii withObject:peripheral];
                if(![p isConnected]) {
                    [self.sensorTags replaceObjectAtIndex:ii withObject:peripheral];
                    replace = NO;
                    found = NO;
                }
                else
                    replace = YES;
            }
        }
        if (!replace) {
            if(found)
                [self.sensorTags addObject:peripheral];
            if(!self.device) {
                
//                device = [[BLEDevice alloc]init];
//                
//                device.p = peripheral;
//                device.manager = self.m;
//                device.setupData = [self makeSensorTagConfiguration];
//                if (!self.device.p.isConnected) {
//                    self.device.manager.delegate = self;
//                    [self.device.manager connectPeripheral:self.device.p options:nil];
//                }
//                else {
//                    NSLog(@"Connected");
//                    self.device.p.delegate = self;
//                    [self configureSensorTag];
//                }
                
                self.device = [[BLEDevice alloc]init];

                self.device.p = peripheral;
                self.device.p.delegate = self;
                self.device.manager = self.m;
                self.device.setupData = [self makeSensorTagConfiguration];
                //[self configureSensorTag];
                [self.magSensor calibrate];
                [self calibrateGyro];

                [self.device.manager stopScan];
                //NSLog(@"%lu %lu", (unsigned long)self.nDevices.count, (unsigned long)self.sensorTags.count);
            }
        }
    }
}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error_
{
    self.currentVal.RSSI = fabs(self.device.p.RSSI.doubleValue);
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    if ([service.UUID isEqual:[CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Accelerometer service UUID"]]]) {
        //NSLog(@"found gyro service");
        [self configureSensorTag];
        self.isConnected = true;
        self.rssiTimer = [NSTimer timerWithTimeInterval:0.3f target:self selector:@selector(rssiTimer:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.rssiTimer forMode:NSRunLoopCommonModes];
        self.logTimer = [NSTimer scheduledTimerWithTimeInterval:self.logInterval target:self selector:@selector(logValues:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.logTimer forMode:NSRunLoopCommonModes];
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //sNSLog(@"didUpdateNotificationStateForCharacteristic %@ error = %@",characteristic,error);
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    //NSLog(@"didUpdateValueForCharacteristic = %@",characteristic.UUID);
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.device.setupData valueForKey:@"IR temperature data UUID"]]]) {
        self.currentVal.tAmb = [sensorTMP006 calcTAmb:characteristic.value];
        self.currentVal.tIR = [sensorTMP006 calcTObj:characteristic.value];
    }
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Accelerometer data UUID"]]]) {
        self.currentVal.accX = [sensorKXTJ9 calcXValue:characteristic.value];
        self.currentVal.accY = [sensorKXTJ9 calcYValue:characteristic.value];
        self.currentVal.accZ = [sensorKXTJ9 calcZValue:characteristic.value];
        
       // NSLog(@"acce: %f %f %f", self.currentVal.accX,self.currentVal.accY,self.currentVal.accZ);
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Humidity data UUID"]]]) {
        self.currentVal.humidity = [sensorSHT21 calcPress:characteristic.value];
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Magnetometer data UUID"]]]) {
        self.currentVal.magX = [self.magSensor calcXValue:characteristic.value];
        self.currentVal.magY = [self.magSensor calcYValue:characteristic.value];
        self.currentVal.magZ = [self.magSensor calcZValue:characteristic.value];
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer calibration UUID"]]]) {
    
        self.baroSensor = [[sensorC953A alloc] initWithCalibrationData:characteristic.value];
        
        CBUUID *sUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer service UUID"]];
        CBUUID *cUUID = [CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer config UUID"]];
        //Issue normal operation to the device
        uint8_t data = 0x01;
        [BLEUtility writeCharacteristic:self.device.p sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
        
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Barometer data UUID"]]]) {
        self.currentVal.press =  [self.baroSensor calcPressure:characteristic.value];
    }
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:[self.device.setupData valueForKey:@"Gyroscope data UUID"]]]) {
        self.currentVal.gyroX = [self.gyroSensor calcXValue:characteristic.value];
        self.currentVal.gyroY = [self.gyroSensor calcYValue:characteristic.value];
        self.currentVal.gyroZ = [self.gyroSensor calcZValue:characteristic.value];
        
        //NSLog(@"gyro: %f %f %f %f", self.currentVal.gyroX,self.currentVal.gyroY,self.currentVal.gyroZ, [sensorKXTJ9 calcZValue:characteristic.value]);
        
    }
}

- (void) calibrateMag {
    [self.magSensor calibrate];
}
- (void) calibrateGyro {
    [self.gyroSensor calibrate];
}

- (void)rssiTimer:(NSTimer *)timer_
{
    [self.device.p readRSSI];
}

-(void) logValues:(NSTimer *)timer {
    NSString *date = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                    dateStyle:NSDateFormatterShortStyle
                                                    timeStyle:NSDateFormatterMediumStyle];
    self.currentVal.timeStamp = date;
    sensorTagValues *newVal = [[sensorTagValues alloc]init];
    newVal.tAmb = self.currentVal.tAmb;
    newVal.tIR = self.currentVal.tIR;
    newVal.accX = self.currentVal.accX;
    newVal.accY = self.currentVal.accY;
    newVal.accZ = self.currentVal.accZ;
    newVal.gyroX = self.currentVal.gyroX;
    newVal.gyroY = self.currentVal.gyroY;
    newVal.gyroZ = self.currentVal.gyroZ;
    newVal.magX = self.currentVal.magX;
    newVal.magY = self.currentVal.magY;
    newVal.magZ = self.currentVal.magZ;
    newVal.press = self.currentVal.press;
    newVal.humidity = self.currentVal.humidity;
    newVal.timeStamp = date;
    
    [self.vals addObject:newVal];
    
}

@end
