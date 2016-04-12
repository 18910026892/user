//
//  JLPostListCell.m
//  Accompany
//
//  Created by 王园园 on 16/2/20.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPostListCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "JLPostListModel.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Category.h"
#import "Helper+Date.h"
#import "JLPostUserInfoModel.h"
#import "UIImageView+WebCache.h"
#define Margin 2.0
@interface JLPostListCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImgViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UILabel *introlLable;
@property (weak, nonatomic) IBOutlet UIView *imagesView;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIView *bottomImgsView;
@property (weak, nonatomic) IBOutlet UIButton *leftZanBtn;
@property (nonatomic,strong)NSMutableArray *ImageArr;
@property (nonatomic,strong)JLPostListModel *infoModel;
- (IBAction)zanBtnClick:(id)sender;
- (IBAction)commentBtnClick:(id)sender;
- (IBAction)shreBtnClick:(id)sender;

- (IBAction)leftZanBtnClick:(id)sender;
- (IBAction)attentionBtnClick:(id)sender;
- (IBAction)deleteBtnClick:(id)sender;

@end

@implementation JLPostListCell

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor =  [UIColor clearColor];
    _leftZanBtn.layer.cornerRadius = _leftZanBtn.height/2;
    _leftZanBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _leftZanBtn.layer.borderWidth = 1.0;
    _attentionBtn.layer.cornerRadius = _attentionBtn.height/2;
    _attentionBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _attentionBtn.layer.borderWidth = 1.0;
    _ImageArr = [[NSMutableArray alloc]initWithCapacity:9];
    _userImg.layer.masksToBounds = YES;
    _userImg.layer.borderColor = [UIColor grayColor].CGColor;
    _userImg.layer.borderWidth = 0.5;
    _userImg.layer.cornerRadius = _userImg.height/2;
    _userImg.layer.shouldRasterize = YES;
    _userImg.layer.rasterizationScale = _userImg.layer.contentsScale;
    _userImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(userImageTap:)];
    [_userImg addGestureRecognizer:tap];
    
    for (int i=0; i<9; i++) {
        
        float i_wight = 40;
        float i_x = (i_wight+Margin)*(i%3)+15;
        float i_y = (i_wight+Margin)*(i/3);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i_x, i_y, i_wight, i_wight)];
        img.tag = 5000+i;
        [_imagesView addSubview:img];
    }
}

-(void)fillPostDetailCellWithObject:(id)object admireListArr:(NSArray *)admireArr;
{
    JLPostListModel *model = (JLPostListModel *)object;
    [self fillCellWithObject:model];
    _shareBtn.hidden = YES;
    _zanBtn.hidden = YES;
    _commentBtn.hidden = YES;
    _bottomImgsView.hidden = NO;
    _attentionBtn.hidden = NO;
    _leftZanBtn.hidden = NO;
    if([model.grssUser.userId isEqualToString:[UserInfo sharedUserInfo].userId]){
        _attentionBtn.hidden = YES;
    }else{
        if(model.grssUser.followRelationship.integerValue==0){
            [_attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }else if((model.grssUser.followRelationship.integerValue==1)){
            [_attentionBtn setTitle:@"√已关注" forState:UIControlStateNormal];
        }else{
            [_attentionBtn setTitle:@"互相关注" forState:UIControlStateNormal];
        }
    }
    NSInteger zanNum = admireArr.count;
    NSInteger maxNum = _bottomImgsView.width/13-1;
    for(int i=0;i<zanNum;i++){
        JLPostUserInfoModel *model = (JLPostUserInfoModel *)admireArr[i];
        UIImageView *subImg = [[UIImageView alloc]initWithFrame:CGRectMake(13*i, 4, 22, 22)];
        subImg.backgroundColor = GXRandomColor;
        subImg.layer.cornerRadius = subImg.width/2;
        subImg.layer.borderWidth = 0.5;
        subImg.layer.borderColor = [UIColor grayColor].CGColor;
        subImg.layer.masksToBounds = YES;
        [_bottomImgsView addSubview:subImg];
        [subImg sd_setImageWithURL:[NSURL URLWithString:model.userPhoto] placeholderImage:[UIImage imageNamed:@"morentou-"]];
        if(i==maxNum){
            subImg.image = nil;
            subImg.backgroundColor = [UIColor blueColor];
            return;
        }
    }
}

- (void)fillCellWithObject:(id)object;
{
    JLPostListModel *model = (JLPostListModel *)object;
    _infoModel = model;
    _nameLable.text = model.grssUser.nikeName;
    NSDate *date = [Helper dateValueWithString:model.sendDate ByFormatter:@"yyyy-MM-dd HH:mm:ss"];
    _timeLable.text = [Helper DescriptionWithDate:date];
    _titleLable.text = model.title;
    _introlLable.text = model.idea;
    _deleteBtn.hidden = YES;
    if([model.grssUser.userId isEqualToString:[UserInfo sharedUserInfo].userId]){
        _shareBtn.hidden = YES;
        _deleteBtn.hidden = NO;
    }
    if(model.isAdmire.integerValue==1){
        [_zanBtn setImage:[UIImage imageNamed:@"zan_red"] forState:UIControlStateNormal];
        [_leftZanBtn setImage:[UIImage imageNamed:@"zan_red"] forState:UIControlStateNormal];
    }else{
        [_zanBtn setImage:[UIImage imageNamed:@"zan_gray"] forState:UIControlStateNormal];
        [_leftZanBtn setImage:[UIImage imageNamed:@"zan_gray"] forState:UIControlStateNormal];
    }
    [_userImg sd_setImageWithURL:[NSURL URLWithString:model.grssUser.userPhoto] placeholderImage:[UIImage imageNamed:@"fangxing-touxiang"]];
    NSInteger imgNum =  [model.imageUrls count];
    float imgsViewHeigh =[JLPostListCell heightForImgsNum:imgNum];
    _ImgViewHeightConstraint.constant = imgsViewHeigh;
    
    _ImageArr = [[NSMutableArray alloc]initWithCapacity:9];
    for (int i=0; i<imgNum; i++) {
        
        float i_wight = 90;
        float i_x = 15;
        float i_y = 0;
        if(imgNum>1 &&imgNum<=3){
            i_wight = 80;
            i_x = (i_wight+Margin)*i+15;
            i_y = 0;
        }else if(imgNum==4){
            i_wight = 55;
            i_x = (i_wight+Margin)*(i%2)+15;
            i_y = (i_wight+Margin)*(i/2);
        }else if(imgNum>4){
            i_wight = (imgNum>6)?40:55;
            i_x = (i_wight+Margin)*(i%3)+15;
            i_y = (i_wight+Margin)*(i/3);
        }
        UIImageView *img = (UIImageView *)[_imagesView viewWithTag:5000+i];
        img.frame = CGRectMake(i_x, i_y, i_wight, i_wight);
        [img sd_setImageWithURL:[NSURL URLWithString:model.imageUrls[i]] placeholderImage:[UIImage imageNamed:@"changguan-"]];

        img.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImgViewClick:)];
        [img addGestureRecognizer:tap];
        [_ImageArr addObject:model.imageUrls[i]];
    }
}

