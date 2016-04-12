//
//  BaseView.m
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseView.h"


#import "BaseView.h"

@implementation BaseView
+(id)loadFromXib
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil]lastObject];
}

-(void)viewLayoutWithData:(id)data{
    
    
}



@end
