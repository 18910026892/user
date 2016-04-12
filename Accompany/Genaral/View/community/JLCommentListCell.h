//
//  JLCommentListCell.h
//  Accompany
//
//  Created by 王园园 on 16/2/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseCell.h"
#import "JLCommentModel.h"
typedef NS_ENUM(NSUInteger,CommentType){
    user = 0,  //社区
    coach= 1, //教练详情
   
};
@interface JLCommentListCell : BaseCell
@property(nonatomic,assign)CommentType type;

@property (nonatomic,strong)JLCommentModel * commentModel;

+(CGFloat)RowHeightForModel:(JLCommentModel*)commentModel;
@end
