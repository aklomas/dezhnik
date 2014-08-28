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

@interface PageONEViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *settingsSVGweb;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ForecastTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *SensorTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *SummaryLabel;
@property (strong,nonatomic) SensorTag *sensorTag;
@property (strong,nonatomic) ForecastKit *forecastKit;

-(void)updateView:(NSTimer *)timer;

@end
