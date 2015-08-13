//
//  WYLyricView.h
//  0810-BDMusic
//
//  Created by wangyue on 15/8/12.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import "DRNRealTimeBlurView.h"

@interface WYLyricView : DRNRealTimeBlurView

/** 歌词文件名*/
@property (nonatomic, copy) NSString *lrcname;

/** 当前播放时间*/
@property (nonatomic, assign) NSTimeInterval currentTime;

@end
