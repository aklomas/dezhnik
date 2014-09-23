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
    self.changedBg = false;    
    self.showSevereWeatherAlert = false;
    self.showHealthHazardAlert = false;

    //[self resumeTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateView:(NSTimer *)timer {
    if (!self.changedBg) {
        self.parentViewController.parentViewController.view.backgroundColor = [UIColor colorWithRed:98/255.0 green:139/255.0 blue:173/255.0 alpha:1];
        self.changedBg = true;
    }
    
    if(self.forecastKit.changed && self.forecastKit.forecastDict){
        self.pageTitle = self.forecastKit.curLocName;
        self.ForecastTempLabel.text = [NSString stringWithFormat:@"%d",(int)([self.forecastKit.getCurTemperature floatValue] + 0.5)];
        self.SummaryLabel.text = self.forecastKit.getCurSummary;
        self.LeftImageExtended.image = [UIImage imageNamed:[self.forecastKit getCurIcon]];
        self.CenterImageExtended.image = [UIImage imageNamed:[self.forecastKit getIconForNextHour:4]];
        self.RightImageExtended.image = [UIImage imageNamed:[self.forecastKit getIconForNextHour:8]];
        
        self.DailyHigh.text = [NSString stringWithFormat:@"%d",(int)([self.forecastKit.getDailyMaxTemperature floatValue] + 0.5)];
        self.DailyLow.text = [NSString stringWithFormat:@"%d",(int)([self.forecastKit.getDailyMinTemperature floatValue] + 0.5)];
        //self.DailyMessage.text = self.forecastKit.getDailyMessage;
        
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"nameChanged" object:nil];
        self.forecastKit.changed = false;
    }
    
    NSString *str = [NSString stringWithFormat:@" Myrella: %@", self.sensorTag.isConnected ? [NSString stringWithFormat:@"%.1f°C",self.sensorTag.currentVal.tAmb] : @"N/A"];
    if (![self.SensorTempLabel.text isEqualToString:str])
        self.SensorTempLabel.text = str;
    
    if(self.sensorTag.isConnected){
        self.connectionImage.image = [UIImage imageNamed:@"connected"];
        
        float hum = (self.sensorTag.currentVal.humidity - 55.0)/30.0;
        if(hum < 0)
            hum = 0;
        if (hum > 1)
            hum = 1;
        float a = fabsf(self.curHum - hum);
        if (a > 0.02) {
            if (hum < self.curHum)
                self.curHum -= 0.01;
            else if (hum > self.curHum)
                self.curHum += 0.01;
            ///////////////////////
            ///////BARVA
            ///////////////////////
            int lowColor[] = {98, 139, 173};
            int highColor[] = {74, 121, 169};
            self.parentViewController.parentViewController.view.backgroundColor = [UIColor colorWithRed:lowColor[0]/255.0 + (highColor[0]-lowColor[0])/255.0 * self.curHum green:lowColor[1]/255.0 + (highColor[1]-lowColor[1])/255.0 * self.curHum
                blue:lowColor[2]/255.0 + (highColor[2]-lowColor[2])/255.0 * self.curHum
                alpha:1];
        }
    }
    else
        self.connectionImage.image = [UIImage imageNamed:@"disconnected"];
    
    if(self.TempCircle && self.TempCircle.extend != 0){
        [self.TempCircle update];
        if(self.TempCircle.extend == 0 && self.TempCircle.extended == 1.0) {
            self.TempContainer.alpha = 0.0;
            self.TempContainerExtended.alpha = 1.0;
            if (self.forecastKit.forecastDict)
                self.SummaryLabel.text = self.forecastKit.getDailyMessage;
            
        }
        else if(self.TempCircle.extend == 0 && self.TempCircle.extended == 0.0){
            self.TempContainer.alpha = 1.0;
            self.TempContainerExtended.alpha = 0.0;
            if (self.forecastKit.forecastDict)
                self.SummaryLabel.text = self.forecastKit.getCurSummary;
        }
        else
            self.TempContainerExtended.alpha = 0.0;
    }
}

-(void) pauseTimer {
    [self.uiTimer invalidate];
}

-(void) resumeTimer {
    self.uiTimer = [NSTimer timerWithTimeInterval:0.03f target:self selector:@selector(updateView:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.uiTimer forMode:NSRunLoopCommonModes];
}

- (IBAction)temperatureTap:(UITapGestureRecognizer *)sender {
    if(self.TempContainer.alpha == 1.0) {
        self.TempCircle.extend = 1;
        [UIView animateWithDuration:0.4 animations:^{
            self.SensorTempLabel.frame = CGRectMake(self.SensorTempLabel.frame.origin.x, self.SensorTempLabel.frame.origin.y + 10, self.SensorTempLabel.frame.size.width, self.SensorTempLabel.frame.size.height);
        }];
        [UIView animateWithDuration:0.4 animations:^{
            self.healthWarning.frame = CGRectMake(0,4,40,40);
        }];
        [UIView animateWithDuration:0.4 animations:^{
            self.weatherWarning.frame = CGRectMake(280,4,40,40);
        }];
        
    }
    else if(self.TempContainer.alpha == 0.0){
        self.TempCircle.extend = -1;
        [UIView animateWithDuration:0.4 animations:^{
            self.SensorTempLabel.frame = CGRectMake(self.SensorTempLabel.frame.origin.x, self.SensorTempLabel.frame.origin.y - 10, self.SensorTempLabel.frame.size.width, self.SensorTempLabel.frame.size.height);
        }];
        [UIView animateWithDuration:0.4 animations:^{
            self.healthWarning.frame = CGRectMake(0,4,60,60);
        }];
        [UIView animateWithDuration:0.4 animations:^{
            self.weatherWarning.frame = CGRectMake(260,4,60,60);
        }];
        
    }
}

- (IBAction)alarmTap:(UITapGestureRecognizer *)sender {
    self.showSevereWeatherAlert = true;
}

- (IBAction)healthTap:(UITapGestureRecognizer *)sender {
    self.showHealthHazardAlert  = true;
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
