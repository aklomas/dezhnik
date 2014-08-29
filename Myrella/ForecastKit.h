//
//  ForecastKit.h
//  Myrella
//
//  Created by Filip Kralj on 28/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ForecastKit : NSObject <CLLocationManagerDelegate>

@property (strong,nonatomic) NSMutableDictionary *forecastDict;

@property CLLocationManager *locationManager;
@property CLGeocoder *geocoder;
@property CLPlacemark *placemark;
@property CLLocation *location;

@property BOOL changed;

@property NSString *curLocName;

-(id)initWithAPIKey:(NSString*)api_key;

-(void)updateLocation;
-(void)updateDictionary;

-(NSString *)getCurTemperature;
-(NSString *)getDailyMinTemperature;
-(NSString *)getDailyMaxTemperature;
-(NSString *)getCurPercipIntensity;
-(NSString *)getCurSummary;
-(NSString *)getCurIcon;
-(NSString *)getDailyMessage;

-(NSString *)getIconForNextHour:(int)hour;
-(NSString *)getTempForNextHour:(int)hour;
-(NSString *)getPercipIntensityForNextHour:(int)hour;

@end
