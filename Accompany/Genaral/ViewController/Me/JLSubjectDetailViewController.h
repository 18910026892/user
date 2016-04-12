//
//  JLSubjectDetailViewController.h
//  Accompany
//
//  Created by 王园园 on 16/3/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JLSubjectDetailViewController;
@class JLOrderModel;
@protocol SubjectDetailVCDelegate <NSObject>

-(void)subjectDetailVC:(JLSubjectDetailViewController *)viewcontroller CellData:(JLOrderModel *)model;

@end

@interface JLSubjectDetailViewController : UIViewController
/*
 * 待处理NO 已处理YES
 */
@property(nonatomic,assign)BOOL isHandelType;
@property(nonatomic,weak)id<SubjectDetailVCDelegate>delegate;
@end
