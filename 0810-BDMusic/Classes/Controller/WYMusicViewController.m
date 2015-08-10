//
//  WYMusicViewController.m
//  0810-BDMusic
//
//  Created by yanyin on 15/8/10.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import "WYMusicViewController.h"
#import "WYMusic.h"
#import "WYMusicCell.h"
#import "WYPlayingViewController.h"
#import "WYMusicTool.h"

@interface WYMusicViewController ()


//播放控制器
@property (nonatomic, strong) WYPlayingViewController *playingVc;

@end

@implementation WYMusicViewController
#pragma mark - 懒加载
/**
 *  播放控制器
 */
- (WYPlayingViewController *)playingVc
{
    if (!_playingVc) {
        _playingVc = [[WYPlayingViewController alloc] init];
    }
    return _playingVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置行高
    self.tableView.rowHeight = 70;
   
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [WYMusicTool musics].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //创建cell
    WYMusicCell *cell = [WYMusicCell cellWithTableView:tableView];
    //取出模型
    WYMusic *music = [WYMusicTool musics][indexPath.row];
    cell.music = music;
    
    
    return cell;
}
#pragma mark - Table view delegate
/**
 *  选中了某一行就会调用
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //设置当前播放的歌曲
    NSArray *musics = [WYMusicTool musics];
    [WYMusicTool setPlayingMusic:musics[indexPath.row]];
    //显示播放控制器
    [self.playingVc show];
    
    
}

@end
