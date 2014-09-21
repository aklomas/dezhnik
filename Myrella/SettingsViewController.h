//
//  SettingsViewController.h
//  Myrella
//
//  Created by Filip Kralj on 08/09/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UITableViewController


@property NSUInteger pageIndex;

@property (weak, nonatomic) IBOutlet UISwitch *healthSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *weatherSwitch;

@end
