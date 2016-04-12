//
//  JLAVPlayerHelper.m
//  Accompany
//
//  Created by 王园园 on 16/1/26.
//  Copyright © 2016年 GX. All rights reserved.
//

#import "JLAVPlayerHelper.h"

@interface JLAVPlayerHelper()
{
    AVPlayer *player;
}
@end

@implementation JLAVPlayerHelper
- (AVPlayer *)getAVPlayer {
    if (player) {
        return player;
    }
    return nil;
}

- (void)initAVPlayerWithAVPlayerItem:(AVPlayerItem *)item {
    player = [[AVPlayer alloc] initWithPlayerItem:item];
}
- (void)setAVPlayerVolume:(float)volume {
    [player setVolume:volume];
}

@end
