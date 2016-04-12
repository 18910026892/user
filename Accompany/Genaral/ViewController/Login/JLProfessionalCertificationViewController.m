//
//  JLProfessionalCertificationViewController.m
//  Accompany
//
//  Created by GongXin on 16/3/1.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLProfessionalCertificationViewController.h"

@implementation JLProfessionalCertificationViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"专业认证"];
    self.enableIQKeyboardManager = YES;
    [self setupViews];
    [self showBackButton:YES];
    
}
-(void)setupViews
{
    [self.RightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.BgView];
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.buttonTitle];
}

-(void)saveAction
{
    NSLog(@"save");
    [HDHud showHUDInView:self.view title:@"正在提交..."];
    
    userInfo = [UserInfo sharedUserInfo];
    
    NSString * token = userInfo.token;
    
    NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",nil];
    
    HttpRequest * request = [[HttpRequest alloc]init];
    
    
    [request RequestDataWithUrl:URL_uploadCertificationImg pragma:postDict ImageDatas:self.imgData imageName:@"certificationImg"];
    
    
    request.successBlock = ^(id obj){
        
        
        [HDHud hideHUDInView:self.view];
        
        
        [HDHud showMessageInView:self.view title:@"上传成功"];
        
        
        NSString * identityCardUrl = [obj[0] valueForKey:@"certificationUrl"];
        
        [UserDefaultsUtils saveValue:identityCardUrl forKey:@"certificationUrl"];
        
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

-(UIView*)BgView
{
    if (!_BgView) {
        _BgView = [[UIView alloc]init];
        _BgView.frame = CGRectMake(0, 64, kMainBoundsWidth, 205*Proportion);
        _BgView.backgroundColor = RGBACOLOR(45, 50, 54, 1);
        [_BgView addSubview:self.IDImageView];
        [_BgView addSubview:self.TitleLabel];
       
    }
    return _BgView;
}

-(UIImageView*)IDImageView
{
    if (!_IDImageView) {
        _IDImageView = [[UIImageView alloc]init];
        _IDImageView.frame = CGRectMake(10, 20, kMainBoundsWidth-20, 150*Proportion);
        _IDImageView.backgroundColor = RGBACOLOR(59, 63, 65, 1);
        NSString * certificationUrl = [UserDefaultsUtils valueWithKey:@"certificationUrl"];
        
        if (certificationUrl) {
            [_IDImageView sd_setImageWithURL:[NSURL URLWithString:certificationUrl]];
        }
    }
    return _IDImageView;
}
-(UILabel *)TitleLabel
{
    if (!_TitleLabel) {
        _TitleLabel = [[UILabel alloc]init];
        _TitleLabel.frame = CGRectMake(10, 180*Proportion, kMainBoundsWidth-20, 20);
        _TitleLabel.text = @"资质认证";
        _TitleLabel.textColor =[UIColor whiteColor];
        _TitleLabel.font = [UIFont systemFontOfSize:16];
        _TitleLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _TitleLabel;
}


-(UIButton*)photoButton
{
    if (!_photoButton) {
        _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoButton.frame = CGRectMake(kMainBoundsWidth/2-25, kMainBoundsHeight-150, 50, 50);
        [_photoButton setImage:[UIImage imageNamed:@"photobutton"] forState:UIControlStateNormal];
        [_photoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoButton;
}
-(UILabel *)buttonTitle
{
    if (!_buttonTitle) {
        _buttonTitle = [[UILabel alloc]init];
        _buttonTitle.frame = CGRectMake(10, kMainBoundsHeight-100, kMainBoundsWidth-20, 20);
        _buttonTitle.text = @"证书上传";
        _buttonTitle.textColor =[UIColor grayColor];
        _buttonTitle.font = [UIFont systemFontOfSize:14];
        _buttonTitle.textAlignment = NSTextAlignmentCenter;
        
    }
    return _buttonTitle;
}

-(void)photoButtonClick:(UIButton*)sender
{
    _PhotoActionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    _PhotoActionSheet.delegate = self;
    _PhotoActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    _PhotoActionSheet.tag = 2001;
    [_PhotoActionSheet showInView:self.view];
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
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
    
    
    
    
    
}

#pragma mark imagePickerController methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0,3_0)
{
    self.upload_image = image;
    [_IDImageView setImage:image];
    _imgData = UIImageJPEGRepresentation(_upload_image, 1.0);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.upload_image = image;
    [_IDImageView setImage:image];
    _imgData = UIImageJPEGRepresentation(_upload_image, 1.0);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
