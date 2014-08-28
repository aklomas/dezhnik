//
//  ForecastKit.m
//  Myrella
//
//  Created by Filip Kralj on 28/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "ForecastKit.h"
#import "AFHTTPRequestOperation.h"

@interface ForecastKit()

@property (nonatomic, strong) NSString *apiKey;

@end

@implementation ForecastKit

-(id)initWithAPIKey:(NSString*)api_key {
    self = [super init];
    if (self) {
        
        self.apiKey = [api_key copy];
        
        //Location init
        self.locationManager = [[CLLocationManager alloc] init];
        self.geocoder = [[CLGeocoder alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager startUpdatingLocation];
    }
    
    return self;
}

-(void)updateDictionary {
    NSLog(@"Updating weather dictionary");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f?units=auto", self.apiKey, 51.58865810, -0.23059906 /*self.location.coordinate.latitude, self.location.coordinate.longitude*/]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.forecastDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        //NSLog(@"%@", self.forecastDict);
        
    }                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Currently %@", error.description);
        
    }];
    [operation start];
    
    NSLog(@"Updating weather dictionary");
    NSURL *url1 = [NSURL URLWithString:@"http://datapoint.metoffice.gov.uk/public/data/layer/wxobs/all/json/capabilities?key=496cb704-5e2d-4ccc-ae32-8a7bfe7fe5a2"];
    NSURLRequest *request1 = [NSURLRequest requestWithURL:url1];
    AFHTTPRequestOperation *operation1 = [[AFHTTPRequestOperation alloc] initWithRequest:request1];
    operation1.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation1 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSMutableDictionary *dez = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        //NSLog(@"%@", dez);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Currently %@", error.description);
        
    }];
    [operation1 start];
}

-(NSString *)getCurTemperature {
    /*NSString *r = [NSString stringWithFormat:@"%d", (int)([[[self.forecastDict valueForKey:@"currently"] valueForKey:@"temperature"] floatValue] + 0.5)];
    NSLog(@"%@",r);*/
    return [NSString stringWithFormat:@"%d", (int)([[[self.forecastDict valueForKey:@"currently"] valueForKey:@"temperature"] floatValue] + 0.5)];
}

-(NSString *)getCurSummary {
    return [NSString stringWithFormat:@"%@", [[self.forecastDict valueForKey:@"currently"] valueForKey:@"summary"]];
}

-(void)updateLocation {
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //NSLog(@"didUpdateToLocation: %@", locations);
    self.location = [locations objectAtIndex:[locations count]-1];
    
    // Stop Location Manager
    [self.locationManager stopUpdatingLocation];
    
    //NSLog(@"Resolving the Address");
    [self.geocoder reverseGeocodeLocation:self.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            self.placemark = [placemarks lastObject];
            self.curLocName = [NSString stringWithFormat:@"%@", self.placemark.locality];
            NSLog(@"Found locality: %@", self.placemark.locality);
            [self updateDictionary];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}




@end
