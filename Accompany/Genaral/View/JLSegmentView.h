//
//  JLSegmentView.h
//  Accompany
//
//  Created by 王园园 on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLSegmentView : UIScrollView

//滑动条
@property (nonatomic,strong)UIView *sliderView;
@property (nonatomic,assign)float sliderWidth;
//点击事件
@property(nonatomic,strong) void (^SegmentSelectedItemIndex)(NSInteger);

/*
 * seg标题数组
 * 一个item的宽度
 * 标题字体大小
 */
-(void)setTitleArr:(NSArray *)titles OneItemWidth:(NSInteger)Onewidth TitleFont:(UIFont *)font;
/**
 *  点击切换并触发事件
 */
-(void)itemSelectIndex:(NSInteger)index;
/**
 *  设置item标题
 */
-(void)setTitle:(NSString *)title AtIndex:(NSInteger)index;
/**
 *  根据scrollView的偏移量改变slider的位置
 */
-(void)SegmentChangeWithScrollView:(UIScrollView *)scroll contentOffset:(float)offset;

@end
