//
//  BKXCoreTextData.h
//  TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/9/30.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKXCoreTextData : NSObject<NSCoding>

@property (assign, nonatomic) CTFrameRef ctFrame;

@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) NSArray * imageArray;

@property (strong, nonatomic) NSArray * linkArray;

@property (strong, nonatomic) NSAttributedString *content;

@end

NS_ASSUME_NONNULL_END
