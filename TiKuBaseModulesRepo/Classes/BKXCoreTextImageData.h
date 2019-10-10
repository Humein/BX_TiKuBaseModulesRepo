//
//  BKXCoreTextImageData.h
//  TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/9/30.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKXCoreTextImageData : NSObject<NSCoding>
/**
 *  图片链接
 */
@property (strong, nonatomic) NSString * name;

@property (strong, nonatomic) UIImage *baseImage;

@property (assign, nonatomic) BOOL canChange;

@property (assign, nonatomic) BOOL isSelect;

/**
 *  图片是否可以点击
 */
@property (nonatomic,assign)BOOL canClick;
/**
 *  坐标。
 */
@property (nonatomic) int position;

// 此坐标是 CoreText 的坐标系，而不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@property (nonatomic,assign)BOOL isDownloading;

@end

NS_ASSUME_NONNULL_END
