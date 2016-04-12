//
//  LoginHeaderView.m
//  Accompany
//
//  Created by GongXin on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "LoginHeaderView.h"

@implementation LoginHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
        [self addSubview:self.EditButton];
        [self addSubview:self.NickNameLabel];
        [self addSubview:self.DescLabel];
        [self addSubview:self.SexImageView];
        [self addSubview:self.PhotoImageView];
        [self addSubview:self.AttentionButton];
        [self addSubview:self.FansButton];
        [self addSubview:self.OrderButton];
        [self addSubview:self.AccountButton];
        [self addSubview:self.HorizontalLabel];
        [self addSubview:self.VerticalLabel1];
        [self addSubview:self.VerticalLabel2];
        
        
    }
    return self;
}

-(UserInfo*)userInfo
{
    if (!_userInfo) {
        _userInfo = [UserInfo sharedUserInfo];
    }
    return _userInfo;
}


//昵称标签
-(UILabel*)NickNameLabel
{

    NSString * nickName = self.userInfo.nikeName;
    

    if (!_NickNameLabel) {
        _NickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainBoundsWidth/4, 60, kMainBoundsWidth/2, 20*Proportion)];
        _NickNameLabel.backgroundColor = [UIColor clearColor];
        _NickNameLabel.text = nickName;
        _NickNameLabel.textColor = [UIColor whiteColor];
        _NickNameLabel.font = [UIFont systemFontOfSize:16];
        _NickNameLabel.textAlignment = NSTextAlignmentCenter;
      
        CGSize titleSize = [nickName sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 20*Proportion)];
        
        _nickNameLength = titleSize.width;
        
 
    }
    return _NickNameLabel;
}

//个人简介
-(UILabel*)DescLabel
{
    if (!_DescLabel) {
        _DescLabel = [[UILabel alloc]initWithFrame:CGRectMake(kMainBoundsWidth/8, 60+20*Proportion, kMainBoundsWidth*3/4, 20*Proportion)];
        _DescLabel.backgroundColor = [UIColor clearColor];
        _DescLabel.text = self.userInfo.userDesc;
        _DescLabel.textColor = [UIColor whiteColor];
        _DescLabel.font = [UIFont systemFontOfSize:14];
        _DescLabel.textAlignment = NSTextAlignmentCenter;
       
        
    }
    return _DescLabel;
}

-(UIImageView*)SexImageView

{

    
    if (!_SexImageView) {
        _SexImageView = [[UIImageView alloc]init];
        _SexImageView.frame  = CGRectMake(kMainBoundsWidth/2+_nickNameLength/2, 60, 12*Proportion, 12*Proportion);
        _SexImageView.backgroundColor = GXRandomColor;
        _SexImageView.layer.cornerRadius = 6*Proportion;
        
        NSString * userSex = [NSString stringWithFormat:@"%@",self.userInfo.userSex];
        if ([userSex isEqualToString:@"1"]) {
          
              [_SexImageView setImage:[UIImage imageNamed:@"man"]];
        }else if([userSex isEqualToString:@"2"])
        {
            [_SexImageView setImage:[UIImage imageNamed:@"woman"]];
        }else
        {
            _SexImageView.hidden = YES;
        }
        
    }
    return _SexImageView;
}


//编辑按钮
-(UIButton*)EditButton
{
    if (!_EditButton) {
        _EditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _EditButton.frame = CGRectMake(kMainBoundsWidth - 70, 20, 64, 44);
        _EditButton.backgroundColor = [UIColor clearColor];
        [_EditButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_EditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _EditButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_EditButton addTarget:self action:@selector(EditButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return _EditButton;
}
-(void)EditButtonClick:(UIButton*)sender
{
    // 响应代理方法
    if ([self.delegate respondsToSelector:@selector(EditButtonClick:)]) {
        
        [self.delegate EditButtonClick:sender];
    }

}

-(UIImageView*)PhotoImageView
{
    if (!_PhotoImageView) {
        _PhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kMainBoundsWidth/2-30*Proportion, 64+40*Proportion, 60*Proportion, 60*Proportion)];
        _PhotoImageView.layer.borderColor = [UIColor grayColor].CGColor;
        _PhotoImageView.layer.borderWidth = 0.5;
        _PhotoImageView.layer.masksToBounds = YES;
        _PhotoImageView.layer.cornerRadius = 30 * Proportion;
        
        NSString * imageUrl = self.userInfo.userPhoto;
        NSString * tianChongImage = @"userPhoto";
        
        [_PhotoImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:tianChongImage]];
    }
    return _PhotoImageView;
}


