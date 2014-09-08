//
//  ViewController.h
//  Myrella
//
//  Created by Filip Kralj on 06/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGKit.h"
#import "PageONEViewController.h"
#import "PageTWOViewController.h"
#import "PageTHREEViewController.h"

@interface BaseViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) SensorTag *sensorTag;
@property (strong,nonatomic) ForecastKit *forecastKit;
@property NSMutableArray *views;

@property (weak, nonatomic) IBOutlet UIImageView *connectionImage;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

-(void) update;


@end
