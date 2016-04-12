//
//  JLReadeemCodeViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/2/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

@interface JLReadeemCodeViewController : BaseViewController<UITextFieldDelegate>

{
    UserInfo * userInfo;
}
@property(nonatomic,strong)UIView * TextFieldBGView;

@property(nonatomic,strong)CustomTextField * CodeTextField;

@property(nonatomic,strong)UIButton * SureButton;

//优惠码
@property(nonatomic,strong)NSString * ReadeemCode;

@end