//关注数量
-(UIButton*)AttentionButton
{
    if (!_AttentionButton) {
        
        
        NSString * attentionTitle;
        if (!_userInfo.followCount) {
            attentionTitle = @"关注数";
        }else
        {
            attentionTitle  = [NSString stringWithFormat:@"关注 %@",_userInfo.followCount];
        }
        
        
        _AttentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _AttentionButton.frame = CGRectMake(0,100*Proportion+64,kMainBoundsWidth/2-20, 40*Proportion);
        [_AttentionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
        _AttentionButton.backgroundColor = [UIColor clearColor];
        [_AttentionButton setTitle:attentionTitle forState:UIControlStateNormal];
        [_AttentionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _AttentionButton.titleLabel.textAlignment = NSTextAlignmentRight;
        
        _AttentionButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [_AttentionButton addTarget:self action:@selector(AttentionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _AttentionButton;
}

-(void)AttentionButtonClick:(UIButton*)sender
{
    // 响应代理方法
    if ([self.delegate respondsToSelector:@selector(AttentionButtonClick:)]) {
        
        [self.delegate AttentionButtonClick:sender];
    }
    
}

//粉丝按钮
-(UIButton*)FansButton
{
    if (!_FansButton) {
        
        NSString * FansTitle;
        if (!_userInfo.fansCount) {
            FansTitle = @"粉丝数";
        }else
        {
            FansTitle  = [NSString stringWithFormat:@"粉丝数 %@",_userInfo.fansCount];
        }
      
        
        _FansButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _FansButton.frame = CGRectMake(kMainBoundsWidth/2+20,100*Proportion+64,kMainBoundsWidth/2-20, 40*Proportion);
         [_FansButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0, 0, 60)];
        _FansButton.backgroundColor = [UIColor clearColor];
        [_FansButton setTitle:FansTitle forState:UIControlStateNormal];
        [_FansButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _FansButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _FansButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [_FansButton addTarget:self action:@selector(FansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _FansButton;
}

-(void)FansButtonClick:(UIButton*)sender
{
    // 响应代理方法
    if ([self.delegate respondsToSelector:@selector(FansButtonClick:)]) {
        
        [self.delegate FansButtonClick:sender];
    }
    
}

//水平线
-(UILabel*)HorizontalLabel
{
    if (!_HorizontalLabel) {
        _HorizontalLabel = [[UILabel alloc]init];
        _HorizontalLabel.frame = CGRectMake(0,64 +140*Proportion, kMainBoundsWidth, .5);
        _HorizontalLabel.backgroundColor = RGBACOLOR(150,150,150, 1);
        
    }
    return _HorizontalLabel;
}
//竖直线
-(UILabel *)VerticalLabel1
{
    if (!_VerticalLabel1) {
        _VerticalLabel1 = [[UILabel alloc]init];
        _VerticalLabel1.frame = CGRectMake(kMainBoundsWidth/2, 64+115*Proportion, .5, 10*Proportion);
        _VerticalLabel1.backgroundColor = RGBACOLOR(150,150,150, 1);
    }
    return _VerticalLabel1;
}


//竖直线
-(UILabel *)VerticalLabel2
{
    if (!_VerticalLabel2) {
        _VerticalLabel2 = [[UILabel alloc]init];
        _VerticalLabel2.frame = CGRectMake(kMainBoundsWidth/2, 64+150*Proportion, .5, 20*Proportion);
        _VerticalLabel2.backgroundColor = RGBACOLOR(150,150,150, 1);
    }
    return _VerticalLabel2;
}


//课程订单按钮
-(UIButton*)OrderButton
{
    if (!_OrderButton) {
        _OrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _OrderButton.frame = CGRectMake(0,140*Proportion+64,kMainBoundsWidth/2, 40*Proportion);
        _OrderButton.backgroundColor = [UIColor clearColor];
        [_OrderButton setTitle:@"课程订单" forState:UIControlStateNormal];
        [_OrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _OrderButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [_OrderButton addTarget:self action:@selector(OrderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _OrderButton;
}
-(void)OrderButtonClick:(UIButton*)sender
{
    // 响应代理方法
    if ([self.delegate respondsToSelector:@selector(OrderButtonClick:)]) {
        
        [self.delegate OrderButtonClick:sender];
    }
    
}
//我得账户
-(UIButton*)AccountButton
{
    if (!_AccountButton) {
        _AccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _AccountButton.frame = CGRectMake(kMainBoundsWidth/2,140*Proportion+64,kMainBoundsWidth/2, 40*Proportion);
        _AccountButton.backgroundColor = [UIColor clearColor];
        [_AccountButton setTitle:@"我的账户" forState:UIControlStateNormal];
        [_AccountButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _AccountButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        [_AccountButton addTarget:self action:@selector(AccountButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _AccountButton;
}
-(void)AccountButtonClick:(UIButton*)sender
{
    // 响应代理方法
    if ([self.delegate respondsToSelector:@selector(AccountButtonClick:)]) {
        
        [self.delegate AccountButtonClick:sender];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
