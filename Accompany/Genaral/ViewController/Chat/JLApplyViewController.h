//
//  JLApplyViewController.h
//  Accompany
//
//  Created by GongXin on 16/2/2.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ApplyStyleFriend            = 0,
    ApplyStyleGroupInvitation,
    ApplyStyleJoinGroup,
}ApplyStyle;

@interface JLApplyViewController : UITableViewController
{
    NSMutableArray *_dataSource;
}

@property (strong, nonatomic, readonly) NSMutableArray *dataSource;

+ (instancetype)viewController;

- (void)addNewApply:(NSDictionary *)dictionary;

- (void)loadDataSourceFromLocalDB;

- (void)clear;

@property (nonatomic,strong)UIButton * BackButton;
@end
