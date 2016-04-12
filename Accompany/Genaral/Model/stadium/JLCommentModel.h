//
//  JLCommentModel.h
//  Accompany
//
//  Created by GongXin on 16/3/30.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLCommentModel : NSObject
@property(nonatomic,copy)NSString * coachID;
@property(nonatomic,copy)NSString * comment;
@property(nonatomic,copy)NSString * createTime;
@property(nonatomic,strong)NSDictionary * grssUser;
@property(nonatomic,strong)NSString * id;
@property(nonatomic,copy)NSString * state;
@property(nonatomic,copy)NSString * userId;

@end
