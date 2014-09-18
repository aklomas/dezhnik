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
        //[self.locationManager startUpdatingLocation];
        self.changed = false;
    }
    
    return self;
}

-(void)update {
    [self updateLocation];
}

-(void)updateDictionary {
    NSLog(@"Updating weather dictionary");
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.forecast.io/forecast/%@/%.6f,%.6f?units=si", self.apiKey, self.location.coordinate.latitude, self.location.coordinate.longitude]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.forecastDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        NSLog(@"Dictionary updated");
        //NSLog(@"%@", self.forecastDict);
        
    }                               failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Currently %@", error.description);
        
    }];
    [operation start];
    
    /*NSLog(@"Updating weather dictionary");
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
    [operation1 start];*/
    self.changed = true;
}

-(NSString *)getCurTemperature {
    return [NSString stringWithFormat:@"%f", [[[self.forecastDict valueForKey:@"currently"] valueForKey:@"temperature"] floatValue]];
}

-(NSString *)getDailyMaxTemperature {
    return [NSString stringWithFormat:@"%f", [[[[[self.forecastDict valueForKey:@"daily"] valueForKey:@"data"] objectAtIndex:0]valueForKey:@"temperatureMax"] floatValue]];
}

-(NSString *)getDailyMinTemperature {
    return [NSString stringWithFormat:@"%f", [[[[[self.forecastDict valueForKey:@"daily"] valueForKey:@"data"] objectAtIndex:0]valueForKey:@"temperatureMin"] floatValue]];
}

-(NSString *)getDailyMessage {
    return [NSString stringWithFormat:@"%@", [[self.forecastDict valueForKey:@"hourly"] valueForKey:@"summary"]];
}

-(NSString *)getCurPercipIntensity {
    return [NSString stringWithFormat:@"%f", [[[self.forecastDict valueForKey:@"currently"] valueForKey:@"precipIntensity"] floatValue]];
}

-(NSString *)getCurSummary {
    return [NSString stringWithFormat:@"%@", [[self.forecastDict valueForKey:@"currently"] valueForKey:@"summary"]];
}

-(NSString *)getCurIcon {
    return [NSString stringWithFormat:@"%@", [[self.forecastDict valueForKey:@"currently"] valueForKey:@"icon"]];
}

-(NSString *)getIconForNextHour:(int)hour {
    return [NSString stringWithFormat:@"%@", [[[[self.forecastDict valueForKey:@"hourly"] valueForKey:@"data"] objectAtIndex:hour] objectForKey:@"icon"]];
}

-(NSString *)getTempForNextHour:(int)hour {
    return [NSString stringWithFormat:@"%f", [[[[[self.forecastDict valueForKey:@"hourly"] valueForKey:@"data"] objectAtIndex:hour] objectForKey:@"temperature"] floatValue]];
}

-(NSString *)getPercipIntensityForNextHour:(int)hour {
    return [NSString stringWithFormat:@"%f", [[[[[self.forecastDict valueForKey:@"hourly"] valueForKey:@"data"] objectAtIndex:hour] objectForKey:@"precipIntensity"] floatValue]];
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
            self.curLocName = self.placemark.areasOfInterest ?
                                            [NSString stringWithFormat:@"%@, %@",
                                                [NSString stringWithFormat:@"%@", self.placemark.locality],
                                                [self.placemark.areasOfInterest objectAtIndex:[self.placemark.areasOfInterest count] - 1]]
                                          : [NSString stringWithFormat:@"%@", self.placemark.locality];
            
            NSLog(@"Found locality: %@, %@", self.placemark.locality
                                           , self.placemark.areasOfInterest);
            [self updateDictionary];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}




@end
