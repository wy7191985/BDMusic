//
//  WYAudioTool.m
//  0808-播放音效
//
//  Created by wangyue on 15/8/8.
//  Copyright (c) 2015年 wangyue. All rights reserved.
//

#import "WYAudioTool.h"

@implementation WYAudioTool

/**
 *  存放音效ID
 */
static NSMutableDictionary *_soundIDs;

+ (void)initialize
{
    _soundIDs = [NSMutableDictionary dictionary];
}
/**
 *  播放音效
 */
+ (void)palySound:(NSString *)filename
{
    // 1.当传入的音效名为空，直接返回
    if (!filename) return;
    // 2.从字典中取出音效ID
    SystemSoundID soundID = [_soundIDs[filename] unsignedIntValue];
    if (!soundID) {  // 3.字典中没有音效ID
        //获取音效文件的url
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url) return; //无法获得url
        //创建音效ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        //将音效ID包装成对象存进字典
        _soundIDs[filename] = @(soundID);
    }
    // 4.播放音效
    AudioServicesPlaySystemSound(soundID);
    
}
/**
 *  停止音效
 */
+ (void)stopSound:(NSString *)filename
{
    // 1.当传入的音效名为空，直接返回
    if (!filename) return;
    // 2.从字典中取出音效ID
    SystemSoundID soundID = [_soundIDs[filename] unsignedIntValue];
    if (soundID) { // 3.字典中有音效ID
        //销毁音效ID
        AudioServicesDisposeSystemSoundID(soundID);
        //从字典中移除
        [_soundIDs removeObjectForKey:filename];
    }
    
}
//----------------------------------------------------------------------------
/**
 *  存放播放器
 */
static NSMutableDictionary *_musicPlayer;

+ (NSMutableDictionary *)musicPlayer
{
    if (!_musicPlayer) {
        _musicPlayer = [NSMutableDictionary dictionary];
    }
    return _musicPlayer;   
}

/**
 *  播放音乐
 */
+ (AVAudioPlayer *)playMusic:(NSString *)filename
{
    // 1.当传入的音效名为空，直接返回
    if (!filename) return nil;
    // 2.取出对应的播放器
    AVAudioPlayer *player = [self musicPlayer][filename];
    if (!player) { // 3.字典中没有该播放器
        //获得音乐url
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        //ulr为空,直接返回
        if (!url) return nil;
        //创建播放器
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        //缓冲失败,直接返回
        if (![player prepareToPlay]) return nil;
        //播放器存入字典
        [self musicPlayer][filename] = player;
        
    }
    // 3.播放音乐
    if (![player isPlaying]) {  //没有在播放音乐
        [player play];
    }
    return player;  //正在播放返回yes
}
/**
 *  暂停音乐
 */
+ (void)pauseMusic:(NSString *)filename
{
    // 1.当传入的音效名为空，直接返回
    if (!filename) return;
    // 2.取出对应的播放器
    AVAudioPlayer *player = [self musicPlayer][filename];
    // 3.暂停音乐
    [player pause];
    
}
/**
 *  停止音乐
 */
+ (void)stopMusic:(NSString *)filename
{
    // 1.当传入的音效名为空，直接返回
    if (!filename) return;
    // 2.取出对应的播放器
    AVAudioPlayer *player = [self musicPlayer][filename];
    // 3.停止音乐
    [player stop];
    // 4.从字典中移除
    [[self musicPlayer] removeObjectForKey:filename];
    
}
@end
