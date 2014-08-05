//
//  MainVCModelController.h
//  Myrella
//
//  Created by Filip Kralj on 05/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainVCDataViewController;

@interface MainVCModelController : NSObject <UIPageViewControllerDataSource>

- (MainVCDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(MainVCDataViewController *)viewController;
Burek taratata

@end
