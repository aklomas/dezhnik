//
//  PageTHREEViewController.h
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorTag.h"
#import <MessageUI/MessageUI.h>
#import "deviceCellTemplate.h"

#define MIN_ALPHA_FADE 0.2f
#define ALPHA_FADE_STEP 0.05f


@interface SensorTableView : UITableViewController

@property (strong,nonatomic) SensorTag *sensorTag;

/// Temperature cell
@property (strong,nonatomic) temperatureCellTemplate *ambientTemp;
@property (strong,nonatomic) temperatureCellTemplate *irTemp;
@property (strong,nonatomic) accelerometerCellTemplate *acc;
@property (strong,nonatomic) temperatureCellTemplate *rH;
@property (strong,nonatomic) accelerometerCellTemplate *mag;
@property (strong,nonatomic) temperatureCellTemplate *baro;
@property (strong,nonatomic) accelerometerCellTemplate *gyro;


- (IBAction) handleCalibrateMag;
- (IBAction) handleCalibrateGyro;

-(void) deinit;
-(void) updateView:(NSTimer *)timer;

@end