//
//  JLVideoCollectCell.h
//  Accompany
//
//  Created by 王园园 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLVideoItemModel;
@class JLVideoCollectCell;

@protocol JLVideoCollectCellDelegate <NSObject>

-(void)videoCell:(JLVideoCollectCell *)cell selectVideoModel:(JLVideoItemModel *)model;

@end

@interface JLVideoCollectCell : UICollectionViewCell

@property(nonatomic,strong)id<JLVideoCollectCellDelegate>delegate;

@property(nonatomic,assign)BOOL isHandel;
@property(nonatomic,strong)NSMutableArray *selectItem;

- (void)fillCellWithObject:(id)object;

@end
