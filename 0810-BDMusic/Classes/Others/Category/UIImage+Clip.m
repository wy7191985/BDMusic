//
//  UIImage+Clip.m
//  0511-Quartz2D图片裁剪
//
//  Created by wangyue on 15/5/11.
//  Copyright (c) 2015年 system . All rights reserved.
//

#import "UIImage+Clip.h"

@implementation UIImage (Clip)

+ (instancetype)clipImageWithName:(NSString *)name andPadding:(CGFloat)pdg color:(UIColor *)color
{
    //1.获取旧图片
    UIImage *oldImage = [UIImage imageNamed:name];
    //2.创建一个基于位图的上下文
    //外圈圆环的宽度
    CGFloat padding = pdg;
    CGFloat bgW = oldImage.size.width + padding * 2;
    CGFloat bgH = oldImage.size.height + padding * 2;
    CGSize bgSize = CGSizeMake(bgW, bgH);
    UIGraphicsBeginImageContextWithOptions(bgSize, NO, 0.0);
    //3.画大圆
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画圆
    CGFloat centerX = bgW * 0.5;
    CGFloat centerY = bgH * 0.5;
    CGFloat bigRadius = bgW * 0.5;
    [color set];
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    //渲染
    CGContextFillPath(ctx);
    
    //4.画小圆
    CGFloat radius = oldImage.size.width * 0.5;
    CGContextAddArc(ctx, centerX, centerY, radius, 0, M_PI * 2, 0);
    //裁剪
    CGContextClip(ctx);
    
    //5.画图片
    [oldImage drawAtPoint:CGPointMake(padding, padding)];
    
    //6.获取新图
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //7.结束上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
