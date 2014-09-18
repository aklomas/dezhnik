//
//  GraphView.h
//  Myrella
//
//  Created by Filip Kralj on 28/05/14.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GraphView : UIView

//Initialization
- (id)initWithFrame:(CGRect)frame_;
- (void)addEntry:(NSNumber*)entry;

@property (strong, nonatomic) NSMutableArray *data;
@property int length;
@property int mid_value;
@property int range;
@property float interval;
@property NSString* unit;
@end
