//
//  JLAVPlayerHelper.h
//  Accompany
//
//  Created by 王园园 on 16/1/26.
//  Copyright © 2016年 GX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface JLAVPlayerHelper : NSObject

- (AVPlayer *)getAVPlayer;
- (void)initAVPlayerWithAVPlayerItem:(AVPlayerItem *)item;
- (void)setAVPlayerVolume:(float)volume;

@end
