//
//  JLBuyCourseViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/21.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"
#import "CocahModel.h"
#import "JLExchangeModel.h"
#import <WXApi.h>
@interface JLBuyCourseViewController : BaseViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UserInfo * userInfo;
}

@property (nonatomic,strong)CocahModel * coachModel;

@property (nonatomic,strong)UITableView * TableView;

@property (nonatomic,strong)UIImageView * photoImageView;

@property (nonatomic,strong)UILabel * coachName;

@property (nonatomic,strong)UILabel * coachSex;

@property (nonatomic,strong)UILabel * cellTitle;

@property (nonatomic,strong)UILabel * otherLabel;

@property (nonatomic,strong)UILabel * cellContent;

@property (nonatomic,strong)UIImageView * cellImageView;

@property (nonatomic,strong)UIImageView * choiceImage;

@property (nonatomic,strong)UILabel * sectionTitle;

@property (nonatomic,strong)UIButton * selectButton;


@property (nonatomic,strong)UIButton * SubmitButton;

@property (nonatomic,strong)UIView * FooterView;


@property (nonatomic,strong)UIImageView * alipayImage;
@property (nonatomic,strong)UIImageView * wechatpayImage;

//优惠券
@property (nonatomic,strong)NSString * Discount;


//支付选择
@property BOOL IsAlipay;
@property BOOL IsWechatpay;

//课程价格
@property (nonatomic,copy)NSString * price;

//支付价格
@property (nonatomic,copy)NSString * amount;


@property(nonatomic,copy)NSString *CreatOrderNum;
@property(nonatomic,copy)NSString *CreatOrderMonay;
@property(nonatomic,strong)NSDictionary *WXinfoDict;


@end
