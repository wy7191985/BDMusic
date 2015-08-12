//
//  WYLyricView.m
//  0810-BDMusic
//
//  Created by wangyue on 15/8/12.
//  Copyright (c) 2015年 yanyin. All rights reserved.
//

#import "WYLyricView.h"
#import "WYLrcLine.h"

@interface WYLyricView () <UITableViewDataSource, UITableViewDelegate>
/**存放歌词的tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 存放每一行歌词模型数组*/
@property (nonatomic, strong) NSMutableArray *lines;



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
    UITableView *tableView = [[UITableView alloc] init];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self addSubview:tableView];
    self.tableView = tableView;
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    //设置tableView的frame
    self.tableView.frame = self.bounds;
}

//重写set方法
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

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lines.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"lrc";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    WYLrcLine *line = self.lines[indexPath.row];
    cell.textLabel.text = line.word;
    
    return cell;
}

@end
