//
//  WYLyricCell.h
//  0810-BDMusic
//
//  Created by yanyin on 15/8/13.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYLrcLine;
@interface WYLyricCell : UITableViewCell

//快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** 每行歌词的模型*/
@property (nonatomic, strong) WYLrcLine *line;

@end
