//
//  BKXCoreTextUtils.h
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import <Foundation/Foundation.h>
@class BKXCoreTextLinkData,BKXCoreTextData;
NS_ASSUME_NONNULL_BEGIN

@interface BKXCoreTextUtils : NSObject

+ (BKXCoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(BKXCoreTextData *)data;

+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(BKXCoreTextData *)data;

@end

NS_ASSUME_NONNULL_END
