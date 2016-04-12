//
//  JLAddFrendListCell.m
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLAddFrendListCell.h"
#import "EaseUserModel.h"
#import "NickNameAndHeadImage.h"
#import "EMBuddy.h"
@interface JLAddFrendListCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;

@property (nonatomic,strong)EMBuddy *model;
- (IBAction)selectBtnClick:(id)sender;

@end

@implementation JLAddFrendListCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [_selectButton setImage:[UIImage imageNamed:@"select_gray"] forState:UIControlStateNormal];
    [_selectButton setImage:[UIImage imageNamed:@"select_red"] forState:UIControlStateSelected];
    [_selectButton setImageEdgeInsets:UIEdgeInsetsMake(15, _selectButton.width-25, 15, 0)];
    _userImg.layer.cornerRadius = _userImg.height/2;
    _userImg.layer.masksToBounds = YES;
}

+(CGFloat)rowHeightForObject:(id)object
{
    return 55;
}
-(void)fillCellWithObject:(id)object
{
    _model = (EMBuddy *)object;
    NSString *name = [[NickNameAndHeadImage shareInstance]getNicknameByUserName:_model.username];
    
    NSString *imgUrl = [[NickNameAndHeadImage shareInstance]getUserPhotoByUserName:_model.username];
    
    [_userImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"morentou-"]];
    _nameLable.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectBtnClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if(_delegate){
        [_delegate addFrendListCellBtnSelectData:_model WithState:btn.selected];
    }
}
@end
