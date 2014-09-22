//
//  ScreenTHREEDottedCircle.m
//  Myrella
//
//  Created by Filip Kralj on 30/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "ScreenTHREEDottedCircle.h"

@implementation ScreenTHREEDottedCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setNr:(int)number {
    self.number = number;
    if (number > 1)
        self.percentOfHighlightedDots = log10(number)/4;
    else
        self.percentOfHighlightedDots = 0;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClearRect(ctx, rect);
    CGContextSetLineWidth(ctx, 4.0);
    
    CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGFloat angle = -M_PI/2;
    
    int nrOfDots = 50;
    int dotSize = 5;
    
    CGFloat centerX = self.frame.size.height/2;
    CGFloat centerY = self.frame.size.height/2;
    CGFloat radius = self.frame.size.height*0.48;
    CGFloat size = 2*radius;
    
    CGFloat startX = 0.0;
    CGFloat startY = 0.0;
    for (int i = 0; i < nrOfDots * self.percentOfHighlightedDots; i++) {
        
        startX = centerX +  cos(angle) * (radius) - dotSize/2;
        startY = centerY +  sin(angle) * (radius) - dotSize/2;
        CGContextFillEllipseInRect(ctx, CGRectMake(startX,  startY,  dotSize, dotSize));
        //[[UIColor blackColor] setStroke];
        angle+= 2*M_PI/nrOfDots;
    }
    
    CGContextSetRGBFillColor(ctx, 0.7, 0.7, 0.7, 0.5);
    for (int i = 0; i < nrOfDots * (1 - self.percentOfHighlightedDots); i++) {
        
        startX = centerX +  cos(angle) * (radius) - dotSize/2;
        startY = centerY +  sin(angle) * (radius) - dotSize/2;
        CGContextFillEllipseInRect(ctx, CGRectMake(startX,  startY,  dotSize, dotSize));
        //[[UIColor blackColor] setStroke];
        angle+= 2*M_PI/nrOfDots;
    }
    
    UIFont* font = [UIFont fontWithName:@"Helvetica-Light" size:size*0.6];
    if (self.number > 999)
        font = [UIFont fontWithName:@"Helvetica-Light" size:size*0.4];
    else if (self.number > 99)
        font = [UIFont fontWithName:@"Helvetica-Light" size:size*0.5];

    NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
    p.alignment = NSTextAlignmentCenter;
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font,
                                   NSForegroundColorAttributeName : [UIColor whiteColor],
                                   NSParagraphStyleAttributeName: p};
   
    NSString *str = [NSString stringWithFormat:@"%d", self.number];
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:str attributes:stringAttrs];
    [attrStr drawInRect:CGRectMake(0.0, (self.frame.size.height - font.pointSize)*0.4, self.frame.size.width, font.pointSize)];

}


@end
