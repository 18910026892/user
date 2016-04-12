//
//  markView.m
//  Accompany
//
//  Created by 王园园 on 16/2/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "markView.h"

@interface markView()<UIGestureRecognizerDelegate>
{
    UIImageView *backImg;
    UILabel *lable;
    UIButton *cancelBtn;
}

@end

@implementation markView


-(id)initWithString:(NSString *)string;
{
    if(self = [super init]){
        _contentStr = string;
        
        backImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 43, 38)];
        backImg.userInteractionEnabled = NO;
        [self addSubview:backImg];
        lable = [UILabel labelWithFrame:CGRectMake(18, 17, 320, 25) text:string textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13.0] backgroundColor:[UIColor clearColor]];
        lable.numberOfLines = 0;
        lable.userInteractionEnabled = NO;
        [lable sizeToFit];
        [backImg addSubview:lable];
        backImg.width = lable.width+26;
        UIImage* img=[UIImage imageNamed:@"mark"];
        UIEdgeInsets edge=UIEdgeInsetsMake(0,22,0,backImg.width);
        img= [img resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
        backImg.image = img;
        self.frame = CGRectMake(0, 0, backImg.width+20, 38);
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(self.width-21, 0, 18, 18) ;
        cancelBtn.layer.cornerRadius = cancelBtn.height/2;
        cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cancelBtn.layer.masksToBounds = YES;
        cancelBtn.layer.borderWidth = 1.0;
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"chahao"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.hidden = YES;
        [self addSubview:cancelBtn];
        
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panTagView =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panTagView:)];
        panTagView.minimumNumberOfTouches=1;
        panTagView.maximumNumberOfTouches=1;
        panTagView.delegate=self;
        [self addGestureRecognizer:panTagView];
        
        UITapGestureRecognizer* tapTagView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTagView:)];
        tapTagView.numberOfTapsRequired=1;
        tapTagView.numberOfTouchesRequired=1;
        tapTagView.delegate = self;
        [self addGestureRecognizer:tapTagView];
    }
    return self;
}

-(void)cancelBtnClick:(UIButton *)btn
{
    if(_delegate){
        [_delegate markView:self deleteMarkWith:_contentStr];
    }
    [self removeFromSuperview];
}

-(void)showCancelBtn:(BOOL)state;
{
    cancelBtn.hidden = !state;
}

#pragma -mark GestureRecognizer
/**
 *  标签移动
 */
-(void)panTagView:(UIPanGestureRecognizer *)sender{
    if(_delegate){
        [_delegate markView:self panTagView:sender];
    }
}

/**
 *  点击标签是否删除
 */
-(void)tapTagView:(UITapGestureRecognizer *)sender{
    cancelBtn.hidden= !cancelBtn.hidden;
}

@end
