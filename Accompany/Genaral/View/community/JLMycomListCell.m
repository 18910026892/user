//
//  JLMycomListCell.m
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLMycomListCell.h"
#import "JLMyCommunityModel.h"
#import "UIImageView+WebCache.h"
@interface JLMycomListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *corverImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property(nonatomic,strong)JLMyCommunityModel *model;
- (IBAction)joinBtnClick:(id)sender;


@end

@implementation JLMycomListCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _corverImg.layer.masksToBounds = YES;
    _corverImg.layer.cornerRadius = _corverImg.height/2;
}

+(CGFloat)rowHeightForObject:(id)object
{
    return 65;
}
-(void)fillCellWithObject:(id)object
{
    _model = (JLMyCommunityModel *)object;
    [_corverImg sd_setImageWithURL:[NSURL URLWithString:_model.imageUrl] placeholderImage:[UIImage imageNamed:@"morentou-"]];
    _nameLable.text = _model.name;
    NSString *desStr = [NSString stringWithFormat:@"话题%@    居民%@",_model.topicTotal,_model.residentTotal];
    _desLable.text = desStr;
    
    if(_model.isJoin.integerValue==0){
        [_attentionBtn setImage:[UIImage imageNamed:@"attention_jia"] forState:UIControlStateNormal];
    }else{
        [_attentionBtn setImage:[UIImage imageNamed:@"attention_jian"] forState:UIControlStateNormal];
    }
}

-(void)fillRecommendCellWithObject:(id)object;
{
    _corverImg.image = [UIImage imageNamed:@"recoment"];
    _nameLable.text = @"推荐社区";
    _topConstraint.constant = 15;
    _desLable.hidden = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)joinBtnClick:(id)sender {
    if(_delegate){
        [_delegate joinCommunityBtn:sender selectedWithData:_model];
    }
}
@end
