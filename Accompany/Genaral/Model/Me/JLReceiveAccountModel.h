//
//  JLReceiveAccountModel.h
//  Accompany
//
//  Created by 王园园 on 16/1/28.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseModel.h"

@interface JLReceiveAccountModel : BaseModel

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *cardNum;
@property(nonatomic,copy)NSString *bankName;
@property(nonatomic,copy)NSString *bankId;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *cityId;

@end
