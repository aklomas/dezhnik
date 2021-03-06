//
//  PageFOURViewController.m
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "PageTHREEViewController.h"

@interface PageTHREEViewController ()

@end

@implementation PageTHREEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!self.sensorTable)
        self.sensorTable = [[SensorTableView alloc] init];
    self.sensorTable.sensorTag = self.sensorTag;
    [self addChildViewController:self.sensorTable];
    self.sensorTable.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 150.0f);
    //[self.graphsContainer addSubview:self.sensorTable.view];
    [self.sensorTable didMoveToParentViewController:self];
    
    [self.timesReconnected setNr:0];
    [self.timesOpened setNr:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pauseTimer {
    [self.uiTimer invalidate];
    [self.graphTimer invalidate];
    self.humidityGraph.interval = 30.0f;
    self.pressureGraph.interval = 30.0f;
    self.temperatureGraph.interval = 30.0f;
    self.graphTimer = [NSTimer timerWithTimeInterval:30.0f target:self selector:@selector(updateGraphs:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.graphTimer forMode:NSRunLoopCommonModes];
}

-(void)resumeTimer {
    self.humidityGraph.interval = 1.0f;
    self.pressureGraph.interval = 1.0f;
    self.temperatureGraph.interval = 1.0f;
    if (self.graphTimer)
        [self.graphTimer invalidate];
    self.uiTimer = [NSTimer timerWithTimeInterval:0.03f target:self selector:@selector(updateView:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.uiTimer forMode:NSRunLoopCommonModes];
    self.graphTimer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateGraphs:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.graphTimer forMode:NSRunLoopCommonModes];
}

-(void)updateGraphs:(NSTimer *)timer {
    if (self.sensorTag.isConnected) {
        if (self.humidityGraph.interval < 0.1 || self.pressureGraph.interval < 0.1 || self.temperatureGraph.interval < 0.1) {
            self.humidityGraph.interval = 1.0f;
            self.pressureGraph.interval = 1.0f;
            self.temperatureGraph.interval = 1.0f;
        }
        self.humidityGraph.range = 100.0;
        self.humidityGraph.mid_value = 50.0;
        self.humidityGraph.unit = @"%";
        [self.humidityGraph addEntry: [NSNumber numberWithFloat:self.sensorTag.currentVal.humidity]];
        
        self.pressureGraph.range = 100.0;
        self.pressureGraph.mid_value = 1000.0;
        self.pressureGraph.unit = @"";
        [self.pressureGraph addEntry: [NSNumber numberWithFloat:self.sensorTag.currentVal.press]];
        
        self.temperatureGraph.range = 70.0;
        self.temperatureGraph.mid_value = 20.0;
        self.temperatureGraph.unit = @"°C";
        [self.temperatureGraph addEntry: [NSNumber numberWithFloat:self.sensorTag.currentVal.tAmb]];
    }
}

-(void)updateView:(NSTimer *)timer {
    if (self.sensorTag.isConnected) {
        self.signal.connected = 1;
        [self.signal updateRSSI:self.sensorTag.currentVal.RSSI];
        
        if (self.timesOpened.number < 158)
            [self.timesOpened setNr:self.timesOpened.number+3];
        if (self.timesReconnected.number < 2)
            [self.timesReconnected setNr:self.timesReconnected.number+1];

        if(self.hTemp != self.sensorTag.currentVal.humidity)
            self.hTemp = [self.strHum floatValue];
        self.strHum = [NSString stringWithFormat:@"%f", [self.strHum floatValue] + (self.sensorTag.currentVal.humidity - self.hTemp)/33];
        self.humidityLabel.text = [NSString stringWithFormat:@"%d%%",(int)[self.strHum floatValue]];
        self.humidity.image = [UIImage imageNamed:[NSString stringWithFormat:@"humidity0%d", (int)([self.strHum floatValue]/10)]];
        
        if(self.pTemp != self.sensorTag.currentVal.press)
            self.pTemp = [self.strPres floatValue];
        self.strPres = [NSString stringWithFormat:@"%f", [self.strPres floatValue] + (self.sensorTag.currentVal.press - self.pTemp)/33];
        self.pressureLabel.text = [NSString stringWithFormat:@"%d mBar",(int)[self.strPres floatValue]];
        self.pressure.image = [UIImage imageNamed:
                                               [self.strPres floatValue] < 950.0 ?
                                               @"pressure00" : [self.strPres floatValue] > 1050 ?
                                               @"pressure09" :
                                               [NSString stringWithFormat:@"pressure0%d", (int)(([self.strPres floatValue] - 950) / 10)]];

        if(self.tTemp != self.sensorTag.currentVal.tAmb)
            self.tTemp = [self.strTemp floatValue];
        self.strTemp = [NSString stringWithFormat:@"%f", [self.strTemp floatValue] + (self.sensorTag.currentVal.tAmb - self.tTemp)/33];
        self.temperatureLabel.text = [NSString stringWithFormat:@"%d°C",(int)[self.strTemp floatValue]];
        self.temperature.image = [UIImage imageNamed:
                                        [self.strTemp floatValue] < -10.0 ?
                                        @"temperature00" : [self.strTemp floatValue] > 30 ?
                                        @"temperature09" :
                                        [NSString stringWithFormat:@"temperature0%d", (int)(([self.strTemp floatValue] + 15) / 5)]];
    }
    else {
        [self.signal setDisconnected];
    }
}

- (IBAction)showPressureGraph:(id)sender {
    if (self.pressureGraph.data) {
        self.sensorsView.alpha = 0.0;
        self.pressureGraph.alpha = 1.0;
        [self.pressureGraph setNeedsDisplay];
        self.activeView = 1;
        self.pressureGesture.alpha = 0.0;
        self.humidityGesture.alpha = 0.0;
        self.temperatureGesture.alpha = 0.0;
        self.backGesture.alpha = 1.0;
    }
}

- (IBAction)showHumidityGraph:(id)sender {
    if (self.humidityGraph.data) {
        self.sensorsView.alpha = 0.0;
        self.humidityGraph.alpha = 1.0;
        [self.humidityGraph setNeedsDisplay];
        self.activeView = 2;
        self.pressureGesture.alpha = 0.0;
        self.humidityGesture.alpha = 0.0;
        self.temperatureGesture.alpha = 0.0;
        self.backGesture.alpha = 1.0;
    }
}

- (IBAction)showTemperatureGraph:(id)sender {
    if (self.temperatureGraph.data) {
        self.sensorsView.alpha = 0.0;
        self.temperatureGraph.alpha = 1.0;
        [self.temperatureGraph setNeedsDisplay];
        self.activeView = 3;
        self.pressureGesture.alpha = 0.0;
        self.humidityGesture.alpha = 0.0;
        self.temperatureGesture.alpha = 0.0;
        self.backGesture.alpha = 1.0;
    }
}

- (IBAction)showSensors:(id)sender {
    if (self.activeView == 1) {
        self.pressureGraph.alpha = 0.0;
        self.sensorsView.alpha = 1.0;
        self.activeView = 0;
    }
    else if (self.activeView == 2) {
        self.humidityGraph.alpha = 0.0;
        self.sensorsView.alpha = 1.0;
        self.activeView = 0;
    }
    
    else if (self.activeView == 3) {
        self.temperatureGraph.alpha = 0.0;
        self.sensorsView.alpha = 1.0;
        self.activeView = 0;
    }
    
    self.pressureGesture.alpha = 1.0;
    self.humidityGesture.alpha = 1.0;
    self.temperatureGesture.alpha = 1.0;
    self.backGesture.alpha = 0.0;
}

- (IBAction)openedGesture:(UITapGestureRecognizer *)sender {
    [self.timesOpened setNr:self.timesOpened.number+1];
}

- (IBAction)forgotGesture:(UITapGestureRecognizer *)sender {
    [self.timesReconnected setNr:self.timesReconnected.number+1];
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
