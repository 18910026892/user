//
//  JLExchangeVoucherCell.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/21.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLExchangeModel.h"
@interface JLExchangeVoucherCell : UITableViewCell


@property (nonatomic,strong)JLExchangeModel * ExchangeModel;

@property (nonatomic,strong)UIView * BGView;

@property (nonatomic,strong)UILabel * TitleLabel;

@property (nonatomic,strong)UILabel * ValidityLabel;

@property (nonatomic,strong)UILabel * PriceLabel;

@property (nonatomic,strong)UILabel * OverdueLabel;

@property (nonatomic,strong)UILabel * BottomLabel;

@end
