//
//  MessageTableViewCell.m
//  syb
//
//  Created by GX on 15/11/7.
//  Copyright © 2015年 GX. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

-(void)setMessageModel:(MessageModel *)messageModel
{
    _messageModel = messageModel;
    
    _messageTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,kMainBoundsWidth-50, 40)];
    _messageTitle.font = [UIFont systemFontOfSize:24];
    _messageTitle.text = messageModel.title;
    _messageTitle.textColor = [UIColor whiteColor];
    _messageTitle.textAlignment = NSTextAlignmentLeft;

    _messageTime = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kMainBoundsWidth-50, 20)];
    _messageTime.textColor = RGBACOLOR(155.0,155.0,155.0,1.0);
    _messageTime.font = [UIFont systemFontOfSize:14];
    _messageTime.text = messageModel.sendTime;
    _messageTime.textAlignment = NSTextAlignmentLeft;
    
    _messageImage = [[UIImageView alloc]init];
    _messageImage.frame = CGRectMake(20, 80, kMainBoundsWidth-70, 126*Proportion);
    
    NSString * messagleImageUrl = messageModel.imgUrl ;
    NSURL * MessageUlr = [NSURL URLWithString:messagleImageUrl];
    
    UIImage * nomessageImage = [UIImage imageNamed:@"nomessage"];
    [_messageImage sd_setImageWithURL:MessageUlr placeholderImage:nomessageImage];
    
    
    _message_desc = [[UILabel alloc]initWithFrame:CGRectMake(10, 126*Proportion+80, kMainBoundsWidth-50,60)];
    _message_desc.font = [UIFont systemFontOfSize:14];
    _message_desc.textColor = RGBACOLOR(155.0,155.0,155.0,1.0);
    _message_desc.text = messageModel.content;
    _message_desc.numberOfLines = 2;

    _lineLabel = [[UILabel alloc]init];
    _lineLabel.backgroundColor = [UIColor lightGrayColor];
    _lineLabel.frame  =CGRectMake(10, 140+126*Proportion, kMainBoundsWidth-50, .5);
    
    _messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _messageButton.frame = CGRectMake(10, 141+126*Proportion, kMainBoundsWidth-30, 40);
    [_messageButton setTitle:@"查看详情" forState:UIControlStateNormal];
    
    _messageButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _messageButton.imageEdgeInsets = UIEdgeInsetsMake(0,45, 0, 0);
    _messageButton.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    _messageButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    
 
    
    _cellBgView = [[UIView alloc]init];
    _cellBgView.backgroundColor = RGBACOLOR(45, 50, 54, 1);
    _cellBgView.frame = CGRectMake(15, 0, kMainBoundsWidth-30, 181+126*Proportion);
    _cellBgView.layer.cornerRadius = 3;
    
    [_cellBgView addSubview:self.messageTitle];
    [_cellBgView addSubview:self.messageTime];
    [_cellBgView addSubview:self.messageImage];
    [_cellBgView addSubview:self.message_desc];
    [_cellBgView addSubview:self.lineLabel];
    [_cellBgView addSubview:self.messageButton];
    
    [self.contentView addSubview:self.cellBgView];
}
@end
