//
//  JLComDetailViewController.h
//  Accompany
//
//  Created by 王园园 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLComDetailViewController;
@class JLPostListModel;
@class JLPostListCell;
@protocol ComDetailVCDelegate <NSObject>

-(void)comDetailViewController:(JLComDetailViewController *)commVC clickTopBtnTag:(NSInteger)btnTag;
-(void)comDetailViewControllerMoreRecommentClick;

-(void)comDetailViewController:(JLComDetailViewController *)commVC recommendtionSelectData:(id)communityData;
-(void)comDetailViewController:(JLComDetailViewController *)commVC didSelectData:(id)communityData;

//评论
-(void)comDetailVCcommentBtn:(UIButton *)commentBtn clickedWithData:(JLPostListModel *)celldata;
-(void)comPostCell:(JLPostListCell *)cell userImageTapWithData:(id)celldata;
@end

@interface JLComDetailViewController : UIViewController
@property(nonatomic,strong)id<ComDetailVCDelegate>delegate;
@end
