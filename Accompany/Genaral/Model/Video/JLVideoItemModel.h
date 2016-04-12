//
//  JLVideoItemModel.h
//  Accompany
//
//  Created by 王园园 on 16/3/13.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "BaseModel.h"

@interface JLVideoItemModel : BaseModel

@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *catId;
@property(nonatomic,copy)NSString *updateDate;
@property(nonatomic,copy)NSString *uploadDate;
@property(nonatomic,copy)NSString *videoId;

@end
