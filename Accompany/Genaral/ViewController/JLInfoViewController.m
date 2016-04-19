//
//  JLInfoViewController.m
//  Accompany
//
//  Created by GongXin on 16/4/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "JLVideoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

@interface JLInfoViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic)  UIScrollView *backScroll;


//@property (strong, nonatomic)  UITextField *healthResultTF;

@property(nonatomic,strong)UIView *ImageInfoView;

//@property (strong, nonatomic)  UITextField *beizhuTF;
@property (strong, nonatomic)  UIButton *handleBtn;

@property(nonatomic,strong)UIView *detailInfoView;
@property (nonatomic,strong)UIActionSheet * PhotoActionSheet;
@property(nonatomic,strong)UIImageView *selectImgView;

@property(nonatomic,strong)NSDictionary *userInfoDict;
@property(nonatomic,strong)NSArray *titlesArr;
@property(nonatomic,strong)NSArray *placehodersArr;
@property(nonatomic,strong)NSMutableArray *textFieldArr;
@property(nonatomic,strong)NSMutableArray *ImgArr;
@property(nonatomic,strong)NSMutableArray *upLoadImgArr;
@property(nonatomic,assign)BOOL isSaveInfo;
@property BOOL isBuyEnter;

@end

@implementation JLInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.enableIQKeyboardManager = YES;
    // Do any additional setup after loading the view.
    _titlesArr = @[@"年龄",@"性别",@"身高",@"体重",@"体质量指数",@"腰围",@"臀围",@"腰臀比例",@"身体脂肪",@"基础代谢率",@"静态心率",@"血压收缩压"];
    _placehodersArr = @[@"",@"",@"cm",@"KG",@"BMI",@"cm",@"cm",@"%",@"%",@"BMR",@"",@""];
    _ImgArr = [NSMutableArray array];
    _textFieldArr = [NSMutableArray array];
    _upLoadImgArr = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",nil];
    [self setupViews];
    [self submitInfoRequest];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTabBarHide:_isBuyEnter];
    [self showBackButton:_isBuyEnter];
}

-(void)setupViews
{
    if(!_isBuyEnter){
        [self setNavTitle:@"资料"];
        [self.RightBtn setTitle:@"保存" forState:UIControlStateNormal];
        [self.RightBtn setTitleColor:kTabBarItemSelectColor forState:UIControlStateNormal];
        [self.RightBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    _backScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, kMainBoundsWidth, kMainBoundsHeight-64)];
    _backScroll.showsVerticalScrollIndicator = NO;
    _backScroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_backScroll];
    
    UILabel *lable1 = [UILabel labelWithFrame:CGRectMake(12, 10, 160, 20) text:@"请填写资料" textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13]];
    [_backScroll addSubview:lable1];
    [_backScroll addSubview:self.detailInfoView];
    
    //    UILabel *lable2 = [UILabel labelWithFrame:CGRectMake(12, self.detailInfoView.bottom+3, 160, 20) text:@"健康问卷" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13]];
    //    [_backScroll addSubview:lable2];
    //
    //    _healthResultTF = [[UITextField alloc]initWithFrame:CGRectMake(12, lable2.bottom+3, kMainBoundsWidth-20, 35)];
    //    _healthResultTF.delegate = self;
    //    _healthResultTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写健康..." attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    //    _healthResultTF.textColor = [UIColor lightGrayColor];
    //    [_backScroll addSubview:_healthResultTF];
    //
    //    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(12, _healthResultTF.bottom, kMainBoundsWidth-12, 1)];
    //    line1.backgroundColor = kSeparatorLineColor;
    //    [_backScroll addSubview:line1];
    
    UILabel *lable3 = [UILabel labelWithFrame:CGRectMake(12, self.detailInfoView.bottom+3, 160, 30) text:@"体位评估照片" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13]];
    [_backScroll addSubview:lable3];
    [_backScroll addSubview:self.ImageInfoView];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(12, self.ImageInfoView.bottom+3, kMainBoundsWidth-12, 1)];
    line2.backgroundColor = kSeparatorLineColor;
    [_backScroll addSubview:line2];
    
    //    UILabel *lable4 = [UILabel labelWithFrame:CGRectMake(12, line2.bottom+3, 160, 20) text:@"备注" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13]];
    //    [_backScroll addSubview:lable4];
    //
    //    _beizhuTF = [[UITextField alloc]initWithFrame:CGRectMake(12, lable4.bottom+3, kMainBoundsWidth-20, 35)];
    //    _beizhuTF.delegate = self;
    //    _beizhuTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写备注信息..." attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
    //    _beizhuTF.textColor = [UIColor lightGrayColor];
    //    [_backScroll addSubview:_beizhuTF];
    //
    //    UILabel *line3 = [[UILabel alloc]initWithFrame:CGRectMake(12, _beizhuTF.bottom, kMainBoundsWidth-15, 1)];
    //    line3.backgroundColor = kSeparatorLineColor;
    //    [_backScroll addSubview:line3];
    
    if(_isBuyEnter){
        _handleBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, line2.bottom+30, kMainBoundsWidth-60, 40)];
        [_handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _handleBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_handleBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        _handleBtn.layer.masksToBounds = YES;
        _handleBtn.layer.cornerRadius = 5.0;
        _handleBtn.backgroundColor = kTabBarItemSelectColor;
        [_handleBtn addTarget:self action:@selector(handleOrderClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backScroll addSubview:_handleBtn];
        
        _backScroll.contentSize = CGSizeMake(0, _handleBtn.bottom+30);
    }else{
        _backScroll.contentSize = CGSizeMake(0, line2.bottom+30+50);
    }
}

