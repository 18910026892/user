//
//  JLUserInfoViewController.h
//  Accompany
//
//  Created by 巩鑫 on 16/1/25.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <UIImageView+WebCache.h>
#import "CustomTextField.h"
#import "UWDatePickerView.h"
#import "PickerButton.h"

@interface JLUserInfoViewController : BaseViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UWDatePickerViewDelegate,PickerButtonDelegate>
{
    UserInfo * userInfo;
}


@property (nonatomic,strong)UITableView * TableView;

@property (nonatomic,strong)UILabel * cellTitle;


@property (nonatomic,strong)UILabel * cellContent;

@property(nonatomic,strong)UILabel * UPcellLine;

@property(nonatomic,strong)UILabel * DowncellLine;


@property (nonatomic,strong)UIImageView * UserPhotoImageView;

@property (nonatomic,strong)UIActionSheet * PhotoActionSheet;

@property (nonatomic,strong)UIActionSheet * SexActionSheet;

@property (nonatomic,strong)UIAlertView * AlertView;

@property (nonatomic,strong)CustomTextField * AlertTextFiled;

@property (nonatomic,strong)UWDatePickerView * pickerView;

@property (nonatomic,strong)PickerButton * CityPickerButton;
@property (nonatomic,strong)PickerButton * TypePickerButton;

@property (nonatomic,strong)UIButton * SaveButton;

@property (nonatomic,strong)UIView * FooterView;



//DATA

@property (nonatomic,strong)NSArray * CityArray;
@property (nonatomic,strong)NSArray * typeArray;

@property(nonatomic,strong)NSArray * cellTitleArray;

@property (strong,nonatomic)UIImage * upload_image;
@property (nonatomic,strong)NSData * imgData;

@property (nonatomic,copy)NSString * userPhoto;

@property (nonatomic,copy)NSString * nickName;

@property (nonatomic,copy)NSString * UserSex;

@property (nonatomic,copy)NSString * UserDesc;

@property(nonatomic,copy)NSString * UserHeight;

@property(nonatomic,copy)NSString * UserWeight;

@property(nonatomic,copy)NSString * CityName;

@property(nonatomic,copy)NSString * Category;

@property(nonatomic,copy)NSString * Birthday;

@property(nonatomic,copy)NSString * token;

@property (nonatomic,copy)NSMutableDictionary * UserDict;
@end
