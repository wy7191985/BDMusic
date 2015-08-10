//
//  WYMusic.h
//  0810-BDMusic
//
//  Created by yanyin on 15/8/10.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYMusic : NSObject
/** 歌曲名*/
@property (nonatomic, copy) NSString *name;
/** mp3文件名*/
@property (nonatomic, copy) NSString *filename;
/** 歌词文件名*/
@property (nonatomic, copy) NSString *lrcname;
/** 演唱者*/
@property (nonatomic, copy) NSString *singer;
/** 演唱者头像*/
@property (nonatomic, copy) NSString *singerIcon;
/** 封面*/
@property (nonatomic, copy) NSString *icon;



@end
