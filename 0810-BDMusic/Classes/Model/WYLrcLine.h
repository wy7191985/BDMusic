//
//  WYLrcLine.h
//  0810-BDMusic
//
//  Created by wangyue on 15/8/13.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  每一行歌词的模型
 */
@interface WYLrcLine : NSObject
/** 歌词时间*/
@property (nonatomic, copy) NSString *time;
/** 每一行的文字*/
@property (nonatomic, copy) NSString *word;

@end
