//
//  SettingsBaseViewController.m
//  Myrella
//
//  Created by Filip Kralj on 08/09/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "SettingsBaseViewController.h"

@interface SettingsBaseViewController ()

@end

@implementation SettingsBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [super viewDidLoad];
    // Create the data model
    self.pageTitles = @[@"Settings", @"Shop", @"About"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    SettingsViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 54);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    self.pageControl.numberOfPages = 3;
    self.pageControl.currentPage = 0;
    
}

-(void)viewDidDisappear:(BOOL)animated {
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (SettingsViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    // Create a new view controller and pass suitable data.
    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    settingsViewController.titleText = self.pageTitles[index];
    settingsViewController.pageIndex = index;
    
    return settingsViewController;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SettingsViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((SettingsViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){return;}
    UIViewController *currentViewController = (UIViewController *)[self.pageViewController.viewControllers lastObject];
    [self.navItem setTitle:((SettingsViewController*) currentViewController).titleText];
    self.pageControl.currentPage = ((SettingsViewController*) currentViewController).pageIndex;
}

@end
