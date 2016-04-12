//
//  PickerButton.h
//  Accompany
//
//  Created by GX on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickerButton;

@protocol PickerButtonDelegate <NSObject>

@optional
- (BOOL)pickerButton:(PickerButton *)button
      canSelectIndex:(NSInteger)index;

- (void)pickerButton:(PickerButton *)button
      didSelectIndex:(NSInteger)index
             andItem:(NSString *)item;


@end

@interface PickerButton : UIButton <UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *_itemList;
    NSInteger _selectIndex;
}

@property (nonatomic, weak)   id<PickerButtonDelegate> delegate;
@property (nonatomic, strong) NSArray   *itemList;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, copy)   NSString  *selectItem;
@property (nonatomic, assign) BOOL      isShowSelectItemOnButton;
//正常的背景颜色
@property (nonatomic,strong) UIColor *nomalBgColor;
//弹出键盘的时候的颜色
@property (nonatomic,strong) UIColor *activeBgColor;


//初始化方法，必须使用改方法初始化, list元素必须为NSString
- (id)initWithItemList:(NSArray *)list;

@end
