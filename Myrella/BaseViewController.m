//
//  ViewController.m
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
}

-(void)viewDidDisappear:(BOOL)animated {
    //[[self.views objectAtIndex:2] deinit];
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

-(void)didBecomeActive {
    if (self.sensorTag.isConnected)
        [self.sensorTag normalTimers];

    [((PageONEViewController *)[self.views objectAtIndex:0]) resumeTimer];
    [((PageTHREEViewController *)[self.views objectAtIndex:2]) resumeTimer];
    [self.forecastKit update];
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
