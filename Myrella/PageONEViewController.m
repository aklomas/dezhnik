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
    
    
    NSTimer* timer = [NSTimer timerWithTimeInterval:0.1f target:self selector:@selector(updateView:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
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

-(void)updateView:(NSTimer *)timer {
    if(self.forecastKit.forecastDict){
        self.LocationLabel.text = self.forecastKit.curLocName;
        self.ForecastTempLabel.text = self.forecastKit.getCurTemperature;
        self.SummaryLabel.text = self.forecastKit.getCurSummary;
    }
    self.SensorTempLabel.text = [NSString stringWithFormat:@"Myrella: %@", self.sensorTag.isConnected ? [NSString stringWithFormat:@"%.1f°C",self.sensorTag.currentVal.tAmb] : @"N/A"];

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
