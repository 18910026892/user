//
//  JLCreateViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/17.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLCreateViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "UIImage+Additional.h"
#import "JLMyCommunitysViewController.h"

@interface JLCreateViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UILabel *desLable;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *introlTextFeild;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property(nonatomic,strong)UIImage *uploadImg;
- (IBAction)sureButtonClick:(id)sender;


@end

@implementation JLCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"创建社区"];
    [self showBackButton:YES];
    [self setTabBarHide:YES];
    self.enableIQKeyboardManager = YES;
    [self setupViews];
    [self setupDatas];
}
-(void)setupViews
{
    _nameTextFeild.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"最多10个字" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    _introlTextFeild.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"至少10个字" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor]}];
    _sureButton.layer.masksToBounds = YES;
    _sureButton.layer.cornerRadius = 15;
    _photoImgView.layer.cornerRadius = 7.0;
    _photoImgView.clipsToBounds = YES;
    _backImgView.clipsToBounds = YES;
    _photoImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGusture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadUserImg:)];
    [_photoImgView addGestureRecognizer:tapGusture];
}

-(void)setupDatas
{

}

-(void)upLoadUserImg:(UITapGestureRecognizer *)gesture
{
    UIActionSheet *PhotoActionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"拍照", nil];
    PhotoActionSheet.delegate = self;
    PhotoActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [PhotoActionSheet showInView:self.view];
}

- (IBAction)sureButtonClick:(id)sender {
    if( _nameTextFeild.text.length>10){
        [HDHud showMessageInView:self.view title:@"标题最多10个字"];
    }else if (_introlTextFeild.text.length<10){
        [HDHud showMessageInView:self.view title:@"简介至少10个字"];
    }else{
        NSLog(@"完成");
        [self createNetWortMethod];
    }
}

-(void)createNetWortMethod
{
    [HDHud showHUDInView:self.view title:@"正在创建"];
    NSData *imgData = UIImageJPEGRepresentation(_uploadImg, 0.4);
    NSDictionary *pragma = [NSDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",_nameTextFeild.text,@"name",_introlTextFeild.text,@"comment",nil];
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_CreatCommunity pragma:pragma ImageDatas:imgData imageName:@"image"];
    [request getResultWithSuccess:^(id response) {
        [HDHud showMessageInView:self.view title:@"创建成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
            [self.navigationController pushViewController:[JLMyCommunitysViewController viewController] animated:YES];
        });
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imgpicker = [[UIImagePickerController alloc]init];
    switch (buttonIndex) {
        case 1:
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
        case 0:{
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
            [actionSheet setHidden:YES];
            break;
        default:
            break;
    }
}
#pragma mark imagePickerController methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0,3_0)
{
    self.uploadImg = image;
    [_photoImgView setImage:image];
    [self adjudePhotoImg];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.uploadImg = image;
    [_photoImgView setImage:image];
    [self adjudePhotoImg];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    [self adjugeSureBtnIvalid];
    return YES;
}

-(void)adjugeSureBtnIvalid
{
    if(_uploadImg!=nil && _nameTextFeild.text.length>0 && _introlTextFeild.text.length>0){
        _sureButton.backgroundColor = kTabBarItemSelectColor;
        _sureButton.enabled = YES;
    }else{
        _sureButton.backgroundColor = [UIColor grayColor];
        _sureButton.enabled = NO;
    }
}
-(void)adjudePhotoImg
{
    if(_uploadImg==nil){
        _photoImgView.image = [UIImage imageNamed:@""];
        _backImgView.image = [UIImage imageNamed:@""];
        _desLable.hidden = NO;
    }else{
        _photoImgView.image = _uploadImg;
        _backImgView.image = [_uploadImg blurred];
        _desLable.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
