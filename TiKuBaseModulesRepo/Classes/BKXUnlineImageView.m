//
//  BKXUnlineImageView.m
//  Pods-TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//

#import "BKXUnlineImageView.h"

@implementation BKXUnlineImageView

+ (UIImage *)imageWithBackgroundColor:(UIColor *)color lineColor:(UIColor *)lineColor size:(CGSize)size {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height - (1.0 / [UIScreen mainScreen].scale));
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, (1.0 / [UIScreen mainScreen].scale));
    CGContextSetStrokeColorWithColor(context, [lineColor CGColor]);
    CGContextMoveToPoint(context, 0, size.height - (1.0 / [UIScreen mainScreen].scale));
    CGContextAddLineToPoint(context, size.width, size.height - (1.0 / [UIScreen mainScreen].scale));
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    
    return image;
}

@end
