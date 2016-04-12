//
//  LoginHeaderView.h
//  Accompany
//
//  Created by GongXin on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginHeaderView ;

@protocol LoginHeaderViewDelegate <NSObject>

@optional


-(void)EditButtonClick:(UIButton*)Button;
-(void)AttentionButtonClick:(UIButton*)Button;
-(void)FansButtonClick:(UIButton*)Button;
-(void)OrderButtonClick:(UIButton*)Button;
-(void)AccountButtonClick:(UIButton*)Button;


@end


@interface LoginHeaderView : UIImageView

@property (weak, nonatomic) id <LoginHeaderViewDelegate> delegate;


@property float nickNameLength;

@property (nonatomic,strong)UserInfo * userInfo;

@property(nonatomic,strong)UIButton * EditButton;

@property(nonatomic,strong)UILabel *  NickNameLabel;

@property(nonatomic,strong)UILabel * DescLabel;

@property (nonatomic,strong)UIImageView * SexImageView;

@property (nonatomic,strong)UIImageView * PhotoImageView;

@property (nonatomic,strong)UIButton * AttentionButton;

@property (nonatomic,strong)UIButton * FansButton;

@property (nonatomic,strong)UIButton * OrderButton;

@property (nonatomic,strong)UIButton * AccountButton;

@property(nonatomic,strong)UILabel * HorizontalLabel;

@property(nonatomic,strong)UILabel * VerticalLabel1,*VerticalLabel2;

@end
