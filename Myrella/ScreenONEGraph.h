//
//  ScreenONEGraph.h
//  Myrella
//
//  Created by Filip Kralj on 29/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenONEGraph : UIView

@property (strong, nonatomic) NSMutableArray *tempData;
@property (strong, nonatomic) NSMutableArray *percipData;

-(void)update;

@end
