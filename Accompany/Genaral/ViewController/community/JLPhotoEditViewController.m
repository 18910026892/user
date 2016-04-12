//
//  JLPhotoEditViewController.m
//  Accompany
//
//  Created by 王园园 on 16/2/19.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPhotoEditViewController.h"
#import "ImageUtil.h"
#import "ColorMatrix.h"
#import "IphoneScreen.h"
#import "markView.h"

@interface JLPhotoEditViewController ()<UITextFieldDelegate,markViewDelegate>
{
    UIScrollView *scrollerView;
}
@property (nonatomic,retain)UITextField *textfield;
@property (nonatomic,retain)UIView * markView;


@property (weak, nonatomic) IBOutlet UIView *imgBackView;
@property (weak, nonatomic) IBOutlet UIButton *lujingBtn;
@property (weak, nonatomic) IBOutlet UIButton *markBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property(nonatomic,strong)UIImage *editedImg;
@property(nonatomic,strong)UIImageView *tempImgView;

@property(nonatomic,strong)UIImageView *editImageView;
@property(nonatomic,strong)NSMutableArray *markArr;

- (IBAction)lvjingBtnClick:(id)sender;
- (IBAction)markBtnClick:(id)sender;

@end

@implementation JLPhotoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavTitle:@"照片修饰"];
    [self setTabBarHide:YES];
    [self showBackButton:YES];
    [self setupDatas];
    [self setupViews];
}

-(void)setupViews
{
    [HDHud showHUDInView:self.view title:@"初始化"];
    self.enableIQKeyboardManager = YES;
    self.enableKeyboardToolBar = NO;
    [self.RightBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.RightBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.RightBtn setTitleColor:kTabBarItemSelectColor forState:UIControlStateNormal];
    _lujingBtn.layer.cornerRadius = 14;
    _lujingBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _lujingBtn.layer.borderWidth = 1.0;
    _markBtn.layer.cornerRadius = 14;
    _markBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _markBtn.layer.borderWidth = 1.0;
    [_lujingBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [_markBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    _lujingBtn.selected = YES;
    _lujingBtn.layer.borderColor = [UIColor grayColor].CGColor;
}

-(void)setupDatas
{
    _markArr = [NSMutableArray arrayWithCapacity:5];
    _editedImg = _origeImg;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBackViewTap:)];
    [_imgBackView addGestureRecognizer:tap];
    float i_scale =1;
    if(_origeImg.size.width/_origeImg.size.height>=1){//横向图片
        i_scale = (float)(_imgBackView.width/_origeImg.size.width);
    }else{//竖方向图片
        i_scale = (float)(_imgBackView.height/_origeImg.size.height);
    }
    CGRect rect = CGRectMake(_imgBackView.width/2-(_origeImg.size.width*i_scale)/2, _imgBackView.height/2-(_origeImg.size.height*i_scale)/2, _origeImg.size.width*i_scale, _origeImg.size.height*i_scale);
    _editImageView = [[UIImageView alloc]initWithFrame:rect];
    _editImageView.contentMode = UIViewContentModeScaleAspectFit;
    _editImageView.image = _editedImg;
    _editImageView.userInteractionEnabled = YES;
    _editImageView.backgroundColor = [UIColor blueColor];
    [_imgBackView addSubview:_editImageView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setSpecialEffectView];
}
-(void)imgBackViewTap:(UIGestureRecognizer *)gesture
{
    [_markArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        markView *markview = (markView *)obj;
        [markview showCancelBtn:NO];
    }];
}

-(void)nextBtnClick
{
    _editedImg = [self screenShot];
    [[NSNotificationCenter defaultCenter] postNotificationName:KN_FINISHEDITPHOTO object:_editedImg];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 
#pragma mark - 滤镜效果
-(void)setSpecialEffectView
{
    NSArray *arr = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐色",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色", nil];
    if(!scrollerView){
        scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 5, kMainBoundsWidth-10, _bottomView.height-15)];
        scrollerView.backgroundColor = [UIColor clearColor];
        scrollerView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        scrollerView.showsHorizontalScrollIndicator = NO;
        scrollerView.showsVerticalScrollIndicator = NO;//关闭纵向滚动条
        scrollerView.bounces = NO;
        
        float i_Height = scrollerView.height;
        float i_wigth = 60;
        for(int i=0;i<14;i++)
        {
            float x = (i_wigth+3)*i;
            UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(x,0,i_wigth, i_Height)];
            [bgImageView setTag:i];
            [bgImageView setUserInteractionEnabled:YES];
            UIImage *bgImage = [self changeImage:i imageView:nil];
            bgImageView.image = bgImage;
            [scrollerView addSubview:bgImageView];
            
            UILabel *lable = [UILabel labelWithFrame:CGRectMake(0, bgImageView.height-20, bgImageView.width, 20) text:arr[i] textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:13.] backgroundColor:[UIColor clearColor] alignment:NSTextAlignmentCenter];
            [bgImageView addSubview:lable];
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setImageStyle:)];
            [bgImageView addGestureRecognizer:recognizer];
            //默认原图
            if(i==0){
                _tempImgView = bgImageView;
                _tempImgView.layer.borderWidth = 2;
                _tempImgView.layer.borderColor = RGBACOLOR(52., 121., 237., 1).CGColor;
            }
        }
        scrollerView.contentSize = CGSizeMake(arr.count*(i_wigth+3), 80);
        [_bottomView addSubview:scrollerView];
    }
    _bottomView.hidden = NO;
    _markView.hidden = YES;
    [HDHud hideHUDInView:self.view];
}
- (void)setImageStyle:(UITapGestureRecognizer *)sender
{
    UIImageView *imgVIew = (UIImageView *)sender.view;
    if(_tempImgView == imgVIew){
        return;
    }
    imgVIew.layer.borderWidth = 2;
    imgVIew.layer.borderColor = RGBACOLOR(52., 121., 237., 1).CGColor;
    _tempImgView.layer.borderWidth = 0;
    _tempImgView.layer.borderColor = [UIColor clearColor].CGColor;
    _tempImgView = imgVIew;
    _editedImg =  [self changeImage:sender.view.tag imageView:nil];
    [_editImageView setImage:_editedImg];
}

