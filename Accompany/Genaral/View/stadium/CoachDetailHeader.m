//
//  CoachDetailHeader.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/7.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "CoachDetailHeader.h"

@implementation CoachDetailHeader
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubview:self.BackButton];
        
    }
    return self;
}

-(UIButton*)BackButton
{
    if (!_BackButton) {
        _BackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _BackButton.frame = CGRectMake(10,20, 64*Proportion, 44);
        _BackButton.imageEdgeInsets = UIEdgeInsetsMake(0,-20, 0, 25);
        [_BackButton setImage:[UIImage imageNamed:@"BackButton"] forState:UIControlStateNormal];
        [_BackButton setImage:[UIImage imageNamed:@"BackButtonHighlighted"] forState:UIControlStateHighlighted];
        [_BackButton addTarget:self action:@selector(BackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BackButton;
}

-(void)BackButtonClick:(UIButton*)sender
{
    // 响应代理方法
    if ([self.delegate respondsToSelector:@selector(BackButtonClick:)]) {
        
        [self.delegate BackButtonClick:sender];
    }
    
}


@end
