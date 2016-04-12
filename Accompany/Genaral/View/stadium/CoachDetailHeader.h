//
//  CoachDetailHeader.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/7.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CoachDetailHeader ;

@protocol CoachDetailHeaderDelegate <NSObject>

@optional

-(void)BackButtonClick:(UIButton*)Button;

@end


@interface CoachDetailHeader : UIImageView

@property (weak, nonatomic) id <CoachDetailHeaderDelegate> delegate;

@property (nonatomic,strong)UIButton * BackButton;





@end
