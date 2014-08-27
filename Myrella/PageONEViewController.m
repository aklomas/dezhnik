//
//  PageONEViewController.m
//  Myrella
//
//  Created by Filip Kralj on 12/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "PageONEViewController.h"

@interface PageONEViewController ()

@end

@implementation PageONEViewController

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
    // Do any additional setup after loading the view.
    
    //Location init
    self.locationManager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    
    //svg init
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"settings-button" ofType:@"svg"];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:filePath];
    NSURLRequest *req = [NSURLRequest requestWithURL:fileURL];
    self.settingsSVGweb.opaque = NO;
    self.settingsSVGweb.backgroundColor = [UIColor clearColor];
    [self.settingsSVGweb setScalesPageToFit:NO];
    self.settingsSVGweb.delegate = self;
    self.settingsSVGweb.scrollView.scrollEnabled = NO;
    self.settingsSVGweb.scrollView.bounces = NO;
    [self.settingsSVGweb loadRequest:req];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGSize contentSize = webView.scrollView.contentSize;
    CGSize webViewSize = webView.bounds.size;
    CGFloat scaleFactor = webViewSize.width / contentSize.width;
    
    webView.scrollView.minimumZoomScale = scaleFactor;
    webView.scrollView.maximumZoomScale = scaleFactor;
    webView.scrollView.zoomScale = scaleFactor;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateToLocation: %@", locations);
    CLLocation *currentLocation = [locations objectAtIndex:[locations count]-1];
    
    // Stop Location Manager
    [self.locationManager stopUpdatingLocation];
    
    //NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            self.AddressLable.text = [NSString stringWithFormat:@"%@",
                                      self.placemark.locality];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
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
