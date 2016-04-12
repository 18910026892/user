//
//  JLInputCell.h
//  Accompany
//
//  Created by 王园园 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseCell.h"
@class JLInputCell ;

typedef NS_ENUM(NSInteger, inputTextFieldType) {
    inputTextFieldLeft, //默认左
    inputTextFieldRight
};


@protocol inputCellDelegate <NSObject>

- (BOOL)inputCell:(JLInputCell *)cell TextFieldShouldBeginEditing:(UITextField *)textField;
- (BOOL)inputCell:(JLInputCell *)cell TextFieldShouldEndEditing:(UITextField *)textField;

@end

@interface JLInputCell : BaseCell<UITextFieldDelegate>

@property(nonatomic,strong)id<inputCellDelegate>delegate;

@property(nonatomic,assign)inputTextFieldType inputtextfieldType;
@property(nonatomic,assign)UIKeyboardType keyboardType;
-(void)fillCellWithTitle:(NSString *)title InputText:(NSString *)inputText placeHolder:(NSString *)placeStr;

@end
