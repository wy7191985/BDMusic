//
//  WYAudioTool.h
//  0808-播放音效
//
//  Created by wangyue on 15/8/8.
//  Copyright (c) 2015年 wangyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WYAudioTool : NSObject
/**
 *  播放音效
 */
+ (void)palySound:(NSString *)filename;
/**
 *  停止音效
 */
+ (void)stopSound:(NSString *)filename;

//-------------------------------------

/**
 *  播放音乐
 */
+ (AVAudioPlayer *)playMusic:(NSString *)filename;
/**
 *  暂停音乐
 */
+ (void)pauseMusic:(NSString *)filename;
/**
 *  停止音乐
 */
+ (void)stopMusic:(NSString *)filename;


@end
