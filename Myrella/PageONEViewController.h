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

@interface PageONEViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *settingsSVGweb;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;

@property (weak, nonatomic) IBOutlet UILabel *ForecastTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *SensorTempLabel;
@property (weak, nonatomic) IBOutlet ScreenONETempCircle *TempCircle;
@property (weak, nonatomic) IBOutlet UIView *TempContainer;
@property (weak, nonatomic) IBOutlet UIView *TempContainerExtended;
@property (weak, nonatomic) IBOutlet UIImageView *LeftImageExtended;
@property (weak, nonatomic) IBOutlet UIImageView *CenterImageExtended;
@property (weak, nonatomic) IBOutlet UILabel *Plus4Label;
@property (weak, nonatomic) IBOutlet UIImageView *RightImageExtended;
@property (weak, nonatomic) IBOutlet UILabel *Plus8Label;
@property (weak, nonatomic) IBOutlet UILabel *DailyHigh;
@property (weak, nonatomic) IBOutlet UILabel *DailyLow;
@property (weak, nonatomic) IBOutlet UILabel *DailyMessage;

@property (weak, nonatomic) IBOutlet ScreenONEGraph *GraphView;

@property (weak, nonatomic) IBOutlet UILabel *SummaryLabel;

@property (strong,nonatomic) SensorTag *sensorTag;
@property (strong,nonatomic) ForecastKit *forecastKit;

-(void)updateView:(NSTimer *)timer;
- (IBAction)temperatureTap:(UITapGestureRecognizer *)sender;

@end
