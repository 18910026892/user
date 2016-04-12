//
//  SearchTextField.m
//  syb
//
//  Created by GX on 15/10/21.
//  Copyright © 2015年 GX. All rights reserved.
//

#import "SearchTextField.h"

@implementation SearchTextField

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
    CGRect inset = CGRectMake(self.bounds.origin.x, self.bounds.origin.y+4, self.bounds.size.width , self.bounds.size.height);
   
    [self.placeholder drawInRect:inset withFont:[UIFont systemFontOfSize:14]];
}

@end
