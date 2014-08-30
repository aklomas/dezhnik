//
//  ScreenTHREESignal.h
//  Myrella
//
//  Created by Filip Kralj on 30/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenTHREESignal : UIView

@property CGFloat RSSI;
@property int connected;

-(void)setDisconnected;
-(void)updateRSSI:(CGFloat)rssi;

@end
