//
//  ScreenONETempView.m
//  Myrella
//
//  Created by Filip Kralj on 28/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "ScreenONETempCircle.h"

@implementation ScreenONETempCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)update {
    if (self.extend == 1 && self.extended < 1.0) {
        self.extended += 0.1;
        if (self.extended > 0.91) {
            self.extend = 0;
            self.extended = 1.0;
        }
    }
    else if(self.extend == -1 && self.extended > 0.0) {
        self.extended -= 0.1;
        if (self.extended < 0.09) {
            self.extend = 0;
            self.extended = 0.0;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect_
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect_);

    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetRGBStrokeColor(ctx, 175/255.0, 193/255.0, 204/255.0, 1.0);
    
    
    CGFloat size = self.frame.size.height - 10;
    //CGContextStrokeEllipseInRect(ctx, CGRectMake((self.frame.size.width-size)*0.5, (self.frame.size.height-size)*0.5, size, size));
    CGContextAddArc(ctx, self.frame.size.width*0.5 - (self.frame.size.width-size-15)*0.5*self.extended, self.frame.size.height*0.5, size*0.5, M_PI/2, 3*M_PI/2, 0);
    CGContextAddArc(ctx, self.frame.size.width*0.5 + (self.frame.size.width-size-15)*0.5*self.extended, self.frame.size.height*0.5, size*0.5, 3*M_PI/2, M_PI/2, 0);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

    UIGraphicsBeginImageContext(self.frame.size);
    ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    /* do something with pathRef. For example:*/
    //CGPathMoveToPoint(pathRef, NULL, self.frame.size.width*0.5 - (self.frame.size.width-size-15)*0.5*self.extended, self.frame.size.height*0.5);
    CGPathAddArc(pathRef, NULL, self.frame.size.width*0.5 - (self.frame.size.width-size-15)*0.5*self.extended, self.frame.size.height*0.5, size*0.5, M_PI/2, 3*M_PI/2, FALSE);
    CGPathAddArc(pathRef, NULL, self.frame.size.width*0.5 + (self.frame.size.width-size-15)*0.5*self.extended, self.frame.size.height*0.5, size*0.5, 3*M_PI/2, M_PI/2, FALSE);
    CGPathCloseSubpath(pathRef);
    
//    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
//    //CGContextFillRect(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
//    
//    CGContextAddPath(ctx, pathRef);
//    CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
//    CGContextDrawPath(ctx, kCGPathFill);
//    
//    
//    CGContextRestoreGState(ctx);
//    self.mask = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.blurredView.layer.bounds;
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.path = pathRef;
    self.blurredView.layer.mask = maskLayer;
    CGPathRelease(pathRef);
    /*
    CALayer *_maskingLayer = [CALayer layer];
    _maskingLayer.frame = self.blurredView.bounds;
    [_maskingLayer setContents:(id)[self.mask CGImage]];
    [self.blurredView.layer setMask:_maskingLayer];
    */
    //NSLog(@"%f, %f", mask.size.height,mask.size.width);
    
    //[mask drawAtPoint:CGPointMake(0, 0)];
    
    
    /*int width = 4;
    for (int i = 1; i < width; i++) {
        CGContextSetRGBStrokeColor(ctx, 175/255.0, 193/255.0, 204/255.0, 1.0 * (width-i) / width);
        
        CGContextStrokeEllipseInRect(ctx, CGRectMake((self.frame.size.width-size)*0.5 - i, (self.frame.size.height-size)*0.5 - i, size + 2*i, size + 2*i));
        CGContextStrokeEllipseInRect(ctx, CGRectMake((self.frame.size.width-size)*0.5 + i, (self.frame.size.height-size)*0.5 + i, size - 2*i, size - 2*i));
    }*/
}



@end
