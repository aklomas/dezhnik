//
//  PageONEViewController.h
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface PageONEViewController : UIViewController <UIWebViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *settingsSVGweb;

@property (weak, nonatomic) IBOutlet UILabel *AddressLable;
@property CLLocationManager *locationManager;
@property CLGeocoder *geocoder;
@property CLPlacemark *placemark;

@end
