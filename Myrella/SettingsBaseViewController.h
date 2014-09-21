//
//  SettingsBaseViewController.h
//  Myrella
//
//  Created by Filip Kralj on 06/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVGKit.h"
#import "SettingsViewController.h"
#import "DefaultViewController.h"

@interface SettingsBaseViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property NSMutableArray *views;

-(void)didFinishAnimating:(BOOL)finished;


@end
