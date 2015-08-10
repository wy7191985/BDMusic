//
//  WYMusicCell.m
//  0810-BDMusic
//
//  Created by yanyin on 15/8/10.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import "WYMusicCell.h"
#import "WYMusic.h"

@implementation WYMusicCell

//快速创建cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"music";
    WYMusicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (!cell) {
        cell = [[WYMusicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
    
}

//重写模型set方法
- (void)setMusic:(WYMusic *)music
{
    _music = music;
    //设置cell属性
    self.textLabel.text = music.name;
    self.detailTextLabel.text = music.singer;
    //将头像裁剪成圆形带边框
    UIImage *newImg = [UIImage clipImageWithName:music.singerIcon andPadding:3 color:[UIColor redColor]];
    self.imageView.image = newImg;
    
}

@end
