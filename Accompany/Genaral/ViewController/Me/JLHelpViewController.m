//
//  JLHelpViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLHelpViewController.h"

@interface JLHelpViewController ()

@end

@implementation JLHelpViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"帮助与反馈"];
    [self setupDatas];
    [self setupViews];
    [self showBackButton:YES];
    
    
}
-(void)setupDatas
{
}
-(void)setupViews
{

    [self.view addSubview:self.BGView];
    [self.view addSubview:self.SubmitButton];
    
}
-(UIView*)BGView
{
    if (!_BGView) {
        _BGView = [[UIView alloc]init];
        _BGView.frame = CGRectMake(0, 84, kMainScreenWidth, 120);
        _BGView.backgroundColor = RGBACOLOR(45, 50, 54, 1);
        [_BGView addSubview:self.textView];
        [_BGView addSubview:self.label1];
        [_BGView addSubview:self.label2];
    }
    return _BGView;
}


-(UITextView*)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, kMainBoundsWidth-40, 120)];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.scrollEnabled = NO;
        _textView.editable = YES;
        _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    
    return _textView;
}

-(UILabel*)label1
{
    if(!_label1)
    {
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(kMainBoundsWidth-120, VIEW_MAXY(self.textView)-21, 100, 20)];
        _label1.text = [NSString stringWithFormat:@"0/100字"];
        _label1.textColor = [UIColor whiteColor];
        _label1.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
        _label1.textAlignment = NSTextAlignmentRight;
        _label1.backgroundColor = [UIColor clearColor];

    }
    
    return _label1;
}

-(UILabel*)label2
{
    if (!_label2) {
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake(25,5, kMainBoundsWidth-50, 20)];
        _label2.text = @"请输入您的意见，我们将不断优化体验";
        _label2.textColor = [UIColor grayColor];
        _label2.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _label2.textAlignment = NSTextAlignmentLeft;
        _label2.backgroundColor = [UIColor clearColor];
    }
    
    return _label2;
}
-(UIButton*)SubmitButton
{
    if (!_SubmitButton) {
        
        _SubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _SubmitButton.frame = CGRectMake(20,235, kMainScreenWidth-40, 35);
        _SubmitButton.backgroundColor = [UIColor redColor];
        [_SubmitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_SubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _SubmitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _SubmitButton.layer.cornerRadius = 17.5;
        [_SubmitButton addTarget:self action:@selector(SubmitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SubmitButton;
}

-(void)SubmitButtonClick:(UIButton*)sender
{
      // token,comment
    
    NSString * comment = _textView.text;
    if ([comment length]==0) {
        [HDHud showMessageInView:self.view title:@"您还没有输入任何意见"];
    }else
    {
         [HDHud showHUDInView:self.view title:@"正在提交..."];
        userInfo = [UserInfo sharedUserInfo];
        NSString * token = userInfo.token;
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",comment,@"comment", nil];
        
        HttpRequest * request = [[HttpRequest alloc]init];
        [request RequestDataWithUrl:URL_feedback pragma:postDict];
        
        
        request.successBlock = ^(id obj){
            
            [HDHud hideHUDInView:self.view];
            NSLog(@"%@",obj);
         
            [HDHud showMessageInView:self.view title:@"提交成功"];
            [self performSelector:@selector(backMine) withObject:nil afterDelay:1.5];
                
       
            
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
    
   
    
    
}

-(void)backMine
{
    NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:index-1] animated:YES];
}

-(BOOL)textView:(UITextView *)textview shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return YES;
    }
    if([[_textView text] length]>100){
        return NO;
    }
    //判断是否为删除字符，如果为删除则让执行
    char c=[text UTF8String][0];
    
    if (c=='\000') {
        _count = [[_textView text] length]-1;
        if(_count ==-1){
            _count =0;
        }
        if(_count ==0)
        {
            _label2.hidden=NO;//隐藏文字
        }else{
            _label2.hidden=YES;
        }
        _label1.text = [NSString stringWithFormat:@"%ld/100字",(long)_count];
        return YES;
    }
    if([[_textView text] length]==100) {
        if(![text isEqualToString:@"\b"])
            return NO;
    }
    _count =[[_textView text] length]-[text length]+2;
    if(_count ==0)
    {
        _label2.hidden=NO;//隐藏文字
    }else{
        _label2.hidden=YES;
    }
    _label1.text = [NSString stringWithFormat:@"%ld/100字",(long)_count];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView;
{
    _count = [[_textView text] length];
    _label1.text = [NSString stringWithFormat:@"%ld/100字",(long)_count];
}

//去掉输入的前后空格
-(NSString *)removespace:(UITextField *)textfield {
    return [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
