//
//  SettingsViewController.m
//  Myrella
//
//  Created by Filip Kralj on 08/09/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(60, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    [self.weatherSwitch addTarget:self action:@selector(valueChangeWeather:) forControlEvents:UIControlEventValueChanged];
    [self.healthSwitch addTarget:self action:@selector(valueChangeHealth:) forControlEvents:UIControlEventValueChanged];
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)valueChangeWeather:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"weatherChanged" object:self.weatherSwitch];
}

- (void)valueChangeHealth:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"healthChanged" object:self.healthSwitch];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
