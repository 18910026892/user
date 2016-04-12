//
//  JLAttentionCell.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/26.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLAttentionCell.h"

@implementation JLAttentionCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

- (void)setUserModel:(JLPostUserInfoModel*)UserModel

{
    _UserModel = UserModel;
    
    NSString * imageUrl = UserModel.userPhoto;
    
    
    //头像
    _userImageView = [[UIImageView alloc]init];
    _userImageView.frame = CGRectMake(10, 7.5, 35, 35);
    NSString * tianChongImage = @"otherphoto";
    [_userImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:tianChongImage]];
    
    [self.contentView addSubview:_userImageView];
    
    
    //昵称
    
    _NickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 15, kMainBoundsWidth/2, 20)];
    _NickNameLabel.backgroundColor = [UIColor clearColor];
    _NickNameLabel.text = UserModel.nikeName;
    _NickNameLabel.textColor = [UIColor whiteColor];
    _NickNameLabel.font = [UIFont systemFontOfSize:16];
    _NickNameLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.contentView addSubview:_NickNameLabel];
    
}
@end