-(UIImage *)changeImage:(NSInteger)index imageView:(UIImageView *)imageView
{
    UIImage *image;
    switch (index) {
        case 0:
        {
            return _origeImg;
        }
            break;
        case 1:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_lomo];
        }
            break;
        case 2:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_heibai];
        }
            break;
        case 3:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_huajiu];
        }
            break;
        case 4:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_gete];
        }
            break;
        case 5:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_ruise];
        }
            break;
        case 6:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_danya];
        }
            break;
        case 7:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_jiuhong];
        }
            break;
        case 8:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_qingning];
        }
            break;
        case 9:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_langman];
        }
            break;
        case 10:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_guangyun];
        }
            break;
        case 11:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_landiao];
            
        }
            break;
        case 12:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_menghuan];
            
        }
            break;
        case 13:
        {
            image = [ImageUtil imageWithImage:_origeImg withColorMatrix:colormatrix_yese];
        }
    }
    return image;
}



#pragma mark - BtnClick
- (IBAction)lvjingBtnClick:(id)sender {
    _lujingBtn.selected = YES;
    _markBtn.selected = NO;
    _lujingBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _markBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self setSpecialEffectView];
}

- (IBAction)markBtnClick:(id)sender {
    _lujingBtn.selected = NO;
    _markBtn.selected = YES;
    _lujingBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _markBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [self setMarkView];
}


-(void)setMarkView
{
    if(!_markView){
        _markView = [[UIView alloc] initWithFrame:CGRectMake(-1, kMainBoundsHeight-49, 322, 50)];
        _markView.backgroundColor = RGBACOLOR(30., 32., 35., 1);
        _markView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        _markView.layer.borderWidth = 0.5;
        [self.view addSubview:_markView];
        
        _textfield = [[UITextField alloc]initWithFrame:CGRectMake(10,6, kMainBoundsWidth-20, 36)];
        [_textfield setBorderStyle:UITextBorderStyleNone];
        _textfield.delegate = self;
        _textfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  添加标签（最多10个字）" attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        _textfield.textColor = [UIColor whiteColor];
        _textfield.returnKeyType = UIReturnKeyDone;
        _textfield.backgroundColor = [UIColor clearColor];
        _textfield.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        _textfield.layer.borderWidth = 0.5f;
        _textfield.layer.cornerRadius = 4.0f;
        [_markView addSubview:_textfield];
    }
    _bottomView.hidden = YES;
    _markView.hidden = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"发送");
    [_textfield resignFirstResponder];
    if(_markArr.count==5){
        [HDHud showMessageInView:self.view title:@"最多只能添加5个标签"];
        return YES;
    }
    if(textField.text.length==0||textField.text.length>10){
        [HDHud showMessageInView:self.view title:@"请输入10个字以内的标签"];
    }else{
        [self showSubMarkViewWithString:textField.text];
    }
   
    return YES;
}

-(void)showSubMarkViewWithString:(NSString *)str
{
    markView *markview = [[markView alloc]initWithString:str];
    float m_x = arc4random() % ((int)_editImageView.width-60);
    float m_y = arc4random() % ((int)_editImageView.height-40);
    markview.frame = CGRectMake(m_x, m_y, markview.width, markview.height);
    markview.delegate = self;
    [_editImageView addSubview:markview];
     [_markArr addObject:markview];
    _textfield.text = @"";
}

#pragma mark - markViewDelegate
//delete mark
-(void)markView:(markView *)view deleteMarkWith:(NSString *)string;
{
    if([_markArr containsObject:view]){
        [_markArr removeObject:view];
    }
}
//drag mark
-(void)markView:(markView *)view panTagView:(UIPanGestureRecognizer *)sender;
{
    markView *mark =(markView *)sender.view;
    CGPoint point = [sender locationInView:_editImageView];
    if(point.x>=(_editImageView.width-mark.width/2+20) || point.x<=mark.width/2 || point.y>=(_editImageView.height-19) || point.y<=19){
        return;
    }
    [mark setCenter:point];
}

-(UIImage *) screenShot
{
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect rect =  CGRectMake(_editImageView.origin.x, 64+_editImageView.origin.y, _editImageView.width, _editImageView.height);//要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
    CGImageRef cgimg = CGImageCreateWithImageInRect([image CGImage], rect);
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);//用完一定要释放，否则内存泄露
    return newImg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
