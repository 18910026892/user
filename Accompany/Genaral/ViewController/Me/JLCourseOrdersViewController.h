//
//  JLCourseOrdersViewController.h
//  Accompany
//
//  Created by GongXin on 16/3/9.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import <BEMSimpleLineGraphView.h>
@interface JLCourseOrdersViewController : BaseViewController
<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>
{
    UserInfo * userInfo;
}
@property (strong, nonatomic) BEMSimpleLineGraphView *myGraph;

@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;

@property (strong, nonatomic)  UILabel *labelValues;
@property (strong, nonatomic)  UILabel *labelDates;
@end
