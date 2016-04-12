//
//  JLAcommunityTopCell.h
//  Accompany
//
//  Created by 王园园 on 16/2/17.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseCell.h"

@class JLAcommunityTopCell;
@protocol AcommunityTopCellDelegate <NSObject>

-(void)acommunityTopCell :(JLAcommunityTopCell *)cell TopImageViewClickWithData:(id)data;
@end

@interface JLAcommunityTopCell : BaseCell

@property(nonatomic,strong)id<AcommunityTopCellDelegate>delegate;

@end
