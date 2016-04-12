//
//  JLCommentListCell.m
//  Accompany
//
//  Created by 王园园 on 16/2/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCommentListCell.h"
#import "JLPostCommentListModel.h"
#import "Helper+Date.h"
#import "UIImageView+WebCache.h"
@interface JLCommentListCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *contentLable;


@end

@implementation JLCommentListCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    _userImg.layer.cornerRadius = _userImg.width/2;
    _userImg.layer.masksToBounds = YES;
}

-(void)fillCellWithObject:(id)object
{
    JLPostCommentListModel *model = (JLPostCommentListModel *)object;

        _nameLable.text = model.remarkName;
        NSString *cotent = model.content;
        if(model.replyName.length>0){
            cotent = [NSString stringWithFormat:@"@%@:%@",model.replyName,model.content];
        }
        _contentLable.text = cotent;
        NSDate *date = [Helper dateValueWithString:model.remarkDate ByFormatter:@"yyyy-MM-dd HH:mm:ss"];
        _timeLable.text = [Helper DescriptionWithDate:date];
        [_userImg sd_setImageWithURL:[NSURL URLWithString:model.remarkUserImg] placeholderImage:[UIImage imageNamed:@"touxiang-"]];
        

    
}
-(void)setCommentModel:(JLCommentModel *)commentModel

{
     JLCommentModel * model = commentModel;
    _nameLable.text = [model.grssUser valueForKey:@"nikeName"];
    NSString *cotent = model.comment;
    _contentLable.text = cotent;
    NSDate *date = [Helper dateValueWithString:model.createTime ByFormatter:@"yyyy-MM-dd HH:mm:ss"];
    _timeLable.text = [Helper DescriptionWithDate:date];
    
    NSString * url = [model.grssUser valueForKey:@"userPhoto"];
    [_userImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"touxiang-"]];
}

+(CGFloat)rowHeightForObject:(id)object
{
    
     JLPostCommentListModel *model = (JLPostCommentListModel *)object;

    NSString *cotent = model.content;
        
        if(model.replyName.length>0){
            cotent = [NSString stringWithFormat:@"@%@:%@",model.replyName,model.content];
        }
        
 
    float introlHeight = [Helper heightForLabelWithString:cotent withFontSize:14.0 withWidth:kMainBoundsWidth-20 withHeight:1000];
    float addHeight = introlHeight>17?introlHeight-17:0;
    return 65+addHeight;

   
}

+(CGFloat)RowHeightForModel:(JLCommentModel*)commentModel;
{
    JLCommentModel * model = commentModel;
    
    NSString *cotent = model.comment;
    
    float introlHeight = [Helper heightForLabelWithString:cotent withFontSize:14.0 withWidth:kMainBoundsWidth-20 withHeight:1000];
    float addHeight = introlHeight>17?introlHeight-17:0;
    return 65+addHeight;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
