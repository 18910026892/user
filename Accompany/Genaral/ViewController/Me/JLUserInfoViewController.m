//
//  JLUserInfoViewController.m
//  Accompany
//
//  Created by 巩鑫 on 16/1/25.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLUserInfoViewController.h"

@implementation JLUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavTitle:@"编辑资料"];
    [self setupDatas];
    [self setupViews];
    [self showBackButton:YES];
     self.enableIQKeyboardManager = YES;
    
 
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTabBarHide:YES];
}
-(void)setupDatas
{
    _cellTitleArray = @[@"头像",@"昵称",@"性别",@"个性签名",@"身高",@"体重",@"年龄",@"城市",@"教练类型"];
    
    userInfo = [UserInfo sharedUserInfo];
    _userPhoto = userInfo.userPhoto;
    _nickName = userInfo.nikeName;
    _UserSex = [NSString stringWithFormat:@"%@",userInfo.userSex];
    _UserDesc = userInfo.userDesc;
    _UserHeight = [NSString stringWithFormat:@"%@",userInfo.userHeight];
    _UserWeight = [NSString stringWithFormat:@"%@",userInfo.userWeight];
    if ([userInfo.birthday length]>9) {
          _Birthday = [userInfo.birthday substringToIndex:10];
    }
    NSLog(@"看下这个东西是不是就是没存上啊%@",_Birthday);
    _CityName = userInfo.city;
    _Category = userInfo.coachType;
    _token = userInfo.token;
}
-(void)setupViews
{
   
    [self showBackButton:YES];
    [self.view addSubview:self.TableView];
    
}

