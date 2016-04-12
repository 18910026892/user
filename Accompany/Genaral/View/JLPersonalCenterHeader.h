//
//  JLPersonalCenterHeader.h
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLPostUserInfoModel.h"
@class JLPersonalCenterHeader ;

@protocol PersonalCenterHeadeViewDelegate <NSObject>

@optional

-(void)BackButtonClick:(UIButton*)Button;



@end
@interface JLPersonalCenterHeader : UIImageView

@property (weak, nonatomic) id <PersonalCenterHeadeViewDelegate> delegate;

@property (nonatomic,strong)JLPostUserInfoModel * UserModel;

@property (nonatomic,strong)UIButton * BackButton;





@end
