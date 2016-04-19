//
//  ProtocolViewController.m
//  Accompany
//
//  Created by GX on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "ProtocolViewController.h"

@implementation ProtocolViewController

-(UITextView*)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainBoundsHeight-64)];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.backgroundColor= [UIColor clearColor];
        _textView.scrollEnabled = YES;//是否可以拖动
        _textView.editable = NO;//禁止编辑
        _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"教练随行会员章程" ofType:@"txt"];
        
        NSString * prtocol = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        _textView.text = [NSString stringWithFormat:@"%@",prtocol];
        
    }
    return _textView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"注册协议"];
    [self setupViews];
    [self showBackButton:YES];
    
}
-(void)setupViews
{

    [self.view addSubview:self.textView];
}

@end