+ (CGFloat)rowHeightForObject:(id)object;
{
    JLPostListModel *model = (JLPostListModel *)object;
    
    NSString *introlStr =model.idea;
    float introlHeight = [Helper heightForLabelWithString:introlStr withFontSize:13.0 withWidth:kMainBoundsWidth-20 withHeight:1000];
    float addHeight = introlHeight>16?introlHeight-16:0;
    float cellOringeHeight = 135;
    
    NSInteger imgNum =  [model.imageUrls count];
    float imgsViewHeigh =[self heightForImgsNum:imgNum];
    return cellOringeHeight+addHeight + imgsViewHeigh;
}

+(float)heightForImgsNum:(NSInteger)num
{
    switch (num) {
        case 0:
            return 0.0;
            break;
        case 1:
            return 90.0;
            break;
        case 2:
        case 3:
            return 80.0;
            break;
        case 4:
        case 5:
        case 6:
            return 110.0+Margin;
            break;
        default:
            return 120.0+2*Margin;
            break;
    }
}


-(void)uploadImgViewClick:(UIGestureRecognizer *)gesture
{
    //进入预览大图
    UIImageView *imgView = (UIImageView *)gesture.view;
    [self browseImages:_ImageArr index:imgView.tag-5000 touchImageView:imgView];
}

#pragma mark - image browser
- (void)browseImages:(NSArray *)imageArr index:(NSInteger)index touchImageView:(UIImageView *)touchImageView{
    NSInteger count = imageArr.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = imageArr[i];
        photo.srcImageView = touchImageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)zanBtnClick:(id)sender {
    if(_delegate){
        [_delegate postCellzanBtn:sender clickedWithData:_infoModel];
    }
}

- (IBAction)commentBtnClick:(id)sender {
    if(_delegate){
        [_delegate postCellcommentBtn:sender clickedWithData:_infoModel];
    }
}

- (IBAction)shreBtnClick:(id)sender {
    if(_delegate){
        [_delegate postCellshareBtn:sender clickedWithData:_infoModel];
    }
}

- (IBAction)leftZanBtnClick:(id)sender {
    if(_delegate){
        [_delegate postCellzanBtn:sender clickedWithData:_infoModel];
    }
}

- (IBAction)attentionBtnClick:(id)sender {
    if(_delegate){
        [_delegate postCellattentionBtn:sender clickedWithData:_infoModel];
    }
}

- (IBAction)deleteBtnClick:(id)sender {
    if(_delegate){
        [_delegate postCelldeleteBtn:sender clickedWithData:_infoModel];
    }
}

-(void)userImageTap:(UIGestureRecognizer *)gesture
{
    if(_delegate){
        [_delegate postCell:self userImageTapWithData:_infoModel];
    }
}
@end