-(void)setupDatas
{
    __block NSArray *keysArr = @[@"age",@"sex",@"height",@"weight",@"habitusExp",@"waist",@"hipline",@"hiplineRatio",@"bodyFat",@"metabolismRatio",@"stillHeartbeat",@"bloodPressure"];
    __block NSArray *imgnames = @[@"frontImageUrl",@"sideImageUrl",@"rearImageUrl"];
    __block NSArray *placeImgs = @[@"info01",@"info02",@"info03"];
    [_textFieldArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *tf = (UITextField *)obj;
        if([Helper isBlankString:[_userInfoDict valueForKey:keysArr[idx]]]){
            tf.text = @"";
        }else{
            tf.text = [NSString stringWithFormat:@"%@",[_userInfoDict valueForKey:keysArr[idx]]];
        }
        if(idx==1){
            tf.text = ([[_userInfoDict valueForKey:@"sex"] longValue]==1)?@"男":@"女";
        }
    }];
    [_ImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imgView = (UIImageView *)obj;
        [imgView sd_setImageWithURL:[NSURL URLWithString:[_userInfoDict valueForKey:imgnames[idx]]] placeholderImage:[UIImage imageNamed:placeImgs[idx]]];
    }];
}


-(UIView *)detailInfoView
{
    if(!_detailInfoView){
        _detailInfoView = [[UIView alloc]initWithFrame:CGRectMake(0,30, kMainBoundsWidth, 240)];
        _detailInfoView.backgroundColor = [UIColor clearColor];
        float m_height = 80;
        float m_width = kMainBoundsWidth/4+1;
        int index = 0;
        for (int i=0; i<3; i++) {
            for (int j=0; j<4; j++) {
                UIView *subView = [[UIView alloc]initWithFrame:CGRectMake(m_width*j-1, m_height*i, m_width, m_height)];
                subView.layer.borderColor = kSeparatorLineColor.CGColor;
                subView.layer.borderWidth = 0.3;
                [_detailInfoView addSubview:subView];
                
                UILabel *titleLable = [UILabel labelWithFrame:CGRectMake(0, 10, subView.width, 20) text:_titlesArr[index] textColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:13.0]];
                titleLable.textAlignment = NSTextAlignmentCenter;
                [subView addSubview:titleLable];
                
                UIView *line = [[UIView alloc]initWithFrame:CGRectMake(subView.width/2-25, 60, 50, 0.5)];
                line.backgroundColor = [kSeparatorLineColor colorWithAlphaComponent:0.5];
                [subView addSubview:line];
                
                UITextField *contentTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 40, subView.width, 20)];
                contentTF.delegate = self;
                contentTF.backgroundColor = [UIColor clearColor];
                contentTF.font = [UIFont systemFontOfSize:13.0];
                contentTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_placehodersArr[index] attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                contentTF.textColor = [UIColor grayColor];
                contentTF.textAlignment = NSTextAlignmentCenter;
                contentTF.tag =index;
                [subView addSubview:contentTF];
                [_textFieldArr addObject:contentTF];
                index++;
            }
        }
    }
    return _detailInfoView;
}
-(UIView *)ImageInfoView
{
    if(!_ImageInfoView){
        _ImageInfoView = [[UIView alloc]initWithFrame:CGRectMake(0,self.detailInfoView.bottom+40, kMainBoundsWidth, 130*Proportion)];
        _ImageInfoView.userInteractionEnabled = YES;
        [_backScroll addSubview:_ImageInfoView];
        NSArray *placeImgs = @[@"info01",@"info02",@"info03"];
        for (int i=0; i<3; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake((90*Proportion+10)*i+15, 0, 90*Proportion, 130*Proportion)];
            img.backgroundColor = [UIColor redColor];
            [_ImageInfoView addSubview:img];
            img.userInteractionEnabled = YES;
            [img sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:placeImgs[i]]];
            img.tag = i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgTap:)];
            [img addGestureRecognizer:tap];
            [_ImgArr addObject:img];
        }
        [_backScroll addSubview:_ImageInfoView];
    }
    return _ImageInfoView;
}



