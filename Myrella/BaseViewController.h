//
//  BaseViewController.h
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
#import "SettingsViewController.h"

@interface BaseViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) SensorTag *sensorTag;
@property (strong,nonatomic) ForecastKit *forecastKit;
@property NSMutableArray *views;


@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@property NSTimer* notificationTimer;
@property BOOL wasConnected;

@property BOOL weatherAlertOn;
@property BOOL healthAlertOn;
@property BOOL notifShown;

@property UIAlertView *severeWeatherAlert;
@property UIAlertView *healthHazardAlert;

-(void) didBecomeActive;
-(void) willEnterBackground;

-(void)didFinishAnimating:(BOOL)finished;

-(void)notifUpdate:(NSTimer*)timer;


@end
