//
//  JLMycomListCell.h
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseCell.h"
@class JLMyCommunityModel;
@protocol MyComListCellDelegate <NSObject>
-(void)joinCommunityBtn:(UIButton *)btn selectedWithData:(JLMyCommunityModel *)data;
@end

@interface JLMycomListCell : BaseCell
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (nonatomic,strong)id<MyComListCellDelegate>delegate;
-(void)fillRecommendCellWithObject:(id)object;
@end
