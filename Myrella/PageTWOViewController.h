//
//  PageTWOViewController.h
//  Myrella
//
//  Created by Filip Kralj on 16/09/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MBProgressHUD.h"

@interface PageTWOViewController : UIViewController <MKMapViewDelegate> {
    NSMutableArray *overlayArray;
    GMSMapView *mapView;
    
    NSMutableArray *overlayObjectArray;
    
    NSTimer *checkDownloads;
    NSNumber *imagesExpected;
    NSNumber *currentLayerIndex;
    NSString *layerName;
    
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UIView *mView;
@property (nonatomic, retain) MKUserLocation *userLocation;
@property (nonatomic, retain) NSString *layerName_;



@end
