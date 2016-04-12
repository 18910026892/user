//
//  SubItem.h
//  YYAnimationTabBar
//
//  Created by 王园园 on 15/10/26.
//  Copyright © 2015年 王园园. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Item : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imageStr;
@property (nonatomic,copy) NSString *imageStr_s;
-(instancetype)initItemWithDictionary:(NSDictionary *)dict;
@end




typedef void(^Complete)();

@interface SubItem : UIView

@property(nonatomic,strong)Item *item;

@property (nonatomic) NSInteger badge;

@property (nonatomic) BOOL showBadge;




@property (nonatomic) NSLayoutConstraint *badgeWidthConstraint;


-(void)setItemSlected:(Complete)finish;
-(void)setItemNomal;

@end
