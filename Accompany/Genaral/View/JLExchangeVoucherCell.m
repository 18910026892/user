//
//  JLExchangeVoucherCell.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/21.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLExchangeVoucherCell.h"

@implementation JLExchangeVoucherCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.BGView];

    }
    return self;
}

- (void)setExchangeModel:(JLExchangeModel *)ExchangeModel
{
    _ExchangeModel = ExchangeModel;
    
    [self.contentView addSubview:self.BGView];

    NSString * overDue = [NSString stringWithFormat:@"有效期%@", ExchangeModel.endDate];
  
    if([overDue length]>10)
    {
        self.ValidityLabel.text = [overDue substringToIndex:10];
    }
    
    
    
    NSString * price = [NSString stringWithFormat:@"￥ %@元",ExchangeModel.price];
    self.PriceLabel.text = price;
    
}
-(UIView*)BGView
{
    if (!_BGView) {
        _BGView = [[UIView alloc]init];
        _BGView.frame = CGRectMake(15, 0, kMainBoundsWidth-30, 100);
        _BGView.backgroundColor = [UIColor whiteColor];
        _BGView.layer.cornerRadius = 3;
    
        
        [_BGView addSubview:self.TitleLabel];
        [_BGView addSubview:self.ValidityLabel];
        [_BGView addSubview:self.PriceLabel];
        [_BGView addSubview:self.BottomLabel];
        
    }
    return _BGView;
}

-(UILabel*)TitleLabel
{
    if (!_TitleLabel) {
        _TitleLabel = [[UILabel alloc]init];
        _TitleLabel.frame = CGRectMake(10, 10, 100, 20);
        _TitleLabel.backgroundColor = [UIColor clearColor];
        _TitleLabel.text = @"优惠券";
        _TitleLabel.font = [UIFont systemFontOfSize:16.0f];
        _TitleLabel.textAlignment = NSTextAlignmentLeft;
        _TitleLabel.textColor = RGBACOLOR(204, 36, 54, 1);
    }
    return _TitleLabel;
}
-(UILabel*)ValidityLabel
{
    if (!_ValidityLabel) {
        _ValidityLabel = [[UILabel alloc]init];
        _ValidityLabel.frame = CGRectMake(10, 30, kMainBoundsWidth/2, 20);
        _ValidityLabel.backgroundColor = [UIColor clearColor];
        
        _ValidityLabel.font = [UIFont systemFontOfSize:14.0f];
        _ValidityLabel.textAlignment = NSTextAlignmentLeft;
        _ValidityLabel.textColor = RGBACOLOR(204, 36, 54, 1);
    }
    return _ValidityLabel;
}

-(UILabel *)PriceLabel
{
    if (!_PriceLabel) {
        _PriceLabel = [[UILabel alloc]init];
        _PriceLabel.frame = CGRectMake(kMainBoundsWidth/2, 30, 120, 40);
        _PriceLabel.backgroundColor = [UIColor clearColor];
        _PriceLabel.font = [UIFont systemFontOfSize:30.0f];
        _PriceLabel.textAlignment = NSTextAlignmentLeft;
        _PriceLabel.textColor = RGBACOLOR(204, 36, 54, 1);
    }
    return _PriceLabel;
}
-(UILabel*)BottomLabel
{
    if (!_BottomLabel) {
        _BottomLabel = [[UILabel alloc]init];
        _BottomLabel.backgroundColor = RGBACOLOR(204, 36, 54, 1);
        _BottomLabel.frame = CGRectMake(0, 98, kMainBoundsWidth-30, 2);
    }
    return _BottomLabel;
}
@end
