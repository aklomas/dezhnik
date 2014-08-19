//
//  SensorTag.h
//  Myrella
//
//  Created by Filip Kralj on 18/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEDevice.h"
#import "BLEUtility.h"
#import "deviceCellTemplate.h"
#import "Sensors.h"

#define MIN_ALPHA_FADE 0.2f
#define ALPHA_FADE_STEP 0.05f


@interface SensorTag : NSObject <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong,nonatomic) BLEDevice *device;
@property NSMutableArray *sensorsEnabled;

@property (strong,nonatomic) sensorMAG3110 *magSensor;
@property (strong,nonatomic) sensorC953A *baroSensor;
@property (strong,nonatomic) sensorIMU3000 *gyroSensor;


@property (strong,nonatomic) sensorTagValues *currentVal;
@property (strong,nonatomic) NSMutableArray *vals;
@property (strong,nonatomic) NSTimer *logTimer;

@property float logInterval;

@property (strong,nonatomic) CBCentralManager *m;
@property (strong,nonatomic) NSMutableArray *nDevices;
@property (strong,nonatomic) NSMutableArray *sensorTags;


-(NSMutableDictionary *) makeSensorTagConfiguration;

-(id) init;
-(void) deinit;

-(void) configureSensorTag;
-(void) deconfigureSensorTag;

- (void) calibrateMag;
- (void) calibrateGyro;

-(void) logValues:(NSTimer *)timer;

@end