-(UIButton*)SaveButton
{
    if (!_SaveButton) {
        
        _SaveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _SaveButton.frame = CGRectMake(20,12.5, kMainScreenWidth-40, 35);
       _SaveButton.backgroundColor = [UIColor redColor];
        [_SaveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_SaveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _SaveButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _SaveButton.layer.cornerRadius = 17.5;
        [_SaveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SaveButton;
}
-(void)saveButtonClick:(UIButton*)sender
{
  
    [HDHud showHUDInView:self.view title:@"正在提交..."];
    

    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:_token,@"token",_nickName,@"nikeName",_UserSex,@"userSex",_UserDesc,@"userDesc",_UserHeight,@"userHeight",_UserWeight,@"userWeight",_Birthday,@"birthday",_CityName,@"city",_Category,@"coachType",  nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    
 
    [request RequestDataWithUrl:URL_updateUser pragma:postDict ImageDatas:self.imgData imageName:@"userPhoto"];
    
    
    request.successBlock = ^(id obj){
        
        
        [HDHud hideHUDInView:self.view];
        
     
          [HDHud showMessageInView:self.view title:@"修改成功"];
            _UserDict = obj[0];
            
            NSLog(@"%@",_UserDict);
            [userInfo LoginWithDictionary:_UserDict];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserInfoChange" object:nil];
      
        
        
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

-(UIView*)FooterView
{
    if (!_FooterView) {
        _FooterView = [[UIView alloc]init];
        _FooterView.frame = CGRectMake(0, 0, kMainBoundsWidth, 80);
        _FooterView.backgroundColor = [UIColor clearColor];
        
        [_FooterView addSubview:self.SaveButton];
    }
    
    return _FooterView;
    
}

-(UITableView*)TableView
{
    if (!_TableView)
    {
        _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kMainBoundsWidth,kMainBoundsHeight-64) style:UITableViewStyleGrouped];
        _TableView.dataSource = self;
        _TableView.delegate = self;
        _TableView.scrollEnabled = YES;
        _TableView.backgroundColor = [UIColor clearColor];
       
        _TableView.tableFooterView = self.FooterView;
        _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _TableView;
}
#pragma TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section==0) {
    return 64;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    if (section==8) {
        return 50;
    }
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return [_cellTitleArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{

    
    UITableViewCell * cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        _cellTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 120, 20)];
        _cellTitle.backgroundColor = [UIColor clearColor];
        _cellTitle.textColor = [UIColor whiteColor];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.font = [UIFont systemFontOfSize:14.0f];
        _cellTitle.text = [_cellTitleArray objectAtIndex:indexPath.section];
        [cell.contentView addSubview:_cellTitle];
        
        _cellContent = [[UILabel alloc]initWithFrame:CGRectMake(120, 12, kMainBoundsWidth-160, 20)];
        _cellContent.backgroundColor = [UIColor clearColor];
        _cellContent.textColor = [UIColor whiteColor];
        _cellContent.textAlignment = NSTextAlignmentRight;
        _cellContent.font = [UIFont systemFontOfSize:14];
        _cellContent.tag = indexPath.section+1000;
        [cell.contentView addSubview:_cellContent];
        
        _UPcellLine = [[UILabel alloc]init];
        
        _UPcellLine.frame = CGRectMake(0,0,kMainBoundsWidth, .5);
        _UPcellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_UPcellLine];
        
        
        _DowncellLine = [[UILabel alloc]init];
    
        _DowncellLine.frame = CGRectMake(0, 43.5,kMainBoundsWidth, .5);
        _DowncellLine.backgroundColor = kSeparatorLineColor;
        [cell.contentView addSubview:_DowncellLine];
        
    }

    

            switch (indexPath.section) {
                case 0:
                {
                    _cellTitle.frame = CGRectMake(20, 22, 80, 20);
                   
                    
                    _cellContent.hidden = YES;
                    
                    _DowncellLine.frame = CGRectMake(0, 63.5,kMainBoundsWidth, .5);
                    
                    
                    _UserPhotoImageView = [[UIImageView alloc]init];
                    
                    _UserPhotoImageView.frame = CGRectMake(kMainBoundsWidth-85, 4, 56, 56);
                    _UserPhotoImageView.layer.masksToBounds = YES;
                    _UserPhotoImageView.layer.cornerRadius = 28;
                    _UserPhotoImageView.layer.borderColor = RGBACOLOR(170, 178, 182, 1).CGColor;
                    _UserPhotoImageView.layer.borderWidth = 1;
                    
              
                  
                    
                    
                    if (!_upload_image) {
                        
                        if ([_userPhoto isEmpty]) {
                            _UserPhotoImageView.image = [UIImage imageNamed:@"userPhoto"];
                        }else
                        {
                            NSString * imageURL = _userPhoto;
                            NSString * photoImage = [NSString stringWithFormat:@"%@",imageURL];
                            NSURL * photoURL = [NSURL URLWithString:photoImage];
                            NSString * tianChongImage = @"userPhoto";
                            
                            [_UserPhotoImageView sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:tianChongImage]];
                        }
                        
                        
                    }else
                    {
                        _UserPhotoImageView.image = _upload_image;
                    }
                    
                    
                    [cell.contentView addSubview:_UserPhotoImageView];
                }
                    break;
                    case 1:
                {
                    _cellContent.text = _nickName;
                }
                    break;
                case 2:
                {
                    if ([_UserSex isEqualToString:@"1"]) {
                        _cellContent.text = @"男";
                        
                    }else if ([_UserSex isEqualToString:@"2"])
                    {
                        _cellContent.text = @"女";
                    }

                }
                    break;
                case 3:
                {
                    _cellContent.font = [UIFont systemFontOfSize:12];

                    _cellContent.text = _UserDesc;
                  
                }
                    break;
                case 4:
                {
                    if(![_UserHeight isEmpty])
                    {
                         _cellContent.text =[NSString stringWithFormat:@"%@ cm",_UserHeight];
                    }
                    
                }
                    break;
                case 5:
                {
                    if(![_UserWeight isEmpty]){
                          _cellContent.text = [NSString stringWithFormat:@"%@ kg",_UserWeight];
                    }
                   
                }
                    break;
                case 6:
                {
                    if (![_Birthday isEmpty]) {
                       NSString * age = [self getAgeFromBirthday:_Birthday];

                        if ([age isEqualToString:@"0"]) {
                             _cellContent.text =@"";
                        }else
                        {
                            _cellContent.text = [NSString stringWithFormat:@"%@ 岁",age];
                        }
                     
                    }
                    
                }
                    break;
                   case 7:
                {
                    CGRect rect = CGRectMake(kMainBoundsWidth-80*Proportion,0, 64*Proportion, 44);
               
                    _CityArray = @[@"北京",@"上海",@"广东"];
                    
                    _CityPickerButton =  [[PickerButton alloc]initWithItemList:_CityArray];
                    
                    _CityPickerButton.frame = rect;
                    
                    [_CityPickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    
                    _CityPickerButton.titleLabel.font = [UIFont systemFontOfSize:14];
                    
                  
                    _CityPickerButton.isShowSelectItemOnButton = YES;
                    
                    _CityPickerButton.delegate = self;
                    
                    _CityPickerButton.tag = 9998;
                    
                    if (![_CityName isEmpty]) {
                        [_CityPickerButton setTitle:_CityName forState:UIControlStateNormal];
                    }else if([_CityName isEmpty])
                    {
                        [_CityPickerButton setTitle:@"请选择" forState:UIControlStateNormal];
                    }
                    
                    [cell.contentView addSubview:_CityPickerButton];
                }
                    break;
                    case 8:
                {
                    CGRect rect = CGRectMake(kMainBoundsWidth-80*Proportion,0, 64*Proportion, 44);
                    
                    _typeArray= @[@"狂人",@"健身",@"瘦腿",@"瘦腰"];
                    
                    _TypePickerButton =  [[PickerButton alloc]initWithItemList:_typeArray];
                    
                    _TypePickerButton.frame = rect;
                    
                    [_TypePickerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    
                    _TypePickerButton.titleLabel.font = [UIFont systemFontOfSize:14];
                    
                    _TypePickerButton.isShowSelectItemOnButton = YES;
                    
                    _TypePickerButton.delegate = self;
                    
                    _TypePickerButton.tag = 9999;
                    
                    if (![_Category isEmpty]) {
                        [_TypePickerButton setTitle:_Category forState:UIControlStateNormal];
                    }else if ([_Category isEmpty])
                    {
                        
                   [_TypePickerButton setTitle:@"请选择" forState:UIControlStateNormal];
                    
                    }
                     [cell.contentView addSubview:_TypePickerButton];
                    
                }
                    break;
                default:
                    break;
            }
    
    
    return cell;
    
    
}
#pragma PickerButton Delegate

- (void)pickerButton:(PickerButton *)button
      didSelectIndex:(NSInteger)index
             andItem:(NSString *)item;
{
    NSLog(@"%ld **** %@ ",(long)index,item);
    
    if (button.tag==9998) {
        _CityName = [NSString stringWithFormat:@"%@",item];
        
    }else if(button.tag == 9999)
    {
        _Category = [NSString stringWithFormat:@"%@",item];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section==0) {
        _PhotoActionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
        _PhotoActionSheet.delegate = self;
        _PhotoActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
       _PhotoActionSheet.tag = 2001;
        [_PhotoActionSheet showInView:self.view];

    }else if(indexPath.section==1)
    {
        NSString * AlertTitle = @"修改昵称";
        
        _AlertView = [[UIAlertView alloc] initWithTitle:AlertTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _AlertView.tag = 3000+indexPath.section;
        _AlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        UITextField *alertField = [_AlertView textFieldAtIndex:0];
        alertField.placeholder = @"请输入新昵称";
        if ([_nickName length]>0) {
            alertField.text = _nickName;
        }
        alertField.tintColor = [UIColor redColor];
        [_AlertView show];
    }
    else if(indexPath.section==2)
    {
        _SexActionSheet =[[UIActionSheet alloc] initWithTitle:@"性别修改" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        _SexActionSheet.delegate = self;
        _SexActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        _SexActionSheet.tag = 2002;
        [_SexActionSheet showInView:self.view];
    }else
    if(indexPath.section==3)
    {
        NSString * AlertTitle = @"个性签名";
        
        _AlertView = [[UIAlertView alloc] initWithTitle:AlertTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        _AlertView.tag = 3000+indexPath.section;
        _AlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        
        UITextField *alertField = [_AlertView textFieldAtIndex:0];
        alertField.placeholder = @"最多输入18个字";
        alertField.tintColor = [UIColor redColor];
        
        if ([_UserDesc length]>0) {
            alertField.text = _UserDesc;
        }
        
        [_AlertView show];
    }else
        if(indexPath.section==4)
        {
            NSString * AlertTitle = @"身高cm";
            
            _AlertView = [[UIAlertView alloc] initWithTitle:AlertTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            _AlertView.tag = 3000+indexPath.section;
            _AlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            
            UITextField *alertField = [_AlertView textFieldAtIndex:0];
            alertField.placeholder = @"请输入身高";
            alertField.tintColor = [UIColor redColor];
            alertField.keyboardType = UIKeyboardTypeNumberPad;
            [_AlertView show];
        }else if(indexPath.section==5)
            {
                NSString * AlertTitle = @"体重kg";
                
                _AlertView = [[UIAlertView alloc] initWithTitle:AlertTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                _AlertView.tag = 3000+indexPath.section;
                _AlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                
                UITextField *alertField = [_AlertView textFieldAtIndex:0];
                alertField.placeholder = @"请输入体重";
                alertField.tintColor = [UIColor redColor];
                 alertField.keyboardType = UIKeyboardTypeNumberPad;
                [_AlertView show];
        }else if (indexPath.section==6)
        {
            [self setupDateView:DateTypeOfStart];
        }


    
    
}

- (void)setupDateView:(DateType)type {
    
    _pickerView = [UWDatePickerView instanceDatePickerView];
    _pickerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [_pickerView setBackgroundColor:[UIColor clearColor]];
    _pickerView.delegate = self;
    _pickerView.type = type;
    [self.view addSubview:_pickerView];
    
}

- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    NSLog(@"时间 : %@",date);
    _Birthday = [NSString stringWithFormat:@"%@",date];
    
    
    switch (type) {
        case DateTypeOfStart:
            // TODO 日期确定选择
            break;
            
        case DateTypeOfEnd:
            // TODO 日期取消选择
            break;
        default:
            break;
    }
    
    [_TableView reloadData];
}


//- (void)willPresentAlertView:(UIAlertView *)alertView; {
//    
//    // 遍历 UIAlertView 所包含的所有控件
//    
//    for (UIView *tempView in alertView.subviews) {
//
//        if ([tempView isKindOfClass:[UILabel class]]) {
//            
//            // 当该控件为一个 UILabel
//            UILabel *tempLabel = (UILabel *) tempView;
//
//            if ([tempLabel.text isEqualToString:alertView.title]) {
//                // 调整对齐方式
//                tempLabel.textAlignment = NSTextAlignmentLeft;
//                // 调整字体大小
//                [tempLabel setFont:[UIFont systemFontOfSize:15.0]];
//                
//            }
//            
//        }
//        
//    }
//    
//}
//


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==2001) {
        UIImagePickerController *imgpicker = [[UIImagePickerController alloc]init];
        switch (buttonIndex) {
            case 0:
            {
                NSLog(@"点击了照相");
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
                    {
                        //无权限
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                        
                    }else{
                        UIImagePickerController *imgpicker = [[UIImagePickerController alloc]init];
                        imgpicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                        imgpicker.allowsEditing = YES;
                        imgpicker.delegate = self;
                        [self presentViewController:imgpicker animated:YES completion:nil];
                    }
                }
                else
                {
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"本设备不支持相机模式" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
            }
                break;
            case 1:{
                NSLog(@"相册");
                ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
                if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
                {
                    //无权限
                    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先在隐私中设置相册权限" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }else{
                    imgpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imgpicker.allowsEditing = YES;
                    imgpicker.delegate = self;
                    
                    [self presentViewController:imgpicker animated:YES completion:nil];
                }
            }
                break;
                
            case 2:
                NSLog(@"取消");
                [_PhotoActionSheet setHidden:YES];
                break;
            default:
                break;
        }
        
        
        
    }else
    {
        switch (buttonIndex) {
            case 0:
            {
                
                UILabel * label = (UILabel*)[self.view viewWithTag:1002];
                label.text = @"男";
                _UserSex = @"1";
            }
                break;
            case 1:
            {
                UILabel * label = (UILabel*)[self.view viewWithTag:1002];
                label.text = @"女";
                _UserSex = @"2";
            }
                break;
            default:
                break;
        }

    }
    
}

#pragma mark imagePickerController methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0,3_0)
{
    self.upload_image = image;
    [_UserPhotoImageView setImage:image];
    _imgData = UIImageJPEGRepresentation(_upload_image, 1.0);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.upload_image = image;
    [_UserPhotoImageView setImage:image];
    _imgData = UIImageJPEGRepresentation(_upload_image, 1.0);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0);
{
    switch (_AlertView.tag)
    {
        case 3001:
        {
            if(buttonIndex==1)
            {
                UITextField * Tf3001 = [_AlertView textFieldAtIndex:0];
                
                UILabel * label = (UILabel*)[self.view viewWithTag:1001];
                _nickName = Tf3001.text;
                label.text = _nickName;
         
            }
                
        }
            break;
   
        case 3003:
        {
            if(buttonIndex==1)
            {
                UITextField * Tf3003 = [_AlertView textFieldAtIndex:0];
                
                UILabel * label = (UILabel*)[self.view viewWithTag:1003];
                _UserDesc = Tf3003.text;
                label.text = _UserDesc;
           
            }

        }
            break;

        case 3004:
        {
            if(buttonIndex==1)
            {
                UITextField * Tf3004 = [_AlertView textFieldAtIndex:0];
                
                UILabel * label = (UILabel*)[self.view viewWithTag:1004];
                _UserHeight = Tf3004.text;
                label.text = _UserHeight;
                
            }

        }
            break;

        case 3005:
        {
            if(buttonIndex==1)
            {
                UITextField * Tf3005 = [_AlertView textFieldAtIndex:0];
                
                UILabel * label = (UILabel*)[self.view viewWithTag:1005];
                _UserWeight = Tf3005.text;
                label.text = _UserWeight;
                
            }

        }
            break;

            
            

        default:
            break;

    }
    
    [_TableView reloadData];
}
-(NSString*)getAgeFromBirthday:(NSString*)birthday
{
     NSCalendar *calendar = [NSCalendar currentCalendar];
    //定义一个NSCalendar对象
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //生日
    NSDate *birthDay = [dateFormatter dateFromString:birthday];
    //用来得到具体的时差
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *date = [calendar components:unitFlags fromDate:birthDay toDate:nowDate options:0]; if([date year] >0) { NSLog(@"%@",[NSString stringWithFormat:(@"%ld岁%ld月%ld天"),(long)[date year],(long)[date month],(long)[date day]]) ; } else if([date month] >0) { NSLog(@"%@",[NSString stringWithFormat:(@"%ld月%ld天"),(long)[date month],(long)[date day]]); } else if([date day]>0){ NSLog(@"%@",[NSString stringWithFormat:(@"%ld天"),(long)[date day]]); } else { NSLog(@"0天");}
    
    NSString * age = [NSString stringWithFormat:@"%ld",(long)[date year]];
    return age;
    
}
@end
