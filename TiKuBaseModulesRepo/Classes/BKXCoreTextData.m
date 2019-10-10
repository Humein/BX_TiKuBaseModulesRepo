//
//  BKXCoreTextData.m
//  TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/9/30.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import "BKXCoreTextData.h"
#import "BKXCoreTextImageData.h"
#import <objc/runtime.h>

@implementation BKXCoreTextData

- (id)copyWithZone:(nullable NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    BKXCoreTextData *abstractItem = [[[self class] allocWithZone:zone] init];
    unsigned int count;
    objc_property_t *property= class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        const char *properName =  property_getName(property[i]);
        NSString *key= [NSString stringWithUTF8String:properName];
        [abstractItem setValue:[self valueForKey:key] forKey:key];
    }
    free(property);
    return abstractItem;
}
- (void)encodeWithCoder:(NSCoder*)aCoder{
    
    unsigned int count = 0;
    objc_property_t *propertes = class_copyPropertyList([self class], &count);
    for (int i=0; i<count; i++) {
        
        const char *propertyName = property_getName(propertes[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        id value = [self valueForKey:name];
        [aCoder encodeObject:value forKey:name];
    }
    free(propertes);
}

- (id)initWithCoder:(NSCoder*)aDecoder{
    
    if (self = [super init]) {
        unsigned int count =0;
        objc_property_t *propertes = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count; i++) {
            const char *propertyName = property_getName(propertes[i]);
            NSString *name = [NSString stringWithUTF8String:propertyName];
            id value = [aDecoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
        free(propertes);
    }
    return self;
    
}


- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if (_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}

- (void)dealloc {
    if (_ctFrame != nil) {
        CFRelease(_ctFrame);
        _ctFrame = nil;
    }
}

- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    [self fillImagePosition];
}

// 设置图片的Position
- (void)fillImagePosition {
    if (self.imageArray.count == 0) {
        return;
    }
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imgIndex = 0;
    BKXCoreTextImageData * imageData = self.imageArray[0];
    
    for (int i = 0; i < lineCount; ++i) {
        if (imageData == nil) {
            break;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray * runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        
        //获取每行的高度
        //遍历每一行CTLine
        CGFloat lineAscent;
        CGFloat lineDescent;
        CGFloat lineLeading; 
        CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading);
        CGFloat lineHeight = lineAscent + lineDescent;
        
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            
            NSDictionary * metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            // 图片居中。
            // 后面的代理只会设置image垂直居中，所以文字垂直居中，仍需要单独处理
            runBounds.origin.y = runBounds.origin.y + lineHeight / 2 - runBounds.size.height / 2 - 3;
            //  图片下对齐
//            runBounds.origin.y = runBounds.origin.y + lineHeight / 2 - runBounds.size.height / 2 - 10  ;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            // 设置图片的Position
            imageData.imagePosition = delegateBounds;
            imgIndex++;
            if (imgIndex == self.imageArray.count) {
                imageData = nil;
                break;
            } else {
                imageData = self.imageArray[imgIndex];
            }
        }
    }
}

@end
