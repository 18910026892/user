//
//  JLPostDetailViewController.h
//  Accompany
//
//  Created by 王园园 on 16/2/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
@class JLPostListModel;

@interface JLPostDetailViewController : BaseViewController

@property(nonatomic,strong) JLPostListModel *postInfoModel;

@property BOOL isCommentSate;

@end
