//
//  JLPublicViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/18.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPublicViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "JLPhotoEditViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface JLPublicViewController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *desTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLable;
@property (weak, nonatomic) IBOutlet UIView *imgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewHeightConstraint;

@property(nonatomic,strong)NSMutableArray *uploadImgArr;
@property(nonatomic,strong)NSMutableArray *ImageViewArr;

@end

@implementation JLPublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableIQKeyboardManager = YES;
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"发布"];
    [self setTabBarHide:YES];
    [self setupDatas];
    [self setupViews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddImgDataFromEdit:) name:KN_FINISHEDITPHOTO object:nil];
}

-(void)setupViews
{
    [self.RightBtn setTitle:@"发布" forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(publicBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.RightBtn setTitleColor:kTabBarItemSelectColor forState:UIControlStateNormal];

    [self.LeftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.LeftBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"标题" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:15]}];
    
    [self initImageViewData];
}

-(void)setupDatas
{
    _uploadImgArr = [[NSMutableArray alloc]initWithCapacity:10];
    _ImageViewArr = [[NSMutableArray alloc]initWithCapacity:10];
}

//通知－－编辑完成的照片
-(void)AddImgDataFromEdit:(NSNotification *)notify
{
    UIImage *editImg = (UIImage *)[notify object];
    [_uploadImgArr addObject:editImg];
    [self resetImageViewData];
}

-(void)initImageViewData
{
    for(int i=0; i<9;i++){
        float i_wight = (kMainBoundsWidth-10*5)/4;
        float i_x = (i_wight+10)*(i%4)+10;
        float i_y = (i_wight+10)*(i/4);
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i_x, i_y, i_wight, i_wight)];
        img.tag = i;
        img.hidden = YES;
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImgViewClick:)];
        [img addGestureRecognizer:tap];
        [_imgView addSubview:img];
        [_ImageViewArr addObject:img];
    }
    [self resetImageViewData];
}

-(void)resetImageViewData
{
    for(int i=0;i<_uploadImgArr.count+1;i++){
        if(i==9) return;
        UIImageView *imgView = (UIImageView *)[_ImageViewArr objectAtIndex:i];
        imgView.hidden = NO;
        if(i==_uploadImgArr.count){
            //添加照片按钮
            imgView.image = [UIImage imageNamed:@"addimage"];
        }else{
            UIImage *img = (UIImage *)[_uploadImgArr objectAtIndex:i];
            [imgView setImage:img];
        }
    }
    for(int m=(int)(_uploadImgArr.count+1);m<9;m++){
        UIImageView *imgView = (UIImageView *)[_ImageViewArr objectAtIndex:m];
        imgView.hidden = YES;
    }
    float i_wight = (kMainBoundsWidth-10*5)/4;
    float line = (_uploadImgArr.count+1)%4?(_uploadImgArr.count+1)/4+1:(_uploadImgArr.count+1)/4;
    _imgViewHeightConstraint.constant = (i_wight+10)*line;
}

-(void)uploadImgViewClick:(UIGestureRecognizer *)gesture
{
    if(gesture.view.tag==_uploadImgArr.count){
        UIActionSheet *PhotoActionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"本地相册",@"拍照", nil];
        PhotoActionSheet.delegate = self;
        PhotoActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [PhotoActionSheet showInView:self.view];
    }else{
        //进入预览大图
        UIImageView *imgView = (UIImageView *)gesture.view;
        [self browseImages:_uploadImgArr index:imgView.tag touchImageView:imgView];
    }
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
                    //imgpicker.allowsEditing = YES;
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
                //imgpicker.allowsEditing = YES;
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
    [self pushToEditPhotoViewController:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self pushToEditPhotoViewController:image];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)pushToEditPhotoViewController:(UIImage *)oringeImg
{
    JLPhotoEditViewController *photoVC = [[JLPhotoEditViewController alloc]initWithNibName:@"JLPhotoEditViewController" bundle:nil];
    photoVC.origeImg = oringeImg;
    [self.navigationController pushViewController:photoVC animated:YES];
}


#pragma mark - image browser
- (void)browseImages:(NSArray *)imageArr index:(NSInteger)index touchImageView:(UIImageView *)touchImageView{
    NSInteger count = imageArr.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = imageArr[i];
        photo.srcImageView = touchImageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}



#pragma Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView;
{
    if(textView.text.length>0){
        _placeHolderLable.hidden = YES;
    }else _placeHolderLable.hidden = NO;
}

-(void)cancleBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)publicBtnClick
{
    if([Helper RemoveStringWhiteSpace:_titleTextField].length>0 || _desTextView.text.length>0 || [_uploadImgArr count]>0){
        [self createNetWortMethod];
    }else{
        [HDHud showMessageInView:self.view title:@"请输入发布内容"];
    }
}

-(void)createNetWortMethod
{
    [HDHud showHUDInView:self.view title:@"正在发布"];
    
    NSMutableArray *imgsData = [[NSMutableArray alloc]initWithCapacity:9];
    [_uploadImgArr enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSData *data = UIImageJPEGRepresentation(obj, 1);
        [imgsData addObject:data];
    }];
    NSMutableDictionary *pragma = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token",[Helper RemoveStringWhiteSpace:_titleTextField],@"title",_desTextView.text,@"content",nil];
    if(![Helper isBlankString:_communityId]){
        [pragma setObject:_communityId forKey:@"communityId"];
    }
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_PublishPosts pragma:pragma ImageDatas:imgsData imageName:@"images"];
    [request getResultWithSuccess:^(id response) {
        [HDHud showMessageInView:self.view title:@"发布成功"];
        [[NSNotificationCenter defaultCenter]postNotificationName:KN_POSTREFRESH object:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
