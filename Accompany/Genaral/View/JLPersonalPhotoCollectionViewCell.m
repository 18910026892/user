//
//  JLPersonalPhotoCollectionViewCell.m
//  Accompany
//
//  Created by GongXin on 16/1/29.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLPersonalPhotoCollectionViewCell.h"

@implementation JLPersonalPhotoCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //图片视图
        _PhotoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0*Proportion,0*Proportion, 90*Proportion,90*Proportion)];
        _PhotoImageView.backgroundColor = GXRandomColor;
        [self.contentView addSubview:_PhotoImageView];
        
    }
    return self;
}
@end
