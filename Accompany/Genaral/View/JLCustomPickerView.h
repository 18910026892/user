//
//  JLCustomPickerView.h
//  Accompany
//
//  Created by 王园园 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseView.h"
@class JLCustomPickerView;
@protocol CustomPickerViewDelegate <NSObject>
@required
/**
 *  返回选择的pickerModel
 */
- (void)PickerView:(JLCustomPickerView*)view didSelectMenuPickerData:(id)selectData ;
@optional
- (void)PickerView:(JLCustomPickerView*)view didCancelMenuPickerData:(id)selectData;
@end

@interface JLCustomPickerView : BaseView

-(void)showInView:(UIView *)view;

@property (nonatomic,strong) UIView *backGroundView;

@property (nonatomic,weak) id<CustomPickerViewDelegate>delegate;
/**
 *  加载数据源
 *
 */
-(void)loadData:(NSMutableArray *)dataArray;

/**
 *  选中的model
 */
- (void)setSelectedMenuPickerModel:(id )selectedData;

@end
