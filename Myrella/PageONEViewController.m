//
//  PageONEViewController.m
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "PageONEViewController.h"

@interface PageONEViewController ()

@end

@implementation PageONEViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:0.03f target:self selector:@selector(updateView:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateView:(NSTimer *)timer {
    if(self.forecastKit.changed && self.forecastKit.forecastDict){
        self.pageTitle = self.forecastKit.curLocName;
        self.ForecastTempLabel.text = [NSString stringWithFormat:@"%d",(int)([self.forecastKit.getCurTemperature floatValue] + 0.5)];
        self.SummaryLabel.text = self.forecastKit.getCurSummary;
        self.LeftImageExtended.image = [UIImage imageNamed:[self.forecastKit getCurIcon]];
        NSLog(@"%@",[self.forecastKit getCurIcon]);
        self.CenterImageExtended.image = [UIImage imageNamed:[self.forecastKit getIconForNextHour:4]];
        self.RightImageExtended.image = [UIImage imageNamed:[self.forecastKit getIconForNextHour:8]];
        
        self.DailyHigh.text = [NSString stringWithFormat:@"%d",(int)([self.forecastKit.getDailyMaxTemperature floatValue] + 0.5)];
        self.DailyLow.text = [NSString stringWithFormat:@"%d",(int)([self.forecastKit.getDailyMinTemperature floatValue] + 0.5)];
        self.DailyMessage.text = self.forecastKit.getDailyMessage;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH"];
        int curTime = [[formatter stringFromDate:[NSDate date]] intValue];
        self.Plus4Label.text = curTime+4 < 12 ? [NSString stringWithFormat:@"%dam",curTime+4] :
                               curTime+4 == 12 ? [NSString stringWithFormat:@"%dpm",curTime+4] :
                               curTime+4 < 24 ? [NSString stringWithFormat:@"%dpm",curTime-12+4] :
                                                [NSString stringWithFormat:@"%dam",curTime-24+4];
        
        self.Plus8Label.text = curTime+8 < 12 ? [NSString stringWithFormat:@"%dam",curTime+8] :
                               curTime+8 == 12 ? [NSString stringWithFormat:@"%dpm",curTime+8] :
                               curTime+8 < 24 ? [NSString stringWithFormat:@"%dpm",curTime-12+8] :
                                                [NSString stringWithFormat:@"%dam",curTime-24+8];
        
        NSMutableArray *data = [[NSMutableArray alloc] init];
        [data addObject:self.forecastKit.getCurTemperature];
        for (int i = 1 ; i < 12 ; i++)
            [data addObject:[self.forecastKit getTempForNextHour:i]];
        self.GraphView.tempData = data;
        [self.GraphView update];
        
        data = [[NSMutableArray alloc] init];
        [data addObject:self.forecastKit.getCurPercipIntensity];
        for (int i = 1 ; i < 12 ; i++)
            [data addObject:[self.forecastKit getPercipIntensityForNextHour:i]];
        self.GraphView.percipData = data;
        [self.GraphView update];
        
        self.forecastKit.changed = false;
    }
    
    NSString *str = [NSString stringWithFormat:@" Myrella: %@", self.sensorTag.isConnected ? [NSString stringWithFormat:@"%.1f°C",self.sensorTag.currentVal.tAmb] : @"N/A"];
    if (![self.SensorTempLabel.text isEqualToString:str])
        self.SensorTempLabel.text = str;
    
    if(self.sensorTag.isConnected){
        self.connectionImage.image = [UIImage imageNamed:@"connected"];
    }
    else
        self.connectionImage.image = [UIImage imageNamed:@"disconnected"];
    
    if(self.TempCircle && self.TempCircle.extend != 0){
        [self.TempCircle update];
        if(self.TempCircle.extend == 0 && self.TempCircle.extended == 1.0) {
            self.TempContainer.alpha = 0.0;
            self.TempContainerExtended.alpha = 1.0;
        }
        else if(self.TempCircle.extend == 0 && self.TempCircle.extended == 0.0){
            self.TempContainer.alpha = 1.0;
            self.TempContainerExtended.alpha = 0.0;
        }
        else
            self.TempContainerExtended.alpha = 0.0;
    }
}

- (IBAction)temperatureTap:(UITapGestureRecognizer *)sender {
    if(self.TempContainer.alpha == 1.0) {
        self.TempCircle.extend = 1;
    }
    else {
        self.TempCircle.extend = -1;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
