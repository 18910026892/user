//
//  JLOtherAddFriendCell.m
//  Accompany
//
//  Created by GongXin on 16/3/14.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLOtherAddFriendCell.h"

@implementation JLOtherAddFriendCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.textLabel.frame;
    rect.size.width -= 70;
    self.textLabel.frame = rect;
    
    rect = _addLabel.frame;
    rect.origin.y = (self.frame.size.height - 30) / 2;
    _addLabel.frame = rect;
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
    
    
    
    _addLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMainBoundsWidth - 60, 0, 50, 30)];
    _addLabel.backgroundColor = [UIColor redColor];
    _addLabel.textAlignment = NSTextAlignmentCenter;
    _addLabel.text = NSLocalizedString(@"add", @"Add");
    _addLabel.textColor = [UIColor whiteColor];
    _addLabel.font = [UIFont systemFontOfSize:14.0];
    _addLabel.layer.cornerRadius = 5;
    _addLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_addLabel];
    
}
@end
