//
//  JLHelpViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

@interface JLHelpViewController : BaseViewController <UITextViewDelegate>

{
    UserInfo * userInfo;
}
@property(nonatomic,strong)UITextView * textView;

@property (nonatomic,strong)UILabel * label1,*label2;

@property (nonatomic,strong)UIButton * SubmitButton;

@property (nonatomic,strong)UIView * BGView;

@property (nonatomic,copy)NSString * Opinion;

@property NSInteger count;
@property (nonatomic,strong)NSMutableDictionary * dict;

@end
