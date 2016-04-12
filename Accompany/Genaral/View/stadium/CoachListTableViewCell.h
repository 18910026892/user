//
//  CoachListTableViewCell.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/6.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocahModel.h"
#import "DJQRateView.h"
@interface CoachListTableViewCell : UITableViewCell

@property(nonatomic,strong)CocahModel * cocahModel;

@property(nonatomic,strong)UIImageView * cocahImageView;

@property(nonatomic,strong)UILabel * cocahNameLabel;

@property(nonatomic,strong)DJQRateView * StarView;

@property(nonatomic,strong)UILabel * cocahInfoLabel;

@property(nonatomic,strong)UILabel * cocahPriceLabel;

@property(nonatomic,strong)UILabel * venueNameLabel;



@end
