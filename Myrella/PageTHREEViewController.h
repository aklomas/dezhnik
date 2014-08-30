//
//  PageFOURViewController.h
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForecastKit.h"
#import "SensorTag.h"
#import "SensorTableView.h"
#import "ScreenTHREESignal.h"
#import "ScreenTHREEDottedCircle.h"

@interface PageTHREEViewController : UIViewController

@property (strong,nonatomic) SensorTag *sensorTag;
@property (strong,nonatomic) ForecastKit *forecastKit;
@property (strong,nonatomic) SensorTableView *sensorTable;


@property (weak, nonatomic) IBOutlet ScreenTHREESignal *signal;
@property (weak, nonatomic) IBOutlet ScreenTHREEDottedCircle * timesReconnected;
@property (weak, nonatomic) IBOutlet ScreenTHREEDottedCircle *timesOpened;
@property (strong,nonatomic) IBOutlet UIScrollView *graphsContainer;


-(void)updateView:(NSTimer *)timer;

@end