-(void)imgTap:(UIGestureRecognizer *)tap
{
    _selectImgView = (UIImageView *)tap.view;
    _PhotoActionSheet =[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
    _PhotoActionSheet.delegate = self;
    _PhotoActionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
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
    [_selectImgView setImage:image];
    NSInteger index = _selectImgView.tag;
    _upLoadImgArr[index] = image;
    //_imgData = UIImageJPEGRepresentation(_upload_image, 1.0);
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_selectImgView setImage:image];
    NSInteger index = _selectImgView.tag;
    _upLoadImgArr[index] = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)handleOrderClick:(id)sender {
    [self submitInfoRequest];
}

-(void)saveBtnClick
{
    [self submitInfoRequest];
}

-(void)submitInfoRequest
{
    
    //    for (UITextField *tf in _textFieldArr) {
    //        if([Helper isBlankString:tf.text]){
    //            [HDHud showMessageInView:self.view title:@"请填写全部信息"];
    //        }
    //    }
    //    [_upLoadImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        if([obj isKindOfClass:[NSString class]]){
    //            [HDHud showMessageInView:self.view title:@"请上传体位评估照片"];
    //        }
    //    }];
    //信息
    __block NSMutableDictionary *pragma = [NSMutableDictionary dictionary];
    NSArray *keysArr = @[@"age",@"sex",@"height",@"weight",@"habitusExp",@"waist",@"hipline",@"hiplineRatio",@"bodyFat",@"metabolismRatio",@"stillHeartbeat",@"bloodPressure"];
    [_textFieldArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *tf = (UITextField *)obj;
        if([Helper RemoveStringWhiteSpace:tf].length>0){
            if (tf.tag==1) {
                NSString *sex = [tf.text isEqualToString:@"男"]?@"1":@"2";
                [pragma setValue:sex forKey:keysArr[tf.tag]];
            }else
                [pragma setValue:tf.text forKey:keysArr[tf.tag]];
        }
    }];
    //照片
    NSMutableArray *imgDataArr = [NSMutableArray array];
    NSMutableArray *imgNameArr = [NSMutableArray array];
    NSArray *imgnames = @[@"frontImage",@"sideImage",@"rearImage"];
    [_upLoadImgArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIImage class]]){
            NSData *imgData = UIImageJPEGRepresentation((UIImage *)obj, 0.4);
            [imgDataArr addObject:imgData];
            [imgNameArr addObject:imgnames[idx]];
        }
    }];
    if(!_isSaveInfo){
        pragma = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UserInfo sharedUserInfo].token,@"token", nil];
        [HDHud showHUDInView:self.view title:@"加载中"];
    }else{
        if([pragma allKeys].count==0 && _isSaveInfo==YES){
            [HDHud showHUDInView:self.view title:@"请先填写信息"];
            return;
        }
        [HDHud showHUDInView:self.view title:@"正在保存"];
        [pragma setValue:[UserInfo sharedUserInfo].token forKey:@"token"];
    }
    HttpRequest *request = [[HttpRequest alloc]init];
    [request RequestDataWithUrl:URL_submitUserInfo pragma:pragma ImageDatas:imgDataArr imageName:imgNameArr];
    [request getResultWithSuccess:^(id response) {
        if(!_isSaveInfo){
            _userInfoDict = (NSDictionary *)[response firstObject];
            [self setupDatas];
            _isSaveInfo = YES;
            [HDHud hideHUDInView:self.view];
        }else{
            [HDHud showMessageInView:self.view title:@"保存成功"];
        }
    } DataFaiure:^(id error) {
        NSString *message = (NSString *)error;
        [HDHud showMessageInView:self.view title:message];
    } Failure:^(id error) {
        [HDHud showNetWorkErrorInView:self.view];
    }];
}

@end

