//
//  MessageTableViewCell.h
//  syb
//
//  Created by GX on 15/11/7.
//  Copyright © 2015年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageTableViewCell : UITableViewCell

@property (nonatomic,strong)MessageModel * messageModel;

//消息标题
@property (nonatomic,strong)UILabel * messageTitle;

//消息内容
@property (nonatomic,strong)UILabel * message_desc;

//消息时间
@property (nonatomic,strong)UILabel * messageTime;

@property (nonatomic,strong)UIView * cellBgView;

@property (nonatomic,strong)UIImageView * messageImage;

@property (nonatomic,strong)UILabel * lineLabel;



@property (nonatomic,strong)UIButton * messageButton;


@end
