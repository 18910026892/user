//
//  JLVideoViewController.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

@interface JLVideoViewController : BaseViewController

/*
 * 处理课程订单
 */
@property(nonatomic,assign)BOOL isHandelOrder;
@property(nonatomic,copy)NSString *oderId;
@property(nonatomic,assign)BOOL isFirstEnter;
@end
