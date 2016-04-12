//
//  JLVideoViewListViewController.h
//  Accompany
//
//  Created by 王园园 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "JLVideoModel.h"

@interface JLVideoViewListViewController : BaseViewController

/*
 * 处理课程订单
 */
@property(nonatomic,assign)BOOL isHandelOrder;
@property(nonatomic,assign)NSInteger listType;
@property(nonatomic,strong)JLVideoModel *videoModel;
@property(nonatomic,copy)NSString *categoryName;

@end
