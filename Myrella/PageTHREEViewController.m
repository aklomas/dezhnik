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
    [self.graphsContainer addSubview:self.sensorTable.view];
    [self.sensorTable didMoveToParentViewController:self];
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:0.03f target:self selector:@selector(updateView:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    [self.timesReconnected setNr:38];
    [self.timesOpened setNr:157];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateView:(NSTimer *)timer {
    if (self.sensorTag.isConnected) {
        self.signal.connected = 1;
        [self.signal updateRSSI:self.sensorTag.currentVal.RSSI];
    }
    else {
        [self.signal setDisconnected];
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
