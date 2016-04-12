//
//  CustomTextField.m
//  syb
//
//  Created by GX on 15/8/20.
//  Copyright (c) 2015年 GX. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)drawPlaceholderInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1].CGColor);
    
    CGRect inset;
    UIFont * font;
    
    inset = CGRectMake(self.bounds.origin.x+5, self.bounds.origin.y+2, self.bounds.size.width , self.bounds.size.height);
    font = [UIFont systemFontOfSize:14.0];
 
    [self.placeholder drawInRect:inset withFont:font];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
