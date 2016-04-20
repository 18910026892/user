//
//  JLHelpViewController.m
//  Accompany
//
//  Created by GongXin on 16/1/27.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLHelpViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
@interface JLHelpViewController ()

@end

@implementation JLHelpViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"帮助与反馈"];
    [self setupDatas];
    [self setupViews];
    [self showBackButton:YES];
    

}
-(void)setupDatas
{
    _uploadImgArr = [[NSMutableArray alloc]initWithCapacity:10];
    _ImageViewArr = [[NSMutableArray alloc]initWithCapacity:10];
}



-(void)initImageViewData
{
    for(int i=0; i<3;i++){
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
        if(i==3) return;
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
    for(int m=(int)(_uploadImgArr.count+1);m<3;m++){
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
   // [self pushToEditPhotoViewController:image];
    [_uploadImgArr addObject:image];
    [self resetImageViewData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //[self pushToEditPhotoViewController:image];
    
    [_uploadImgArr addObject:image];
    [self resetImageViewData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
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


-(void)setupViews
{
 
    [self.RightBtn setTitle:@"客服" forState:UIControlStateNormal];
    [self.RightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(kefu) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.BGView];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.SubmitButton];
     [self initImageViewData];
}
-(void)kefu
{
    NSString * telNumber = [NSString stringWithFormat:@"tel://67634922"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telNumber]];
    
}
-(UIView*)BGView
{
    if (!_BGView) {
        _BGView = [[UIView alloc]init];
        _BGView.frame = CGRectMake(0, 84, kMainScreenWidth, 120);
        _BGView.backgroundColor = RGBACOLOR(45, 50, 54, 1);
        [_BGView addSubview:self.textView];
        [_BGView addSubview:self.label1];
        [_BGView addSubview:self.label2];
    }
    return _BGView;
}

-(UIView*)imgView
{
    if (!_imgView) {
        _imgView = [[UIView alloc]init];
        _imgView.frame = CGRectMake(0, 224, kMainBoundsWidth, 80);
        
    }
    return _imgView;
}

-(UITextView*)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, kMainBoundsWidth-40, 120)];
        _textView.textColor = [UIColor whiteColor];
        _textView.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.returnKeyType = UIReturnKeyDefault;
        _textView.keyboardType = UIKeyboardTypeDefault;
        _textView.scrollEnabled = NO;
        _textView.editable = YES;
        _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 0);
    }
    
    return _textView;
}

-(UILabel*)label1
{
    if(!_label1)
    {
        _label1 = [[UILabel alloc]initWithFrame:CGRectMake(kMainBoundsWidth-120, VIEW_MAXY(self.textView)-21, 100, 20)];
        _label1.text = [NSString stringWithFormat:@"0/100字"];
        _label1.textColor = [UIColor whiteColor];
        _label1.font = [UIFont fontWithName:@"HelveticaNeue" size:13.0f];
        _label1.textAlignment = NSTextAlignmentRight;
        _label1.backgroundColor = [UIColor clearColor];

    }
    
    return _label1;
}

-(UILabel*)label2
{
    if (!_label2) {
        _label2 = [[UILabel alloc]initWithFrame:CGRectMake(25,5, kMainBoundsWidth-50, 20)];
        _label2.text = @"请输入您的意见，我们将不断优化体验";
        _label2.textColor = [UIColor grayColor];
        _label2.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        _label2.textAlignment = NSTextAlignmentLeft;
        _label2.backgroundColor = [UIColor clearColor];
    }
    
    return _label2;
}
-(UIButton*)SubmitButton
{
    if (!_SubmitButton) {
        
        _SubmitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _SubmitButton.frame = CGRectMake(20,340, kMainScreenWidth-40, 35);
        _SubmitButton.backgroundColor = [UIColor redColor];
        [_SubmitButton setTitle:@"提交" forState:UIControlStateNormal];
        [_SubmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _SubmitButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
        _SubmitButton.layer.cornerRadius = 17.5;
        [_SubmitButton addTarget:self action:@selector(SubmitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _SubmitButton;
}

-(void)SubmitButtonClick:(UIButton*)sender
{
      // token,comment
    
    NSString * comment = _textView.text;
    if ([comment length]==0) {
        [HDHud showMessageInView:self.view title:@"您还没有输入任何意见"];
    }else
    {
         [HDHud showHUDInView:self.view title:@"正在提交..."];
        userInfo = [UserInfo sharedUserInfo];
        NSString * token = userInfo.token;
        
        NSDictionary * postDict = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",comment,@"comment", nil];
        
        
        NSMutableArray *imgsData = [[NSMutableArray alloc]initWithCapacity:9];
        [_uploadImgArr enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *data = UIImageJPEGRepresentation(obj, 1);
            [imgsData addObject:data];
        }];
        
        HttpRequest *request = [[HttpRequest alloc]init];
        [request RequestDataWithUrl:URL_feedback pragma:postDict ImageDatas:imgsData imageName:@"images"];
        [request getResultWithSuccess:^(id response) {
            [HDHud showMessageInView:self.view title:@"提交成功"];
       
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } DataFaiure:^(id error) {
            NSString *message = (NSString *)error;
            [HDHud showMessageInView:self.view title:message];
        } Failure:^(id error) {
            [HDHud showNetWorkErrorInView:self.view];
        }];
        
        
        
        
    
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
    
   
    
    
}



-(BOOL)textView:(UITextView *)textview shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return YES;
    }
    if([[_textView text] length]>100){
        return NO;
    }
    //判断是否为删除字符，如果为删除则让执行
    char c=[text UTF8String][0];
    
    if (c=='\000') {
        _count = [[_textView text] length]-1;
        if(_count ==-1){
            _count =0;
        }
        if(_count ==0)
        {
            _label2.hidden=NO;//隐藏文字
        }else{
            _label2.hidden=YES;
        }
        _label1.text = [NSString stringWithFormat:@"%ld/100字",(long)_count];
        return YES;
    }
    if([[_textView text] length]==100) {
        if(![text isEqualToString:@"\b"])
            return NO;
    }
    _count =[[_textView text] length]-[text length]+2;
    if(_count ==0)
    {
        _label2.hidden=NO;//隐藏文字
    }else{
        _label2.hidden=YES;
    }
    _label1.text = [NSString stringWithFormat:@"%ld/100字",(long)_count];
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView;
{
    _count = [[_textView text] length];
    _label1.text = [NSString stringWithFormat:@"%ld/100字",(long)_count];
}

//去掉输入的前后空格
-(NSString *)removespace:(UITextField *)textfield {
    return [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
