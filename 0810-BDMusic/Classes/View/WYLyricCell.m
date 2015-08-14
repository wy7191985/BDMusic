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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //设置cell属性
        self.backgroundColor = [UIColor clearColor];
        //cell没有选中效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //文字居中
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        //文字颜色
        self.textLabel.textColor = [UIColor whiteColor];
        //文字换行
        self.textLabel.numberOfLines = 0;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置textLabel的frame
    self.textLabel.frame = self.bounds;
}

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
