//
//  UIUnderlinedButton.m
//  FootballReservation
//
//  Created by 巩鑫 on 14/10/23.
//  Copyright (c) 2014年 gx. All rights reserved.
//

#import "UIUnderlinedButton.h"

@implementation UIUnderlinedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//类方法初始化
+ (UIUnderlinedButton*) underlinedButton {
    UIUnderlinedButton* button = [[UIUnderlinedButton alloc] init];
    return button;
}

- (void)drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender+2);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender+2);
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke); 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
