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

- (void)drawRect:(CGRect)rect
{
    CGFloat height = (self.frame.size.height-20)/3;
    CGFloat width = (self.frame.size.width-40)/11;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIColor *baseColor = [UIColor colorWithRed:69/255 green:81/255 blue:87/255 alpha:1.0];
    
    [baseColor setStroke];
    CGFloat dashPattern[] = {4,4};
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    [path setLineDash:dashPattern count:2 phase:0];
    [path moveToPoint:CGPointMake(40, height)];
    [path addLineToPoint:CGPointMake(width*11+40, height)];
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.5];

    path = [UIBezierPath bezierPath];
    path.lineWidth = 1;
    [path setLineDash:dashPattern count:2 phase:0];
    [path moveToPoint:CGPointMake(40, height*2)];
    [path addLineToPoint:CGPointMake(width*11+40, height*2)];
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.5];

    path = [UIBezierPath bezierPath];
    path.lineWidth = 2;
    [path moveToPoint:CGPointMake(40, height*3)];
    [path addLineToPoint:CGPointMake(width*11+40, height*3)];
    [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.7];
    
    for (int i = 1; i < 11; i++) {
        path = [UIBezierPath bezierPath];
        path.lineWidth = 1;
        [path moveToPoint:CGPointMake(40 + i*width, height*3)];
        [path addLineToPoint:CGPointMake(40 + i*width, height*3-5)];
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:0.7];
    }
    
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:10];
    NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
    p.alignment = NSTextAlignmentCenter;
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font,
                                   NSForegroundColorAttributeName : [baseColor colorWithAlphaComponent:0.5],
                                   NSParagraphStyleAttributeName: p};
    
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:@"HEAVY" attributes:stringAttrs];
    [attrStr drawAtPoint:CGPointMake(0.0f, (height-10)*0.5f)];
    
    attrStr = [[NSAttributedString alloc] initWithString:@"MED" attributes:stringAttrs];
    [attrStr drawAtPoint:CGPointMake(0.0f, height*1.f + (height-10)*0.5f)];
    
    attrStr = [[NSAttributedString alloc] initWithString:@"LIGHT" attributes:stringAttrs];
    [attrStr drawAtPoint:CGPointMake(0.0f, height*2.f + (height-10)*0.5f)];
    
    for (int i = 1; i < 11; i++) {
        attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%dh",i] attributes:stringAttrs];
        [attrStr drawInRect:CGRectMake(40 + i*width - 20, height*3+3, 40, 12)];
    }

}

@end
