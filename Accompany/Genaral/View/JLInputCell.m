//
//  JLInputCell.m
//  Accompany
//
//  Created by 王园园 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLInputCell.h"

@interface JLInputCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end
@implementation JLInputCell

- (void)awakeFromNib {
    // Initialization code
    _inputTextField.delegate = self;
    self.backgroundColor = [UIColor clearColor];
}

+(CGFloat)rowHeightForObject:(id)object
{
    return 44.0;
}

-(void)fillCellWithTitle:(NSString *)title InputText:(NSString *)inputText placeHolder:(NSString *)placeStr;
{

    if(_inputtextfieldType==inputTextFieldRight){
        _inputTextField.textAlignment = NSTextAlignmentRight;
    }
    _inputTextField.keyboardType = _keyboardType;
    _titleLable.text = title;
    _inputTextField.text = inputText;
    _inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeStr attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    _inputTextField.textAlignment = NSTextAlignmentRight;
    _inputTextField.font = [UIFont systemFontOfSize:14];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    if([_delegate respondsToSelector:@selector(inputCell:TextFieldShouldBeginEditing:)])
    {
        [_delegate inputCell:self TextFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    if([_delegate respondsToSelector:@selector(inputCell:TextFieldShouldEndEditing:)])
    {
        [_delegate inputCell:self TextFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
