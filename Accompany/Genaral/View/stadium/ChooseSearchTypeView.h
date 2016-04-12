//
//  ChooseSearchTypeView.h
//  syb
//
//  Created by GX on 15/10/21.
//  Copyright © 2015年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
@interface ChooseSearchTypeView : UIView<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView * triangleView;
+ (void)showOnWindow;
+ (void)hide;
@end
