//
//  JLVideoPlayerViewController.h
//  Accompany
//
//  Created by 王园园 on 16/1/26.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JLVideoItemModel.h"
@interface JLVideoPlayerViewController : UIViewController
@property(nonatomic,strong)NSArray *videosList;
@property(nonatomic,assign) NSInteger currentIndex;
@property(nonatomic,strong)JLVideoItemModel *movieModel;
@property (nonatomic,strong)NSURL *movieURL;
@end
