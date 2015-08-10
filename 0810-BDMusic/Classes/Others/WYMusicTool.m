//
//  WYMusicTool.m
//  0810-BDMusic
//
//  Created by yanyin on 15/8/10.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import "WYMusicTool.h"
#import "WYMusic.h"
#import "MJExtension.h"

@implementation WYMusicTool
/**
 *  模型数组
 */
static NSArray *_musics;

+ (NSArray *)musics
{
    if (!_musics) {
        _musics = [WYMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
    
}
/**
 *  保存正在播放的歌曲
 */
static WYMusic *_playingMusic;
/**
 *  设置正在播放的歌曲
 */
+ (void)setPlayingMusic:(WYMusic *)playingMusic
{
    // 1.当传进来的歌曲为空或者模型数组里没有的,直接返回
    if (!playingMusic || ![[self musics] containsObject:playingMusic]) return;
    // 2.要播放的是正在播放的歌曲,直接返回
    if (_playingMusic == playingMusic) return;
    // 3.存储正在播放的歌曲
    _playingMusic = playingMusic;
    
}

/**
 *  正在播放的歌曲
 */
+ (WYMusic *)playingMusic
{
    return _playingMusic;
}
/**
 *  上一首歌曲
 */
+ (WYMusic *)previousMusic
{
    NSInteger previousIndex = 0;
    if (_playingMusic) {  //正在播放歌曲
        //获得播放歌曲的索引
        NSInteger playingIndex = [[self musics] indexOfObject:_playingMusic];
        previousIndex = playingIndex - 1;
        if (previousIndex < 0) {
            previousIndex = [self musics].count - 1;
        }
    }
    return [self musics][previousIndex];
}
/**
 *  下一首歌曲
 */
+ (WYMusic *)nextMusic
{
    NSInteger nextIndex = 0;
    if (_playingMusic) {  //正在播放歌曲
        //获得播放歌曲的索引
        NSInteger playingIndex = [[self musics] indexOfObject:_playingMusic];
        nextIndex = playingIndex + 1;
        if (nextIndex >= [self musics].count) {
            nextIndex = 0;
        }
    }
    return [self musics][nextIndex];
}


@end
