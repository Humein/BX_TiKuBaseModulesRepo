//
//  BKXCTFrameParserConfig.h
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKXCTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, copy) NSString *fontStyle;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor * textColor;
/**
 换行模式
 */
@property (nonatomic, assign) CTLineBreakMode lineBreak;
/**
 对齐方式
 */
@property (nonatomic, assign) CTTextAlignment alignment;
@end

NS_ASSUME_NONNULL_END
