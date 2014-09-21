//
//  SettingsBaseViewController.m
//  Myrella
//
//  Created by Filip Kralj on 06/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "SettingsBaseViewController.h"

@interface SettingsBaseViewController ()

@end

@implementation SettingsBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsPageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.views = [[NSMutableArray alloc] initWithCapacity:3];
    [self.views addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"]];
    [self.views addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"BuyViewController"]];
    [self.views addObject:[self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"]];
    
    //((DefaultViewController *)[self.views objectAtIndex:1]).pageIndex = 1;
    //((DefaultViewController *)[self.views objectAtIndex:2]).pageIndex = 2;
    
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
}

-(void)viewDidDisappear:(BOOL)animated {
    //[[self.views objectAtIndex:2] deinit];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([viewController isKindOfClass:[SettingsViewController class]]) {
        index = 0;
    }
    else if ([viewController isKindOfClass:[DefaultViewController class]]) {
        index = ((DefaultViewController *)viewController).pageIndex;
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
    if ([viewController isKindOfClass:[SettingsViewController class]]) {
        index = 0;
    }
    else if ([viewController isKindOfClass:[DefaultViewController class]]) {
        //index = ((DefaultViewController *)viewController).pageIndex;
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
    
    if ([currentViewController isKindOfClass:[SettingsViewController class]]) {
        index = 0;
        [self.navigationItem setTitle:@"Settings"];
    }
    else if ([currentViewController isKindOfClass:[DefaultViewController class]]) {
        //index = ((DefaultViewController *)currentViewController).pageIndex;
        if (index == 1)
            [self.navigationItem setTitle:@"Buy Myrella"];
        else
            [self.navigationItem setTitle:@"About"];
    }
    
    self.pageControl.currentPage = index;
    
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){return;}
    
    [self didFinishAnimating:finished];
}

@end
