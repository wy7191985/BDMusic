//
//  WYPlayingViewController.m
//  0810-BDMusic
//
//  Created by yanyin on 15/8/10.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import "WYPlayingViewController.h"
#import "WYMusic.h"
#import "WYAudioTool.h"
#import "WYMusicTool.h"
#import <AVFoundation/AVFoundation.h>
#import "WYLyricView.h"

@interface WYPlayingViewController () <AVAudioPlayerDelegate>
/** 正在播放的歌曲*/
@property (nonatomic, strong) WYMusic *playingMusic;
/** 当前的播放器*/
@property (nonatomic, strong) AVAudioPlayer *player;
/** 大图*/
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
/** 歌曲名*/
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** 演唱者*/
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
/** 时长*/
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
/** 滑块*/
@property (weak, nonatomic) IBOutlet UIButton *slider;
/** 进度条值*/
@property (weak, nonatomic) IBOutlet UIView *progressView;
/** 放大的进度条时间*/
@property (weak, nonatomic) IBOutlet UILabel *blackTimeLabel;
/** 播放暂停按钮*/
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
/** 显示歌词的视图*/
@property (weak, nonatomic) IBOutlet WYLyricView *lyricView;


/** 进度定时器*/
@property (nonatomic, strong) NSTimer *currenttimeTimer;
/** 歌词定时器*/
@property (nonatomic, strong) CADisplayLink *lrcTimer;

//退下播放器
- (IBAction)exit;
//切换歌词封面
- (IBAction)lyricOrpic:(UIButton *)sender;

//单击进度条
- (IBAction)tapProgressBg:(UITapGestureRecognizer *)sender;
//拖拽滑块
- (IBAction)panSlider:(UIPanGestureRecognizer *)sender;
//上一首
- (IBAction)previousMusic;
//播放和暂停
- (IBAction)playOrPause:(UIButton *)sender;
//下一首
- (IBAction)nextMusic;
@end

@implementation WYPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置放大当前时间的label圆角
    self.blackTimeLabel.layer.cornerRadius = 5;
    self.blackTimeLabel.clipsToBounds = YES;
}

#pragma mark - 公共方法
/**
 *  显示播放控制器
 */
- (void)show
{
    // 1.取得主窗口,关闭主窗口的交互
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    self.view.hidden = NO;  //显示view
    // 2.添加到主窗口上
    self.view.frame = window.bounds;
    [window addSubview:self.view];
    // 3.如果更换了歌曲
    if (self.playingMusic != [WYMusicTool playingMusic]) {
        [self resetPlayingMusic];
    }
    
    
    // 4.动画显示View
    self.view.y = window.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        //播放歌曲
        [self startPlayingMusic];
        //开始主窗口的交互
        window.userInteractionEnabled = YES;
        
    }];
    
}
#pragma mark - 定时器处理
/**
 *  添加定时器
 */
- (void)addCurrenttimeTimer
{
    //如果没有在播放歌曲就直接返回(比如拖拽滑块结束会添加一下定时器)
    if (self.player.isPlaying == NO) return;
    // 不管如何，在添加定时器前销毁以前的定时器，保证只有一个
    [self removeCurrenttimeTimer];
    
    // 1.提前调用定时器方法保证工作及时
    [self updateCurrenttime];
    
    
    self.currenttimeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCurrenttime) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.currenttimeTimer forMode:NSRunLoopCommonModes];
    
}
/**
 *  销毁定时器
 */
- (void)removeCurrenttimeTimer
{
    [self.currenttimeTimer invalidate];
    self.currenttimeTimer = nil;
}

/**
 *  更新当前时间
 */
- (void)updateCurrenttime
{
    // 1.计算进度条值
    double progress = self.player.currentTime / self.player.duration;
    // 2.滑块的位置
    self.slider.x = (self.view.width - self.slider.width) * progress;
    // 3.设置进度条值
    self.progressView.width = self.slider.center.x;
    // 4.设置滑块上的当前时间
    NSString *currentStr = [self stringWithTime:self.player.currentTime];
    [self.slider setTitle:currentStr forState:UIControlStateNormal];
    
}
/**
 *  添加歌词定时器
 */
