//
//  JLAddFrendListCell.h
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseCell.h"

@class JLAddFrendListCell;
@class EMBuddy;

@protocol AddFrendListCellDelegate <NSObject>

-(void)addFrendListCellBtnSelectData:(EMBuddy *)EMBuddyModel WithState:(BOOL)isAdd;

@end

@interface JLAddFrendListCell : BaseCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property(nonatomic,strong)id<AddFrendListCellDelegate>delegate;
@end
