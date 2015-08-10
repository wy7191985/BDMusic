//
//  WYMusicCell.h
//  0810-BDMusic
//
//  Created by yanyin on 15/8/10.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WYMusic;
@interface WYMusicCell : UITableViewCell


//快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

//cell模型
@property (nonatomic, strong) WYMusic *music;


@end
