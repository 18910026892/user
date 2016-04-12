//
//  JLSubjectListCell.m
//  Accompany
//
//  Created by 王园园 on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLSubjectListCell.h"

@interface JLSubjectListCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation JLSubjectListCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = _imgView.height/2;
    _imgView.layer.borderWidth = 0.8;
    _imgView.layer.borderColor = [UIColor grayColor].CGColor;
}

-(void)fillCellWithObject:(JLOrderModel*)object
{
    _OrderModel = object;
    
    [_imgView sd_setImageWithURL:[NSURL URLWithString:_OrderModel.grssUser.userPhoto] placeholderImage:[UIImage imageNamed:@"morentou-"]];
    
    _titleLable.text = object.name;
    
    _timeLable.text = [object.orderDate  substringToIndex:10];
    
}



+(CGFloat)rowHeightForObject:(id)object
{
    return 70.0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
