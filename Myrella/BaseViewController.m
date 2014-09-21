//
//  BaseViewController.m
//  Myrella
//
//  Created by Filip Kralj on 06/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "BaseViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ForecastKit.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.sensorTag = [[SensorTag alloc] init];
    self.forecastKit = [[ForecastKit alloc] initWithAPIKey:@"c2187ef6c54f0f5eebaeb77582873b0d"];
    
    self.views = [[NSMutableArray alloc] initWithCapacity:3];
    [self.views addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageONE"]];
    [self.views addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageTWO"]];
    [self.views addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"PageTHREE"]];
    
    ((PageONEViewController *)[self.views objectAtIndex:0]).forecastKit = self.forecastKit;
    ((PageTHREEViewController *)[self.views objectAtIndex:2]).forecastKit = self.forecastKit;
    ((PageONEViewController *)[self.views objectAtIndex:0]).sensorTag = self.sensorTag;
    ((PageTHREEViewController *)[self.views objectAtIndex:2]).sensorTag = self.sensorTag;
    
    ((PageONEViewController *)[self.views objectAtIndex:0]).connectionImage = self.connectionImage;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 54);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageControl.numberOfPages = [self.views count];
    self.pageControl.currentPage = 0;
    
    UISwipeGestureRecognizer * Swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight:)];
    Swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.swipeView addGestureRecognizer:Swiperight];
    
    UISwipeGestureRecognizer * Swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft:)];
    Swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.swipeView addGestureRecognizer:Swipeleft];
    
    [GMSServices provideAPIKey:@"AIzaSyAUyP1Z4_o-PglTitSntW5Cj1RhvillPOs"];
    
    self.wasConnected = false;    
    self.severeWeatherAlert = [[UIAlertView alloc] initWithTitle:@"Extreme weather warning!"
                                            message:@""
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
    
    self.healthHazardAlert = [[UIAlertView alloc] initWithTitle:@"Health hazard warning!"
                                                         message:@""
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(handleHealthNotification:) name:@"healthChanged" object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(handleWeatherNotification:) name:@"weatherChanged" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    //[[self.views objectAtIndex:2] deinit];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willEnterBackground {
    [self.sensorTag slowTimers];
    [((PageONEViewController *)[self.views objectAtIndex:0]) pauseTimer];
    [((PageTHREEViewController *)[self.views objectAtIndex:2]) pauseTimer];
    [self.notificationTimer invalidate];
    self.notificationTimer= [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(notifUpdate:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.notificationTimer forMode:NSRunLoopCommonModes];
}


-(void)didBecomeActive {
    if (self.sensorTag.isConnected)
        [self.sensorTag normalTimers];
    
    [((PageONEViewController *)[self.views objectAtIndex:0]) resumeTimer];
    [((PageTHREEViewController *)[self.views objectAtIndex:2]) resumeTimer];
    [self.forecastKit update];
    
    self.notificationTimer= [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(notifUpdate:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.notificationTimer forMode:NSRunLoopCommonModes];
}

-(void)handleHealthNotification:(NSNotification *)notification
{
    if (!self.healthAlertOn) {
        ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmView.alpha = 1.0;
        ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmGestureView.alpha = 1.0;
        self.healthHazardAlert.message = @"The temperature is very high, there is an increased chance of dehydration. Keep away from the sun and drink a lot of water.";
        self.healthAlertOn = true;
    }
    else {
        ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmView.alpha = 0.0;
        ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmGestureView.alpha = 0.0;
        self.healthAlertOn = false;
    }
}

-(void)handleWeatherNotification:(NSNotification *)notification
{
    if (!self.weatherAlertOn) {
        ((PageONEViewController *)[self.views objectAtIndex:0]).AlarmView.alpha = 1.0;
        ((PageONEViewController *)[self.views objectAtIndex:0]).AlarmGestureView.alpha = 1.0;
        self.severeWeatherAlert.message = @"Severe storm with thunderstorm and flash floods. Strong winds from NE. Stay inside if you can.";
        self.weatherAlertOn = true;
    }
    else {
        ((PageONEViewController *)[self.views objectAtIndex:0]).AlarmView.alpha = 0.0;
        ((PageONEViewController *)[self.views objectAtIndex:0]).AlarmGestureView.alpha = 0.0;
        self.weatherAlertOn = false;
    }
}

-(void)notifUpdate:(NSTimer *)timer {
    if  (self.sensorTag.isConnected && !self.wasConnected)
        self.wasConnected = true;
    else if (self.wasConnected && !self.sensorTag.isConnected) {
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        notif.alertBody = @"I can't see your phone anymore. I'm lost, go and get me!";
        notif.hasAction = YES;
        notif.fireDate = [NSDate new];
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        self.wasConnected = false;
    }
    
    if (self.sensorTag.isConnected) {
        float t = 1.8 *self.sensorTag.currentVal.tAmb + 32;
        float r = self.sensorTag.currentVal.humidity;
        
        float hi = -42.379 +2.049*t + 10.1433*r - 0.2247*t*r - 0.0068*t*t - 0.0548*r*r + 0.0012*t*t*r + 0.0009*t*r*r - 0.000002*t*t*r*r;
        
        float deh = 3.5 * self.sensorTag.currentVal.tAmb - 50;
        NSLog(@"%f, %f, %f",hi, deh, r);
        
        if (hi > 112) {
            self.healthHazardAlert.message = @"The temperature and humidity are very high, there is an increased chance of heath stroke. Keep hydrated and avoid extensive phisical activity.";
            if (!self.notifShown) {
                UILocalNotification *notif = [[UILocalNotification alloc] init];
                notif.alertBody = @"The temperature and humidity are very high, there is an increased chance of heath stroke.";
                notif.hasAction = YES;
                notif.fireDate = [NSDate new];
                [[UIApplication sharedApplication] scheduleLocalNotification:notif];
                self.notifShown = true;
            }
            ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmView.alpha = 1.0;
            ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmGestureView.alpha = 1.0;
        }
        else if ((r < deh && r > 0) || self.sensorTag.currentVal.tAmb > 35){
            self.healthHazardAlert.message = @"The temperature is very high, there is an increased chance of dehydration. Keep away from the sun and drink a lot of water.";
            if (!self.notifShown) {
                UILocalNotification *notif = [[UILocalNotification alloc] init];
                notif.alertBody = self.healthHazardAlert.message;
                notif.hasAction = YES;
                notif.fireDate = [NSDate new];
                [[UIApplication sharedApplication] scheduleLocalNotification:notif];
                self.notifShown = true;
            }
            ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmView.alpha = 1.0;
            ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmGestureView.alpha = 1.0;
        }
        else {
            ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmView.alpha = 0.0;
            ((PageONEViewController *)[self.views objectAtIndex:0]).HealthAlarmGestureView.alpha = 0.0;
            self.notifShown = false;
        }
    }
    
    if (self.forecastKit.changedAlerts && self.forecastKit.forecastDict) {
        if (self.forecastKit.getAlerts.count > 0) {
            ((PageONEViewController *)[self.views objectAtIndex:0]).AlarmView.alpha = 1.0;
            ((PageONEViewController *)[self.views objectAtIndex:0]).AlarmGestureView.alpha = 1.0;
            self.severeWeatherAlert.message = [self.forecastKit.getAlerts componentsJoinedByString:@" "];
            
            NSLog(@"%@",self.severeWeatherAlert.message);
            
            UILocalNotification *notif = [[UILocalNotification alloc] init];
            notif.alertBody = [self.forecastKit.getAlerts componentsJoinedByString:@" "];
            notif.hasAction = YES;
            notif.fireDate = [NSDate new];
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        }
        else {
            ((PageONEViewController *)[self.views objectAtIndex:0]).AlarmView.alpha = 0.0;
            ((PageONEViewController *)[self.views objectAtIndex:0]).AlarmGestureView.alpha = 0.0;
        }
        
        self.forecastKit.changedAlerts = false;
    }
    if (((PageONEViewController *)[self.views objectAtIndex:0]).showSevereWeatherAlert) {
        [self.severeWeatherAlert show];
        ((PageONEViewController *)[self.views objectAtIndex:0]).showSevereWeatherAlert = false;
    }
    if (((PageONEViewController *)[self.views objectAtIndex:0]).showHealthHazardAlert) {
        [self.healthHazardAlert show];
        ((PageONEViewController *)[self.views objectAtIndex:0]).showHealthHazardAlert = false;
    }
    
}

- (void)swipeRight:(UISwipeGestureRecognizer *)sender {
    UIViewController *viewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSUInteger index = 0;
    if ([viewController isKindOfClass:[PageONEViewController class]]) {
        index = 0;
    }
    else if ([viewController isKindOfClass:[PageTWOViewController class]]) {
        index = 1;
    }
    else if ([viewController isKindOfClass:[PageTHREEViewController class]]) {
        index = 2;
    }
    
    if (index > 0){
        
        //get the page to go to
        UIViewController *targetPageViewController = [self viewControllerAtIndex:(index - 1)];
        
        //put it(or them if in landscape view) in an array
        NSArray *theViewControllers = nil;
        theViewControllers = [NSArray arrayWithObjects:targetPageViewController, nil];
        
        //add page view
        [self.pageViewController setViewControllers:theViewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished){[self didFinishAnimating:finished];}];
    }

}

- (void)swipeLeft:(UISwipeGestureRecognizer *)sender {
    UIViewController *viewController = [self.pageViewController.viewControllers objectAtIndex:0];
    NSUInteger index = 0;
    if ([viewController isKindOfClass:[PageONEViewController class]]) {
        index = 0;
    }
    else if ([viewController isKindOfClass:[PageTWOViewController class]]) {
        index = 1;
    }
    else if ([viewController isKindOfClass:[PageTHREEViewController class]]) {
        index = 2;
    }
    
    if (index < 2){
        
        //get the page to go to
        UIViewController *targetPageViewController = [self viewControllerAtIndex:(index + 1)];
        
        //put it(or them if in landscape view) in an array
        NSArray *theViewControllers = nil;
        theViewControllers = [NSArray arrayWithObjects:targetPageViewController, nil];
        
        //add page view
        [self.pageViewController setViewControllers:theViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished){[self didFinishAnimating:finished];}];
        
    }
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.views count] == 0) || (index >= [self.views count])) {
        return nil;
    }
    else
        return [self.views objectAtIndex:index];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = 0;
    if ([viewController isKindOfClass:[PageONEViewController class]]) {
        index = 0;
    }
    else if ([viewController isKindOfClass:[PageTWOViewController class]]) {
        index = 1;
    }
    else if ([viewController isKindOfClass:[PageTHREEViewController class]]) {
        index = 2;
    }
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = 0;
    if ([viewController isKindOfClass:[PageONEViewController class]]) {
        index = 0;
    }
    else if ([viewController isKindOfClass:[PageTWOViewController class]]) {
        index = 1;
    }
    else if ([viewController isKindOfClass:[PageTHREEViewController class]]) {
        index = 2;
    }
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    return [self viewControllerAtIndex:index];
}

-(void)didFinishAnimating:(BOOL)finished {
    UIViewController *currentViewController = (UIViewController *)[self.pageViewController.viewControllers lastObject];
    NSUInteger index = 0;
    if ([currentViewController isKindOfClass:[PageONEViewController class]]) {
        index = 0;
        [self.navItem setTitle:((PageONEViewController*)currentViewController).pageTitle];
    }
    else if ([currentViewController isKindOfClass:[PageTWOViewController class]]) {
        index = 1;
        [self.navItem setTitle:@"Weather Map"];
    }
    else if ([currentViewController isKindOfClass:[PageTHREEViewController class]]) {
        index = 2;
        [self.navItem setTitle:@"Myrella Data"];
    }
    
    self.pageControl.currentPage = index;

}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){return;}
    
    [self didFinishAnimating:finished];
}

@end
