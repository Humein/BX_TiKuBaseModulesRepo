//
//  BKXCTFrameParser.h
//  Pods-TiKuBaseModulesRepo_Tests
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import <Foundation/Foundation.h>
#import "BKXCTFrameParserConfig.h"
@class BKXCoreTextData;

NS_ASSUME_NONNULL_BEGIN

@interface BKXCTFrameParser : NSObject

+ (NSMutableDictionary *)attributesWithConfig:(BKXCTFrameParserConfig *)config;

+ (BKXCoreTextData *)parseContent:(NSString *)content config:(BKXCTFrameParserConfig*)config;

+ (BKXCoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(BKXCTFrameParserConfig*)config;
/**
 *  自己写的方法。
 */
+ (BKXCoreTextData *)parseTempArr:(NSArray*)arr config:(BKXCTFrameParserConfig*)config;

@end

NS_ASSUME_NONNULL_END
