//
//  JLOtherAddFriendCell.h
//  Accompany
//
//  Created by GongXin on 16/3/14.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLPostUserInfoModel.h"
@interface JLOtherAddFriendCell : UITableViewCell

@property (strong, nonatomic) UILabel *addLabel;

@property (nonatomic,strong)JLPostUserInfoModel * UserModel;

@property (nonatomic,strong)UIImageView * userImageView;

@property (nonatomic,strong)UILabel * NickNameLabel;

@end
