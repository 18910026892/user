//
//  StadiumCollectionViewCell.m
//  Accompany
//
//  Created by 巩鑫 on 16/1/23.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "StadiumCollectionViewCell.h"

@implementation StadiumCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    

        
    }
    return self;
}



-(void)setStadiumCollectionModel:(StadiumCollectionModel *)stadiumCollectionModel
{
    _stadiumCollectionModel = stadiumCollectionModel;
    //初始化视图;
    
}

@end
