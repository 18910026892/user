//
//  JLArowInputCell.h
//  Accompany
//
//  Created by 王园园 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseCell.h"


@interface JLArowInputCell : BaseCell

@property(nonatomic,copy)NSString *title;
-(void)fillCellWithString:(NSString*)Str WithColor:(UIColor*)color;

@end
