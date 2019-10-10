//
//  BKXParserHandleString.h
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import <Foundation/Foundation.h>
@class BKXCTFrameParserConfig;

NS_ASSUME_NONNULL_BEGIN

@interface BKXParserHandleString : NSObject
/**
 *  处理字符串的标签转换成。可以适配使用与CTDisplayView的试题解析模式
 */
+ (NSArray *)getHandeString:(NSString *)str withConfig:(BKXCTFrameParserConfig *)config;
@end

NS_ASSUME_NONNULL_END
