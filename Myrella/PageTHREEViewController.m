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
    self.sensorTable.view.frame = self.sensorTableContainer.frame;
    [self.view addSubview:self.sensorTable.view];
    [self.sensorTable didMoveToParentViewController:self];
    
    self.sensorTable.view.frame = self.view.frame;

    //self.sensorTable = [self.childViewControllers objectAtIndex:0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void) setTag:(SensorTag *)sensorTag {
    if(!self.sensorTable)
        self.sensorTable = [[SensorTableView alloc] init];
    self.sensorTag = sensorTag;
    self.sensorTable.sensorTag = sensorTag;
}*/

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
