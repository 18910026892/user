//
//  JLVideoCollectCell.m
//  Accompany
//
//  Created by 王园园 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLVideoCollectCell.h"
#import "JLVideoItemModel.h"
#import "UIImageView+WebCache.h"
@interface JLVideoCollectCell()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property(nonatomic,strong)JLVideoItemModel *itemModel;
- (IBAction)selectBtnClick:(id)sender;

@end

@implementation JLVideoCollectCell

- (void)awakeFromNib {
    // Initialization code
    [_selectBtn setImage:[UIImage imageNamed:@"select_gray"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"select_red"] forState:UIControlStateSelected];
}


- (void)fillCellWithObject:(id)object;
{
    _itemModel = (JLVideoItemModel *)object;
    _titleView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
    _titleLable.text = _itemModel.name;
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:_itemModel.imgUrl] placeholderImage:nil];
    if(_isHandel){
        _selectBtn.hidden = NO;
    }else _selectBtn.hidden = YES;
    _selectBtn.selected = NO;
    [_selectItem enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JLVideoItemModel *model = (JLVideoItemModel *)object;
        if([model.videoId isEqualToString:_itemModel.videoId]){
            _selectBtn.selected = YES;
        }
    }];
}
- (IBAction)selectBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if(_delegate){
        [_delegate videoCell:self selectVideoModel:_itemModel];
    }
}
@end
