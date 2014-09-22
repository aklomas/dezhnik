//
//  ScreenTHREESignal.m
//  Myrella
//
//  Created by Filip Kralj on 30/08/14.
//  Copyright (c) 2014 edu. All rights reserved.
//

#import "ScreenTHREESignal.h"

@implementation ScreenTHREESignal

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateRSSI:(CGFloat)rssi {
    CGFloat normRssi = [[NSString stringWithFormat:@"%0.2f",(rssi - 50)/60.0] floatValue];
    if (normRssi < 0.0)
        normRssi = 0.0;
    if(fabs(self.RSSI - (1.0 - normRssi)) > 0.02) {
        self.RSSI = self.RSSI + (1.0 - normRssi - self.RSSI)/20;
        [self setNeedsDisplay];
    }
    else if (self.connected == -1){
        self.RSSI = 0.0;
        self.connected = 0;
    }
    //NSLog(@"%f %f %f",self.RSSI,normRssi, rssi);
}

-(void)setDisconnected {
    if (self.connected == 1) {
        self.connected = -1;
        [self updateRSSI:110.0];
        [self setNeedsDisplay];
    }
    else if (self.connected == -1) {
        [self updateRSSI:110.0];
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(ctx, rect);
    CGContextSetLineWidth(ctx, 4.0);
    CGFloat size = self.frame.size.height * 0.9;
    
    UIColor *baseColor = [UIColor whiteColor];//[UIColor colorWithRed:1.0-self.RSSI green:self.RSSI blue:0.0 alpha:1.0];
    
    CGContextSetRGBStrokeColor(ctx, 1.0 - self.RSSI, self.RSSI, 0.0, 1.0);
    CGContextStrokeEllipseInRect(ctx, CGRectMake((self.frame.size.width-size)*0.5, (self.frame.size.height-size)*0.5, size, size));
    UIFont* font = [UIFont fontWithName:@"Helvetica-Light" size:80];
    NSMutableParagraphStyle* p = [NSMutableParagraphStyle new];
    p.alignment = NSTextAlignmentCenter;
    NSDictionary* stringAttrs = @{ NSFontAttributeName : font,
                                   NSForegroundColorAttributeName : baseColor,
                                   NSParagraphStyleAttributeName: p};
    NSString *signalStr = @"";
    if (self.RSSI > 0.80)
        signalStr = @"Strong";
    else if (self.RSSI > 0.50)
        signalStr = @"Moderate";
    else if (self.RSSI > 0.10)
        signalStr = @"Weak";
    else if (self.RSSI > 0.01)
        signalStr = @"Critical";
    else
        signalStr = @"Disconnected";
    
    NSString *str = [NSString stringWithFormat:@"%d", (int)(self.RSSI*100)];
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:str attributes:stringAttrs];
    [attrStr drawInRect:CGRectMake((self.frame.size.width-size)*0.5, (self.frame.size.height-size)*0.5+2, size, size)];
    
    font = [UIFont fontWithName:@"Helvetica-Light" size:12];
    stringAttrs = @{ NSFontAttributeName : font,
                                   NSForegroundColorAttributeName : baseColor,
                                   NSParagraphStyleAttributeName: p};
    attrStr = [[NSAttributedString alloc] initWithString:signalStr attributes:stringAttrs];
    [attrStr drawInRect:CGRectMake((self.frame.size.width-size)*0.5, self.frame.size.height*0.5+26, size, font.pointSize + 10)];
    
}


@end
