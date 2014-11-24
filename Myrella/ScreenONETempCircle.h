//
//  ScreenONETempView.h
//  Myrella
//
//  Created by Filip Kralj on 28/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenONETempCircle : UIView

@property float extended;
@property int extend;
@property UIView * blurredView;
@property UIImage * mask;

-(void)update;

@end
