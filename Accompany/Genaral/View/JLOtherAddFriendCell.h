//
//  JLOtherAddFriendCell.h
//  Accompany
//
//  Created by GongXin on 16/3/14.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLPostUserInfoModel.h"
@class JLOtherAddFriendCell;
@protocol JLOtherAddFriendCellDelegate <NSObject>

-(void)postCell:(JLOtherAddFriendCell *)cell userImageTapWithData:(id)celldata;

-(void)addCell:(JLOtherAddFriendCell *)cell addFriendTapWithData:(id)celldata;
@end
@interface JLOtherAddFriendCell : UITableViewCell
@property(nonatomic,strong)id<JLOtherAddFriendCellDelegate>delegate;
@property (strong, nonatomic) UILabel *addLabel;

@property (nonatomic,strong)JLPostUserInfoModel * UserModel;

@property (nonatomic,strong)UIImageView * userImageView;

@property (nonatomic,strong)UILabel * NickNameLabel;

@end