- (void)addLrcTimer
{
    //如果没有在播放歌曲活着歌词视图隐藏时返回
    if (self.player.isPlaying == NO || self.lyricView.hidden) return;
    // 不管如何，在添加定时器前销毁以前的定时器，保证只有一个
    [self removeLrcTimer];
    
    // 1.提前调用定时器方法保证工作及时
    [self updateLrc];
    
    
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}
/**
 *  销毁歌词定时器
 */
- (void)removeLrcTimer
{
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}
/**
 *  更新歌词
 */
- (void)updateLrc
{
    self.lyricView.currentTime = self.player.currentTime;
    
}

#pragma mark - 音乐控制
/**
 *  重置歌曲
 */
- (void)resetPlayingMusic
{
    
    // 1.还原默认界面
    self.iconView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.nameLabel.text = nil;
    self.singerLabel.text = nil;
    self.timelabel.text = nil;
    self.slider.titleLabel.text = nil;
    self.playOrPauseBtn.selected = NO; //设置按钮不选中
    // 2.停止当前的歌曲
    [WYAudioTool stopMusic:self.playingMusic.filename];
    // 3.销毁定时器
    [self removeCurrenttimeTimer];
    [self removeLrcTimer];
    //清空当前的播放器
    self.player = nil;
}
/**
 *  播放歌曲
 */
- (void)startPlayingMusic
{
    
    // 1.如果正在播放歌曲,直接返回
    if (self.playingMusic == [WYMusicTool playingMusic]) {
        [self addCurrenttimeTimer]; //退下的时候销毁了，再上来的时候要添加
        [self addLrcTimer];
        return;
    }
    // 2.存储正在播放的歌曲
    self.playingMusic = [WYMusicTool playingMusic];
    // 3.设置界面属性
    self.iconView.image = [UIImage imageNamed:self.playingMusic.icon];
    self.nameLabel.text = self.playingMusic.name;
    self.singerLabel.text = self.playingMusic.singer;
    self.playOrPauseBtn.selected = YES; //设置按钮选中
    
    // 4.播放歌曲
    self.player = [WYAudioTool playMusic:self.playingMusic.filename];
    self.player.delegate = self; // 设置播放器的代理
    // 5.设置时长
    self.timelabel.text = [self stringWithTime:self.player.duration];
    
    // 6.开启定时器
    [self addCurrenttimeTimer];
    [self addLrcTimer];
    // 7.切换歌词
    self.lyricView.lrcname = self.playingMusic.lrcname;
    
}

#pragma mark - 私有方法
/**
 *  时间长度-->时间字符串
 */
- (NSString *)stringWithTime:(NSTimeInterval)time
{
    //取整得到分钟
    int minute = time / 60;
    //取余得到秒
    int second = (int)time % 60;
    return [NSString stringWithFormat:@"%d:%02d", minute, second];
    
}

#pragma mark - 内部控件的监听
/**
 *  退下控制器
 */
- (IBAction)exit {
    //取得主窗口
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    //关闭主窗口的交互
    window.userInteractionEnabled = NO;
    //动画改编view的y值
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y = window.height;
    } completion:^(BOOL finished) {
        //开始主窗口的交互
        window.userInteractionEnabled = YES;
        //关闭定时器
        [self removeCurrenttimeTimer];
        [self removeLrcTimer];
        //隐藏控制器view
        self.view.hidden = YES;
    }];
    
    
}
/**
 *  切换歌词封面
 */
- (IBAction)lyricOrpic:(UIButton *)sender {
    if (self.lyricView.hidden) {  //要显示歌词
        // 1.显示歌词
        self.lyricView.hidden = NO;
        // 2.设置按钮选中
        sender.selected = YES;
        // 3.开启定时器
        [self addLrcTimer];
    } else {
        // 1.隐藏歌词
        self.lyricView.hidden = YES;
        // 2.取消按钮选中
        sender.selected = NO;
        // 3.销毁定时器
        [self removeLrcTimer];
    }
}
/**
 *  单击进度条
 */
