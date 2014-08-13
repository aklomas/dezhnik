//
//  ViewController.m
//  Myrella
//
//  Created by Filip Kralj on 06/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    UIViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    // Create a new view controller and pass suitable data.
    if (index == 0) {
        PageONEViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageONE"];
        return pageContentViewController;
    }
    else if (index == 1) {
        PageTWOViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageTWO"];
        return pageContentViewController;
    }
    else if (index == 2) {
        PageTHREEViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageTHREE"];
        return pageContentViewController;
    }
    else if (index == 3) {
        PageFOURViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageFOUR"];
        return pageContentViewController;
    }
    else {
        return nil;
    }
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
    else if ([viewController isKindOfClass:[PageFOURViewController class]]) {
        index = 3;
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
    else if ([viewController isKindOfClass:[PageFOURViewController class]]) {
        index = 3;
    }
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){return;}
    
    UIViewController *currentViewController = (UIViewController *)[self.pageViewController.viewControllers lastObject];
    NSUInteger index = 0;
    if ([currentViewController isKindOfClass:[PageONEViewController class]]) {
        index = 0;
    }
    else if ([currentViewController isKindOfClass:[PageTWOViewController class]]) {
        index = 1;
    }
    else if ([currentViewController isKindOfClass:[PageTHREEViewController class]]) {
        index = 2;
    }
    else if ([currentViewController isKindOfClass:[PageFOURViewController class]]) {
        index = 3;
    }
    
    self.pageControl.currentPage = index;
}
@end
