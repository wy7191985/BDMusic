//
//  WYLyricCell.m
//  0810-BDMusic
//
//  Created by yanyin on 15/8/13.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import "WYLyricCell.h"
#import "WYLrcLine.h"

@implementation WYLyricCell

//快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"lrc";
    WYLyricCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (!cell) {
        cell = [[WYLyricCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
    
}

- (void)setLine:(WYLrcLine *)line
{
    _line = line;
    //设置cell属性
    self.textLabel.text = line.word;
}

@end
