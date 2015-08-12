//
//  UIImage+Clip.h
//  0511-Quartz2D图片裁剪
//
//  Created by wangyue on 15/5/11.
//  Copyright (c) 2015年 system . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Clip)
/**
*  创建一个带圆环的图片
*
*  @param name    传入的图片名
*  @param padding 圆环的宽度
*  @param color   圆环的颜色
*/
+ (instancetype)clipImageWithName:(NSString *)name andPadding:(CGFloat)padding color:(UIColor *)color;

@end
