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
#import "GraphView.h"

@interface PageTHREEViewController : UIViewController

@property (strong,nonatomic) SensorTag *sensorTag;
@property (strong,nonatomic) ForecastKit *forecastKit;
@property (strong,nonatomic) SensorTableView *sensorTable;


@property (weak, nonatomic) IBOutlet ScreenTHREESignal *signal;
@property (weak, nonatomic) IBOutlet ScreenTHREEDottedCircle * timesReconnected;
@property (weak, nonatomic) IBOutlet ScreenTHREEDottedCircle *timesOpened;

@property (weak, nonatomic) IBOutlet UIView *sensorsView;
@property (weak, nonatomic) IBOutlet GraphView *pressureGraph;
@property (weak, nonatomic) IBOutlet GraphView *humidityGraph;
@property (weak, nonatomic) IBOutlet GraphView *temperatureGraph;

@property (weak, nonatomic) IBOutlet UIImageView *pressure;
@property (weak, nonatomic) IBOutlet UIImageView *humidity;
@property (weak, nonatomic) IBOutlet UIImageView *temperature;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property float hTemp;
@property NSString* strHum;

@property float pTemp;
@property NSString* strPres;

@property float tTemp;
@property NSString* strTemp;

@property int activeView;
@property (weak, nonatomic) IBOutlet UIView *pressureGesture;
@property (weak, nonatomic) IBOutlet UIView *humidityGesture;
@property (weak, nonatomic) IBOutlet UIView *temperatureGesture;
@property (weak, nonatomic) IBOutlet UIView *backGesture;

@property NSTimer *uiTimer;
@property NSTimer *graphTimer;

-(void)pauseTimer;
-(void)resumeTimer;

-(void)updateView:(NSTimer *)timer;
-(void)updateGraphs:(NSTimer *)timer;
- (IBAction)showPressureGraph:(id)sender;
- (IBAction)showHumidityGraph:(id)sender;
- (IBAction)showTemperatureGraph:(id)sender;
- (IBAction)showSensors:(id)sender;


@end
