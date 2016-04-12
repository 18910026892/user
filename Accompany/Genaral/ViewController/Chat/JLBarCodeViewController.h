//
//  JLBarCodeViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/15.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import <ZBarReaderView.h>
@interface JLBarCodeViewController : BaseViewController
<ZBarReaderViewDelegate>

@property (nonatomic,strong)ZBarReaderView * readView;

//背景视图
@property (nonatomic,strong)UIView * colView;

//返回上个页面的按钮
@property (nonatomic,strong)UIButton * backButton;


//提示用户扫码的标签
@property (nonatomic,strong)UILabel * alertLabel;

//扫描页面中心扫描区域
@property (nonatomic,strong)UIImageView * centerImageView;

//扫描页面上下扫描的绿色的线
@property (nonatomic,strong)UIImageView * lineView;

//闪光灯
@property (nonatomic,strong)UIButton * lightButton;

@property int num;
@property BOOL upOrdown;
@property NSTimer * timer;

//扫描结果
@property (nonatomic,strong)NSString * result;
@end

