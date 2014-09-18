//
//  GraphView.m
//  Myrella
//
//  Created by Filip Kralj on 28/05/14.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)frame_
{
    self = [super initWithFrame:frame_];
    if(self == nil)
        return nil;
    
    return self;
}

#pragma mark - Array
- (void)addEntry:(NSNumber*)entry
{
    if (self.data == nil) {
        self.data = [[NSMutableArray alloc] init];
        self.length = 86400;
    }
    float newEntry = 0.0;
    if(entry.floatValue < self.mid_value - self.range/2)
        newEntry = 0.0;
    if (entry.floatValue > self.mid_value + self.range/2)
        newEntry = 1.0;
    else
        newEntry = (entry.floatValue - (self.mid_value - self.range/2))/self.range;
    
    for (int i = 0; i < self.interval; i++) {
        float last = ((NSNumber*)[self.data lastObject]).floatValue;
        [self.data addObject:[NSNumber numberWithFloat:last + (newEntry - last)/self.interval]];
    }
    
    if ([self.data count] > self.length)
        [self.data removeObjectAtIndex:0];
    
    //NSLog(@"%f",self.interval);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, rect);
    
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    
    CGFloat width = self.frame.size.width * 0.9;
    CGFloat height = self.frame.size.height * 0.85;
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, self.frame.size.width * 0.1, self.frame.size.height * 0.075);
    
    CGContextMoveToPoint(ctx, 0.0f, 0.0f);
    CGContextAddLineToPoint(ctx, 0.0f, height);
    CGContextStrokePath(ctx);
    
    /*CGContextMoveToPoint(ctx, 0.0f, height);
    CGContextAddLineToPoint(ctx, width, height);
    CGContextStrokePath(ctx);*/
    
    
    float step = width/[self.data count];
//    for (int i = 0; self.data != nil && i < [self.data count] - 1; i++) {
//        /*CGContextSetRGBStrokeColor(ctx,
//                                   ((NSNumber*)[self.data objectAtIndex:i+1]).floatValue,
//                                   1.0-((NSNumber*)[self.data objectAtIndex:i+1]).floatValue,
//                                   1.0-((NSNumber*)[self.data objectAtIndex:i+1]).floatValue,
//                                   1.0);*/
//        
//        CGContextSetRGBStrokeColor(ctx, 0.1, 0.9,0.9, 1.0);
//        //NSLog(@"graph: %f",((NSNumber*)[self.data objectAtIndex:i+1]).floatValue);
//        CGContextMoveToPoint(ctx, step*i, height - (((NSNumber*)[self.data objectAtIndex:i]).floatValue * height ));
//        CGContextAddLineToPoint(ctx, step*(i+1), height - ((NSNumber*)[self.data objectAtIndex:i+1]).floatValue * height);
//        CGContextStrokePath(ctx);
//    }
    if ([self.data count] > 1) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1;
        float point = height - ((NSNumber*)[self.data objectAtIndex:0]).floatValue * height;
        float diff1 = point + ((height - ((NSNumber*)[self.data objectAtIndex:1]).floatValue * height) - point)*0.5;
        float diff2 = 0;
        //NSLog(@"%f", ((NSNumber*)[self.data objectAtIndex:0]).floatValue);
        
        [path moveToPoint:CGPointMake(0, point)];
        for (int i = 1; i < [self.data count] - 1; i++) {
            //NSLog(@"%f", ((NSNumber*)[self.data objectAtIndex:i]).floatValue);
            point = height - ((NSNumber*)[self.data objectAtIndex:i]).floatValue * height;
            
            diff2 = point - ((height - ((NSNumber*)[self.data objectAtIndex:i+1]).floatValue * height) - point)*0.5;
            [path addCurveToPoint:CGPointMake(step*i, point)
                    controlPoint1:CGPointMake(step*(i-0.5), diff1)
                    controlPoint2:CGPointMake(step*(i-0.5), diff2)];
            
            diff1 = point + ((height - ((NSNumber*)[self.data objectAtIndex:i+1]).floatValue * height) - point)*0.5;;
        }
        
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.6];
    }
    
    
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextMoveToPoint(ctx, 0.0f, 0.0f);
    CGContextAddLineToPoint(ctx, width/20, 0.0f);
    CGContextStrokePath(ctx);
    
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextMoveToPoint(ctx, 0.0f, height/2);
    CGContextAddLineToPoint(ctx, width/20, height/2);
    CGContextStrokePath(ctx);
    
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextMoveToPoint(ctx, 0.0f, height);
    CGContextAddLineToPoint(ctx, width/20, height);
    CGContextStrokePath(ctx);
    
    
    
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:10];
    NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
    p.alignment = NSTextAlignmentCenter;
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font,
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSParagraphStyleAttributeName: p};
    
    NSString *str = [NSString stringWithFormat:@"%d%@", (int)(self.mid_value + self.range/2), self.unit];
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:str attributes:stringAttrs];
    [attrStr drawInRect:CGRectMake(-self.frame.size.width*0.15, 0 - font.pointSize/2, self.frame.size.width*0.2,  font.pointSize)];
    
    str = [NSString stringWithFormat:@"%d%@", (int)(self.mid_value), self.unit];
    attrStr = [[NSAttributedString alloc] initWithString:str attributes:stringAttrs];
    [attrStr drawInRect:CGRectMake(-self.frame.size.width*0.15, height * 0.5 - font.pointSize/2, self.frame.size.width*0.2, font.pointSize)];
    
    str = [NSString stringWithFormat:@"%d%@", (int)(self.mid_value - self.range/2), self.unit];
    attrStr = [[NSAttributedString alloc] initWithString:str attributes:stringAttrs];
    [attrStr drawInRect:CGRectMake(-self.frame.size.width*0.15, height - font.pointSize/2, self.frame.size.width*0.2, font.pointSize)];
    
}


@end
