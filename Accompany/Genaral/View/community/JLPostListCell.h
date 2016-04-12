//
//  JLPostListCell.h
//  Accompany
//
//  Created by 王园园 on 16/2/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseCell.h"
@class JLPostListCell;

@protocol PostListCellDelegate <NSObject>
@optional
-(void)postCellzanBtn:(UIButton *)zanBtn clickedWithData:(id)celldata;
-(void)postCellshareBtn:(UIButton *)shareBtn clickedWithData:(id)celldata;
-(void)postCellcommentBtn:(UIButton *)commentBtn clickedWithData:(id)celldata;
-(void)postCellattentionBtn:(UIButton *)commentBtn clickedWithData:(id)celldata;
-(void)postCelldeleteBtn:(UIButton *)commentBtn clickedWithData:(id)celldata;
-(void)postCell:(JLPostListCell *)cell userImageTapWithData:(id)celldata;

@end


@interface JLPostListCell : BaseCell

@property(nonatomic,strong)id<PostListCellDelegate>delegate;
-(void)fillPostDetailCellWithObject:(id)object admireListArr:(NSArray *)admireArr;

@end
