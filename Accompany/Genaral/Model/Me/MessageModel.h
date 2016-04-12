//
//  MessageModel.h
//  syb
//
//  Created by GX on 15/11/7.
//  Copyright © 2015年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

//消息名称
@property (nonatomic,copy) NSString * title;

//消息类型
@property (nonatomic,copy) NSString * linkUrl;

//消息时间
@property (nonatomic,copy) NSString * sendTime;

//消息ID

@property (nonatomic,copy) NSString * id;

//消息描述
@property (nonatomic,copy) NSString * content;


//消息图片
@property (nonatomic,copy) NSString * imgUrl;


@end
