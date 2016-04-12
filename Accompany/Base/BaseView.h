//
//  BaseView.h
//  Accompany
//
//  Created by 王园园 on 16/1/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseView : UIView

+(id)loadFromXib;

-(void)viewLayoutWithData:(id)data;

+ (CGFloat)rowHeightForObject:(id)object;

@end
