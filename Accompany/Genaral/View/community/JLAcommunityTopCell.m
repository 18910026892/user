//
//  JLAcommunityTopCell.m
//  Accompany
//
//  Created by 王园园 on 16/2/17.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLAcommunityTopCell.h"
#import "UIImageView+WebCache.h"
#import "JLMyCommunityModel.h"
@interface JLAcommunityTopCell ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@property(nonatomic,strong)NSMutableArray *communityList;

@end

@implementation JLAcommunityTopCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _communityList = [NSMutableArray array];
}

-(void)fillCellWithObject:(NSMutableArray *)object
{
    _communityList = object;
    float i_whith = 100;
    [_communityList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JLMyCommunityModel *model = _communityList[idx];
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((i_whith+8)*idx+8, 0, i_whith, 90)];
        [img sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"liebiaotouxiang-"]];
        [_scroll addSubview:img];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageCilick:)];
        img.tag = idx;
        img.userInteractionEnabled = YES;
        [img addGestureRecognizer:tap];
    }];
    [_scroll setContentSize:CGSizeMake((i_whith+8)*_communityList.count, 0)];
}

+(CGFloat)rowHeightForObject:(id)object
{
    return 100;
}

-(void)imageCilick:(UIGestureRecognizer *)gesture
{
    if(_delegate){
        [_delegate acommunityTopCell:self TopImageViewClickWithData:_communityList[gesture.view.tag]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
