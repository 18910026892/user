//
//  JLSegmentView.m
//  Accompany
//
//  Created by 王园园 on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLSegmentView.h"
#define SLiderHeight 3.0
static int Tag = 2000;
@interface JLSegmentView()
{
    UIButton *tempBtn;
}
@property float SliderMargin;

@end
@implementation JLSegmentView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.bounces = NO;
        self.userInteractionEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
    }
    return self;
}

-(void)setTitleArr:(NSArray *)titles OneItemWidth:(NSInteger)Onewidth TitleFont:(UIFont *)font
{
    for(int i=0;i<titles.count;i++){
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(Onewidth*i, 0, Onewidth, self.frame.size.height);
        [btn1 setTitle:titles[i] forState:UIControlStateNormal];
        btn1.tag = i+Tag;
        [btn1 setTitleColor:kTabBarItemNomalColor forState:UIControlStateNormal];
        [btn1 setTitleColor:kTabBarItemSelectColor forState:UIControlStateSelected];
        [btn1 addTarget:self action:@selector(ButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        btn1.titleLabel.font = font;
        [self addSubview:btn1];
        
        //设置默认选中第0个
        if(i==0){
            btn1.selected = YES;
            tempBtn = btn1;
        }
    }
    
    [self setContentSize:CGSizeMake(Onewidth*titles.count, 1)];
    //默认滑动条的宽度
    _SliderMargin = 15.0*320/kMainScreenWidth;
    _sliderWidth = Onewidth-_SliderMargin*2;
    
    _sliderView = [[UIView alloc]initWithFrame:CGRectMake((Onewidth-_sliderWidth)/2, self.frame.size.height-SLiderHeight, _sliderWidth, SLiderHeight)];
    _sliderView.backgroundColor = kTabBarItemSelectColor;
    [self addSubview:_sliderView];
}

//重写滑动条的宽度
-(void)setSliderWidth:(float)sliderWidth
{
    if(_sliderView){
        _sliderView.frame = CGRectMake(_sliderView.origin.x+(_sliderWidth-sliderWidth)/2, _sliderView.origin.y, sliderWidth, SLiderHeight);
    }
    _SliderMargin = _SliderMargin+(_sliderWidth-sliderWidth)/2;
    _sliderWidth = sliderWidth;
}


-(void)ButtonClick:(UIButton *)btn
{
    if(btn != tempBtn){
        [self itemSelectIndex:btn.tag-Tag];
    }
}

-(void)itemSelectIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:index+Tag];
    tempBtn.selected = NO;
    btn.selected = YES;
    tempBtn=btn;
    
    //    [UIView animateWithDuration:0.15 animations:^{
    //        _sliderView.frame = CGRectMake(btn.frame.origin.x+(btn.frame.size.width-_sliderWidth)/2, self.frame.size.height-SLiderHeight, _sliderWidth, SLiderHeight);
    //    } completion:^(BOOL finished) {
    //    }];
    
    if(_SegmentSelectedItemIndex){
        _SegmentSelectedItemIndex(index);
    }
}


/**
 *
 *根据scrollView的偏移量来移动滚动条的位置
 */
-(void)SegmentChangeWithScrollView:(UIScrollView *)scroll contentOffset:(float)offset;
{
    float sliderOffset = self.width * offset / scroll.contentSize.width;
    _sliderView.frame = CGRectMake(sliderOffset+_SliderMargin, self.frame.size.height-SLiderHeight, _sliderWidth, SLiderHeight);
}

/**
 *
 *item标题
 */
-(void)setTitle:(NSString *)title AtIndex:(NSInteger)index;
{
    UIButton *btn = (UIButton *)[self viewWithTag:index+Tag];
    [btn setTitle:title forState:UIControlStateNormal];
}


@end
