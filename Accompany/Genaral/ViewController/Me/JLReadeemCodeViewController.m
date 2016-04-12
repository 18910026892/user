//
//  JLReadeemCodeViewController.m
//  Accompany
//
//  Created by 巩鑫 on 16/2/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLReadeemCodeViewController.h"

@implementation JLReadeemCodeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTabBarHide:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"优惠码"];
    [self setupViews];
    [self showBackButton:YES];
    self.enableIQKeyboardManager = YES;
    
}

-(void)setupViews
{
    [self.view addSubview:self.TextFieldBGView];
    [self.view addSubview:self.SureButton];
}
-(UIView*)TextFieldBGView
{
    if (!_TextFieldBGView) {
        _TextFieldBGView = [[UIView alloc]init];
        _TextFieldBGView.frame = CGRectMake(-1, 84, kMainBoundsWidth+2, 40);
        _TextFieldBGView.layer.borderWidth = 1;
        _TextFieldBGView.layer.borderColor = [UIColor lightGrayColor].CGColor;
     
        [_TextFieldBGView addSubview:self.CodeTextField];
    }
    return _TextFieldBGView;
}
-(CustomTextField*)CodeTextField
{
    if (!_CodeTextField) {
        _CodeTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(20,10, kMainBoundsWidth-40, 20)];
        _CodeTextField.textColor = [UIColor whiteColor];
        _CodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _CodeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _CodeTextField.keyboardType = UIKeyboardTypeDefault;
        _CodeTextField.returnKeyType = UIReturnKeyDefault;
        _CodeTextField.delegate = self;
        _CodeTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _CodeTextField.placeholder = @"请输入";
        
    }
    
    return _CodeTextField;

}


-(UIButton*)SureButton
{
    if (!_SureButton) {
        
        _SureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _SureButton.frame = CGRectMake(20, VIEW_MAXY(_TextFieldBGView)+30, kMainScreenWidth-40, 35);
        _SureButton.backgroundColor = [UIColor redColor];
        [_SureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_SureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _SureButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _SureButton.layer.cornerRadius = 17.5;
        [_SureButton addTarget:self action:@selector(SureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SureButton;
}
-(void)SureButtonClick:(UIButton*)sender
{
    _ReadeemCode = _CodeTextField.text;
    NSLog(@"*****%@",_ReadeemCode);
 
    [HDHud showHUDInView:self.view title:@"兑换中..."];
    userInfo = [UserInfo sharedUserInfo];
    NSString * token = userInfo.token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",_ReadeemCode,@"code", nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_exchangePromo pragma:postDict];
    
    
    request.successBlock = ^(id obj){
        
        [HDHud hideHUDInView:self.view];
        [HDHud showMessageInView:self.view title:@"兑换成功"];
     
        
    };
    request.failureDataBlock = ^(id error)
    {
        [HDHud hideHUDInView:self.view];
        NSString * message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    };
    
    request.failureBlock = ^(id obj){
        [HDHud hideHUDInView:self.view];
        [HDHud showNetWorkErrorInView:self.view];
    };
    
}
@end
