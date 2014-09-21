//
//  PageONEViewController.h
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SensorTag.h"
#import "ForecastKit.h"
#import "ScreenONETempCircle.h"
#import "ScreenONEGraph.h"

@interface PageONEViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *ForecastTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *SensorTempLabel;
@property (weak, nonatomic) IBOutlet ScreenONETempCircle *TempCircle;
@property (weak, nonatomic) IBOutlet UIView *TempContainer;
@property (weak, nonatomic) IBOutlet UIView *TempContainerExtended;
@property (weak, nonatomic) IBOutlet UIImageView *LeftImageExtended;
@property (weak, nonatomic) IBOutlet UIImageView *CenterImageExtended;
@property (weak, nonatomic) UIImageView *connectionImage;
@property (weak, nonatomic) IBOutlet UILabel *Plus4Label;
@property (weak, nonatomic) IBOutlet UIImageView *RightImageExtended;
@property (weak, nonatomic) IBOutlet UILabel *Plus8Label;
@property (weak, nonatomic) IBOutlet UILabel *DailyHigh;
@property (weak, nonatomic) IBOutlet UILabel *DailyLow;
@property (weak, nonatomic) IBOutlet UILabel *DailyMessage;

@property (weak, nonatomic) IBOutlet ScreenONEGraph *GraphView;
@property (weak, nonatomic) IBOutlet UILabel *SummaryLabel;

@property (weak, nonatomic) IBOutlet UIView *AlarmGestureView;
@property (weak, nonatomic) IBOutlet UIImageView *AlarmView;
@property (weak, nonatomic) IBOutlet UIImageView *HealthAlarmView;
@property (weak, nonatomic) IBOutlet UIView *HealthAlarmGestureView;
@property (weak, nonatomic) IBOutlet UIImageView *weatherWarning;
@property (weak, nonatomic) IBOutlet UIImageView *healthWarning;

@property (strong,nonatomic) SensorTag *sensorTag;
@property (strong,nonatomic) ForecastKit *forecastKit;

@property (strong,nonatomic) NSString *pageTitle;
@property NSTimer* uiTimer;

@property float curHum;
@property BOOL changedBg;
@property BOOL showSevereWeatherAlert;
@property BOOL showHealthHazardAlert;


- (IBAction)temperatureTap:(UITapGestureRecognizer *)sender;

- (IBAction)alarmTap:(UITapGestureRecognizer *)sender;
- (IBAction)healthTap:(UITapGestureRecognizer *)sender;

-(void)updateView:(NSTimer *)timer;

-(void)pauseTimer;
-(void)resumeTimer;

@end