- (IBAction)tapProgressBg:(UITapGestureRecognizer *)sender {
    // 1.获得点击的位置
    CGPoint point = [sender locationInView:sender.view];
    // 2.获得点击位置的时间
    self.player.currentTime = (point.x / sender.view.width) * self.player.duration;
    // 3.调用定时器方法刷新时间
    [self updateCurrenttime];
}

/**
 *  拖拽滑块
 */
- (IBAction)panSlider:(UIPanGestureRecognizer *)sender {
    // 1.获得拖拽的位置
    CGPoint point = [sender locationInView:sender.view];
    // 2.设置每次返回的位置都从零开始计算
    [sender setTranslation:CGPointZero inView:sender.view];
    // 3.设置滑块的位置
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    self.slider.x += point.x;
    if (self.slider.x < 0) {
        self.slider.x = 0;
    } else if (self.slider.x > sliderMaxX) {
        self.slider.x = sliderMaxX;
    }
    // 4.设置进度条值的位置
    self.progressView.width = self.slider.center.x;
    // 5.设置滑块上的时间
    double progress = self.slider.x / sliderMaxX;
    NSTimeInterval time = self.player.duration * progress;
    [self.slider setTitle:[self stringWithTime:time] forState:UIControlStateNormal];
    // 6.设置放大当前时间label的时间(因为没有被约束,所以要设置它的位置)
    self.blackTimeLabel.x = self.slider.x;
    self.blackTimeLabel.y = 10;
    self.blackTimeLabel.text = [self stringWithTime:time];
    
    
    
    
    // 判断拖拽的状态
    if (sender.state == UIGestureRecognizerStateBegan) { //正在拖拽
        //关闭定时器
        [self removeCurrenttimeTimer];
        //显示放大的当前时间
        self.blackTimeLabel.hidden = NO;
    } else if (sender.state == UIGestureRecognizerStateEnded) { //停止拖拽
        // 1.设置播放器的当前时间(一定要在开启定时器前)
        self.player.currentTime = time;
        // 2.开启定时器
        [self addCurrenttimeTimer];
        
        // 3.隐藏放大的当前时间
        self.blackTimeLabel.hidden = YES;
        
    }
    
}
/**
 *  上一首
 */
- (IBAction)previousMusic {
    // 1.取得主窗口,关闭主窗口的交互
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    // 2.重置歌曲
    [self resetPlayingMusic];
    // 3.设置上一首歌曲为当前歌曲
    [WYMusicTool setPlayingMusic:[WYMusicTool previousMusic]];
    // 4.播放歌曲
    [self startPlayingMusic];
    // 5.开启主窗口的交互
    window.userInteractionEnabled = YES;
}
/**
 *  播放和暂停
 */
- (IBAction)playOrPause:(UIButton *)sender {
    if (sender.selected == NO) {  //开始播放
        sender.selected = YES;
        //播放歌曲
        [WYAudioTool playMusic:self.playingMusic.filename];
        //添加定时器
        [self addCurrenttimeTimer];
        [self addLrcTimer];
    } else if (sender.selected) { //暂停
        sender.selected = NO;
        //暂停
        [WYAudioTool pauseMusic:self.playingMusic.filename];
        //销毁定时器
        [self removeCurrenttimeTimer];
        [self removeLrcTimer];
        
    }
    
}
/**
 *  下一首
 */
- (IBAction)nextMusic {
    
    // 1.取得主窗口,关闭主窗口的交互
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    // 2.重置歌曲
    [self resetPlayingMusic];
    // 3.设置下一首歌曲为当前歌曲
    [WYMusicTool setPlayingMusic:[WYMusicTool nextMusic]];
    // 4.播放歌曲
    [self startPlayingMusic];
    // 5.开启主窗口的交互
    window.userInteractionEnabled = YES;
}

#pragma mark - AVAudioPlayerDelegate
/**
 *  播放完毕时会调用
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //调用下一首按钮的点击方法
    [self nextMusic];
    
}

/**
 *  播放被打断时会调用(比如来电)
 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    if ([player isPlaying]) {  //如果正在播放歌曲,就点击一下暂停
        [self playOrPause:self.playOrPauseBtn];
    }
    
}
@end
