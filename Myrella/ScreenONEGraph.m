//
//  ScreenONEGraph.m
//  Myrella
//
//  Created by Filip Kralj on 29/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "ScreenONEGraph.h"

@implementation ScreenONEGraph

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) update {
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat height = (self.frame.size.height-20)/3;
    CGFloat width = (self.frame.size.width-40)/11;
    
    UIColor *baseColor = [UIColor colorWithRed:69/255.0 green:81/255.0 blue:87/255.0 alpha:1.0];
    
    [baseColor setStroke];
    CGFloat dashPattern[] = {4,4};
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    [path setLineDash:dashPattern count:2 phase:0];
    [path moveToPoint:CGPointMake(40, height)];
    [path addLineToPoint:CGPointMake(width*11+40, height)];
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.7];

    path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    [path setLineDash:dashPattern count:2 phase:0];
    [path moveToPoint:CGPointMake(40, height*2)];
    [path addLineToPoint:CGPointMake(width*11+40, height*2)];
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.7];

    path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    [path moveToPoint:CGPointMake(40, height*3)];
    [path addLineToPoint:CGPointMake(width*11+40, height*3)];
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    
    for (int i = 1; i < 11; i++) {
        path = [UIBezierPath bezierPath];
        path.lineWidth = 1;
        [path moveToPoint:CGPointMake(30 + i*width*1.1, height*3)];
        [path addLineToPoint:CGPointMake(30 + i*width*1.1, height*3-5)];
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:1.0];
    }
    
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:9];
    NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
    p.alignment = NSTextAlignmentCenter;
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font,
                                   NSForegroundColorAttributeName : [baseColor colorWithAlphaComponent:0.7],
                                   NSParagraphStyleAttributeName: p};
    
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:@"HEAVY" attributes:stringAttrs];
    [attrStr drawAtPoint:CGPointMake(0.0f, (height-10)*0.5f)];
    
    attrStr = [[NSAttributedString alloc] initWithString:@"MED" attributes:stringAttrs];
    [attrStr drawAtPoint:CGPointMake(0.0f, height*1.f + (height-10)*0.5f)];
    
    attrStr = [[NSAttributedString alloc] initWithString:@"LIGHT" attributes:stringAttrs];
    [attrStr drawAtPoint:CGPointMake(0.0f, height*2.f + (height-10)*0.5f)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH"];
    int curTime = [[formatter stringFromDate:[NSDate date]] intValue];
    
    for (int i = 1; i < 11; i++) {
        NSString *str = curTime+i < 12 ? [NSString stringWithFormat:@"%dam",curTime+i] :
                       curTime+i == 12 ? [NSString stringWithFormat:@"%dpm",curTime+i] :
                       curTime+i < 24 ? [NSString stringWithFormat:@"%dpm",curTime-12+i] :
                                        [NSString stringWithFormat:@"%dam",curTime-24+i];
        attrStr = [[NSAttributedString alloc] initWithString:str attributes:stringAttrs];
        [attrStr drawInRect:CGRectMake(30 + i*width*1.1 - 20, height*3+3, 40, 12)];
    }
    
    if(self.tempData && self.percipData) {
        /////////////////////////
        ////RAIN
        ////////////////////////
        path = [UIBezierPath bezierPath];
        CGFloat point = [self percipPoint:0 heightOfSection:height];
        //NSLog(@"%f",[[self.percipData objectAtIndex:0] floatValue]);
        CGFloat diff1 = point + ([self percipPoint:1 heightOfSection:height] - point)*0.5;
        CGFloat diff2 = 0;
        
        [path moveToPoint:CGPointMake(40, height*3)];
        [path addLineToPoint:CGPointMake(40, point)];
        for (int i = 1; i < 12; i++) {
            point = [self percipPoint:i heightOfSection:height];
            if (i != 11)
                diff2 = point - ([self percipPoint:i+1 heightOfSection:height] - point)*0.5;
            if (point == 72.0)
                diff2 = 72.0;
            [path addCurveToPoint:CGPointMake(30 + i*width*1.1, point)
                    controlPoint1:CGPointMake(30 + (i-0.5)*width*1.1, diff1)
                    controlPoint2:CGPointMake(30 + (i-0.5)*width*1.1, diff2)];
            
            //NSLog(@"%f %f",[[self.percipData objectAtIndex:i] floatValue], point);
            if (i == 11)
                break;
            diff1 = point + ([self percipPoint:i+1 heightOfSection:height] - point)*0.5;
        }
        [path addLineToPoint:CGPointMake(40 + 11*width, 3*height)];
        [path closePath];
        [[UIColor colorWithRed:81/255.0 green:114/255.0 blue:129/255.0 alpha:1.0] setStroke];
        [path fillWithBlendMode:kCGBlendModeNormal alpha:0.5];

        
        /////////////////////////
        ////TEMP
        ////////////////////////
        font = [UIFont fontWithName:@"Helvetica" size:9];
        [[UIColor colorWithRed:243/255.0 green:210/255.0 blue:122/255.0 alpha:1.0] setStroke];
        stringAttrs = @{ NSFontAttributeName : font,
                         NSForegroundColorAttributeName : [UIColor colorWithRed:243/255.0 green:210/255.0 blue:122/255.0 alpha:0.6],
                         NSParagraphStyleAttributeName: p};
        
        path = [UIBezierPath bezierPath];
        path.lineWidth = 2;
        CGFloat min = [[self.tempData valueForKeyPath:@"@min.self"] floatValue];
        CGFloat space = 3*height*0.3;
        CGFloat unit = 3*height*0.4 / ([[self.tempData valueForKeyPath:@"@max.self"] floatValue] - min);
        point = 3*height - (([[self.tempData objectAtIndex:0] floatValue] - min)*unit + space);
        diff1 = point + ((3*height - (([[self.tempData objectAtIndex:1] floatValue] - min)*unit + space)) - point)*0.5;
        diff2 = 0;
        
        [path moveToPoint:CGPointMake(40, 3*height - (([[self.tempData objectAtIndex:0] floatValue] - min)*unit + space))];
        for (int i = 1; i < 12; i++) {
            point = 3*height - (([[self.tempData objectAtIndex:i] floatValue] - min)*unit + space);
            if (i != 11)
                diff2 = point - ((3*height - (([[self.tempData objectAtIndex:i+1] floatValue] - min)*unit + space)) - point)*0.5;
            [path addCurveToPoint:CGPointMake(30 + i*width*1.1, point)
                  controlPoint1:CGPointMake(30 + (i-0.5)*width*1.1, diff1)
                  controlPoint2:CGPointMake(30 + (i-0.5)*width*1.1, diff2)];
            if (i == 11)
                break;
            diff1 = point + ((3*height - (([[self.tempData objectAtIndex:i+1] floatValue] - min)*unit + space)) - point)*0.5;
            
            attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d°", (int)([[self.tempData objectAtIndex:i] floatValue] + 0.5)] attributes:stringAttrs];
            [attrStr drawInRect:CGRectMake(30 + i*width*1.1 - 10, point - 12, 20, 10)];
        }
        
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.6];
    }
    
}

-(CGFloat) percipPoint:(int)index heightOfSection:(CGFloat)height{
    CGFloat rain = [[self.percipData objectAtIndex:index] floatValue];
    if(rain < 2.5)
        return 3*height - rain/2.5 * height;
    else if (rain < 10.0)
        return 2*height - (rain-2.5)/7.5*height;
    else if (rain < 50.0)
        return height - (rain-10.0)/40.0*height;
    else
        return 3*height;
}

@end
