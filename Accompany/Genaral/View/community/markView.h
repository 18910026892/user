//
//  markView.h
//  Accompany
//
//  Created by 王园园 on 16/2/22.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class markView;
@protocol markViewDelegate <NSObject>

-(void)markView:(markView *)view deleteMarkWith:(NSString *)string;
-(void)markView:(markView *)view panTagView:(UIPanGestureRecognizer *)sender;
@end

@interface markView : UIView

@property(nonatomic,copy)NSString *contentStr;


@property(nonatomic,strong) id<markViewDelegate>delegate;
-(id)initWithString:(NSString *)string;
-(void)showCancelBtn:(BOOL)state;
@end
