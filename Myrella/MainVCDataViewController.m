//
//  MainVCDataViewController.m
//  Myrella
//
//  Created by Filip Kralj on 05/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "MainVCDataViewController.h"

@interface MainVCDataViewController ()

@end

@implementation MainVCDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.dataLabel.text = [self.dataObject description];
}

@end
