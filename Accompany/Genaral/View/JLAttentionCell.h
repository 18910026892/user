//
//  JLAttentionCell.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/26.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLPostUserInfoModel.h"
@interface JLAttentionCell : UITableViewCell
@property (nonatomic,strong)JLPostUserInfoModel * UserModel;

@property (nonatomic,strong)UIImageView * userImageView;

@property (nonatomic,strong)UILabel * NickNameLabel;
@end
