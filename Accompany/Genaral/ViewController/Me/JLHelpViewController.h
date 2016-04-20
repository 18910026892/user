//
//  JLHelpViewController.h
//  Accompany
//
//  Created by GongXin on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseViewController.h"

@interface JLHelpViewController : BaseViewController <UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
{
    UserInfo * userInfo;
}

@property (strong, nonatomic) UIView *imgView;
@property (strong, nonatomic) NSLayoutConstraint *imgViewHeightConstraint;

@property(nonatomic,strong)NSMutableArray *uploadImgArr;
@property(nonatomic,strong)NSMutableArray *ImageViewArr;

//客服按钮
@property(nonatomic,strong)UIBarButtonItem *rightBarButtonItem;

@property(nonatomic,strong)UITextView * textView;

@property (nonatomic,strong)UILabel * label1,*label2;

@property (nonatomic,strong)UIButton * SubmitButton;

@property (nonatomic,strong)UIView * BGView;

@property (nonatomic,copy)NSString * Opinion;

@property NSInteger count;
@property (nonatomic,strong)NSMutableDictionary * dict;

@end
