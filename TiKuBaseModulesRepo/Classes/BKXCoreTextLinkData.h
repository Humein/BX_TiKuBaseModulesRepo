//
//  BKXCoreTextLinkData.h
//  TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/9/30.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKXCoreTextLinkData : NSObject<NSCoding>

@property (strong, nonatomic) NSString * title;

@property (strong, nonatomic) NSString * url;

@property (assign, nonatomic) NSRange range;
/**
 *  是否可以点击
 */
@property (nonatomic,assign)BOOL canClick;
/**
 *  坐标。
 */
@property (nonatomic) int position;

@property (nonatomic) CGRect blankLinkPosition;
@end

NS_ASSUME_NONNULL_END
