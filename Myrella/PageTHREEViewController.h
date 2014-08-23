//
//  PageFOURViewController.h
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SensorTag.h"
#import "SensorTableView.h"

@interface PageTHREEViewController : UIViewController

@property (strong,nonatomic) SensorTableView *sensorTable;
@property (strong,nonatomic) IBOutlet UIView *sensorTableContainer;
@property (strong,nonatomic) SensorTag *sensorTag;

//- (void) setTag:(SensorTag *)sensorTag;

@end
