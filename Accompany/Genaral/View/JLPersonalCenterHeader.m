//
//  JLPersonalCenterHeader.m
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPersonalCenterHeader.h"

@implementation JLPersonalCenterHeader
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

   
    }
    return self;
}

- (void)setUserModel:(JLPostUserInfoModel*)UserModel
{
    _UserModel = UserModel;
    [self addSubview:self.BackButton];
  
    
  
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
