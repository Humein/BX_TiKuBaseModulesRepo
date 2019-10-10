//
//  BKXCTFrameParserConfig.m
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import "BKXCTFrameParserConfig.h"

@implementation BKXCTFrameParserConfig
- (id)init {
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = [UIColor blackColor];
        _lineBreak = kCTLineBreakByCharWrapping;
        _alignment = kCTTextAlignmentLeft;
    }
    return self;
}
@end
