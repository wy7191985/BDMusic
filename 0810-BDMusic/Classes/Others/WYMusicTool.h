//
//  WYMusicTool.h
//  0810-BDMusic
//
//  Created by yanyin on 15/8/10.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WYMusic;
@interface WYMusicTool : NSObject
/**
 *  模型数组
 */
+ (NSArray *)musics;
/**
 *  正在播放的歌曲
 */
+ (WYMusic *)playingMusic;
/**
 *  上一首歌曲
 */
+ (WYMusic *)previousMusic;
/**
 *  下一首歌曲
 */
+ (WYMusic *)nextMusic;
/**
 *  设置正在播放的歌曲
 */
+ (void)setPlayingMusic:(WYMusic *)playingMusic;

@end
