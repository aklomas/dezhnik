//
//  SettingsBaseViewController.h
//  Myrella
//
//  Created by Filip Kralj on 08/09/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

@interface SettingsBaseViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSArray *pageTitles;

@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;

@end
