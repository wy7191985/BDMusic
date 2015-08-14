//
//  WYLyricView.m
//  0810-BDMusic
//
//  Created by wangyue on 15/8/12.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import "WYLyricView.h"
#import "WYLrcLine.h"
#import "WYLyricCell.h"

@interface WYLyricView () <UITableViewDataSource, UITableViewDelegate>
/**存放歌词的tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 存放每一行歌词模型数组*/
@property (nonatomic, strong) NSMutableArray *lines;
/** 当前行的时间(相比下一条是前一条)*/
@property (nonatomic, copy) NSString *currentLineTime;
/** 当前行的索引*/
@property (nonatomic, assign) int currentIndex;

@end

@implementation WYLyricView
#pragma mark - 懒加载
/**
 每一个歌词模型数组
 */
- (NSMutableArray *)lines
{
    if (!_lines) {
        _lines = [[NSMutableArray alloc] init];
    }
    return _lines;
}
#pragma mark - 初始化
/**
 *  代码创建
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
/**
 *  storyboard或者xib创建
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //添加tableview
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    //设置tableView属性
    tableView.backgroundColor = [UIColor clearColor];
    //去除分割线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置tableView的frame
    self.tableView.frame = self.bounds;
    //设置tableView的内边距
    self.tableView.contentInset = UIEdgeInsetsMake(self.height * 0.5, 0, self.height * 0.5, 0);
}

//重写歌词set方法
- (void)setLrcname:(NSString *)lrcname
{
    _lrcname = [lrcname copy];
    // 0.清空上一首歌的歌词
    [self.lines removeAllObjects];
    // 1.加载歌词文件
    NSURL *url = [[NSBundle mainBundle] URLForResource:lrcname withExtension:nil];
    NSString *lrcStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    // 2.切割lrc字符串每一行歌词
    NSArray *lrcCmps = [lrcStr componentsSeparatedByString:@"\n"];
    // 3.输出每一行歌词
    for (NSString *lrcCmp in lrcCmps) {
        // 创建行模型
        WYLrcLine *line = [[WYLrcLine alloc] init];
        [self.lines addObject:line];
        // 不以"["开头的，是空行.添加一个空行进数组
        if (![lrcCmp hasPrefix:@"["]) continue;
        // 如果是歌词的头部信息
        if ([lrcCmp hasPrefix:@"[ti:"] || [lrcCmp hasPrefix:@"[ar:"] || [lrcCmp hasPrefix:@"[al:"]) {
            // 切割头部信息的字符串
            NSString *word = [[lrcCmp componentsSeparatedByString:@":"] lastObject];
            // 截取范围
            line.word = [word substringToIndex:word.length - 1];
        } else {  //不是头部信息
            NSArray *array = [lrcCmp componentsSeparatedByString:@"]"];
            //歌词时间
            line.time = [[array firstObject] substringFromIndex:1];
            //歌词
            line.word = [array lastObject];
            
        }
        
    }
    
    // 4.刷新表格
    [self.tableView reloadData];
    
}
//重写当前时间的set方法
- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    //当用户往回拖进度条,设置从头开始遍历
    if (currentTime < _currentTime) {
        self.currentIndex = - 1;
    }
    _currentTime = currentTime;
    // 计算时间
    int minute = currentTime / 60;
    int second = (int)currentTime % 60;
    int msecond = (currentTime - (int)currentTime) * 100;
    NSString *currentTimeStr = [NSString stringWithFormat:@"%02d:%02d.%02d", minute, second, msecond];
    // 遍历歌词模型数组
    NSUInteger count = self.lines.count;
    //每次都从下一条歌词开始遍历(不这么写会出现一些bug)
    for (int index = self.currentIndex + 1; index < count; index++) {
        WYLrcLine *line = self.lines[index];
        //设置当前行时间
        self.currentLineTime = line.time;
        //下一个时间
        NSString *nextLineTime = nil;
        int nextIndex = index + 1;
        if (nextIndex < count) {
            WYLrcLine *nextLine = self.lines[nextIndex];
            nextLineTime = nextLine.time;
        }
        //判断是否为正在播放的歌词(当前时间大于等于当前歌词时间，小于下一条歌词时间，且不是相同时间的歌词)
        if ([currentTimeStr compare:self.currentLineTime] != NSOrderedAscending && [self.currentLineTime compare:nextLineTime] == NSOrderedAscending && self.currentIndex != index) {
            //刷新上一行和当前行歌词
            NSArray *reloadRows = @[[NSIndexPath indexPathForRow:self.currentIndex inSection:0], [NSIndexPath indexPathForRow:index inSection:0]];
            //赋值当前歌词索引
            self.currentIndex = index;
            [self.tableView reloadRowsAtIndexPaths:reloadRows withRowAnimation:UITableViewRowAnimationNone];
            //滚动到对应的行
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        
        
        
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lines.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WYLyricCell *cell = [WYLyricCell cellWithTableView:tableView];
    
    WYLrcLine *line = self.lines[indexPath.row];
    cell.line = line;
    //设置当前时间歌词字体
    if (self.currentIndex == indexPath.row) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    } else {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    return cell;
}

@end
