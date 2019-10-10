//
//  BKXCTFrameParser.m
//  Pods-TiKuBaseModulesRepo_Tests
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import "BKXCTFrameParser.h"
#import "BKXCoreTextData.h"
#import "BKXCoreTextImageData.h"
#import "BKXCoreTextLinkData.h"
@implementation BKXCTFrameParser

static CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

+ (NSMutableDictionary *)attributesWithConfig:(BKXCTFrameParserConfig *)config {
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    CTLineBreakMode lineBreak = config.lineBreak;  // 换行模式
    CTTextAlignment alignment = config.alignment;  // 对齐方式
    const CFIndex kNumberOfSettings = 5;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing },
        { kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreak },
        { kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &alignment }
    };

    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);

    UIColor * textColor = config.textColor;

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;

    CFRelease(theParagraphRef);
    CFRelease(fontRef);
    return dict;
}




+(BKXCoreTextData *)parseTempArr:(NSArray *)array config:(BKXCTFrameParserConfig *)config{

    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *linkArray = [NSMutableArray array];

    NSAttributedString *content = [self loadTemplateArr:array config:config imageArray:imageArray linkArray:linkArray];
    BKXCoreTextData *data = [self parseAttributedContent:content config:config];
    data.imageArray = imageArray;
    data.linkArray = linkArray;
    return data;
}

+(NSMutableAttributedString*)loadTemplateArr:(NSArray*)array config:(BKXCTFrameParserConfig*)config
                                  imageArray:(NSMutableArray *)imageArray
                                   linkArray:(NSMutableArray *)linkArray{
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] init];
    if (array) {

        if ([array isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in array) {
                NSString *type = dict[@"type"];
                if ([type isEqualToString:@"txt"]) {
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config isStrong:NO];
                    [result appendAttributedString:as];
                } else if ([type isEqualToString:@"img"]) {
                    // 创建 BKXCoreTextImageData
                    BKXCoreTextImageData *imageData = [[BKXCoreTextImageData alloc] init];
                    imageData.name = dict[@"name"];
                    imageData.position =(int)[result length];
                    imageData.canClick =[dict[@"click"] boolValue];
                    [imageArray addObject:imageData];

                    NSAttributedString *as = [self parseImageDataFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];

                } else if ([type isEqualToString:@"link"]) {
                    NSUInteger startPos = result.length;
                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config isStrong:NO];
                    [result appendAttributedString:as];
                    // 创建 BKXCoreTextLinkData
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    BKXCoreTextLinkData *linkData = [[BKXCoreTextLinkData alloc] init];
                    linkData.title = dict[@"content"];
                    linkData.url = dict[@"url"];
                    linkData.range = linkRange;
                    linkData.canClick = [dict[@"click"] boolValue];
                    [linkArray addObject:linkData];
                }else if([type isEqualToString:@"underline"] ||  [type isEqualToString:@"blankPlaceholder"]){

                    NSUInteger startPos = result.length;
                    [result appendAttributedString:[self parseUnderlineFromNSDictionary:dict config:config]];
                    // 创建 blankplace
                    NSUInteger length = result.length - startPos;
                    NSRange linkRange = NSMakeRange(startPos, length);
                    BKXCoreTextLinkData *blankholderdata = [[BKXCoreTextLinkData alloc] init];
                    blankholderdata.title = dict[@"content"];
                    blankholderdata.url = dict[@"url"];
                    blankholderdata.range = linkRange;
                    blankholderdata.position =(int)[result length];
                    blankholderdata.canClick = YES;
                    [linkArray addObject:blankholderdata];

                } else if ([type isEqualToString:@"b"]) {

                    NSAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config isStrong: YES];
                    [result appendAttributedString:as];
                }
            }
        }
    }
    return result;



}




+(NSAttributedString*)parseUnderlineFromNSDictionary:(NSDictionary *)dict
                                              config:(BKXCTFrameParserConfig*)config{

    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    // set color
    UIColor *color = dict[@"color"];
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // set font size
    //    CGFloat fontSize = [dict[@"size"] floatValue];
    CGFloat fontSize=config.fontSize;
    if (fontSize > 0) {
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }

    [attributes setValue:config.textColor forKey:NSUnderlineColorAttributeName];
    attributes[(id)kCTUnderlineStyleAttributeName]=(id)[NSNumber numberWithInt:kCTUnderlineStyleSingle];
    attributes[(id)kCTUnderlineColorAttributeName]=(id)color.CGColor;
    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}


+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                config:(BKXCTFrameParserConfig*)config {


    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));

    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [self attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content
                                                                               attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict config:(BKXCTFrameParserConfig*)config isStrong:(BOOL)isStrong
{
    NSMutableDictionary *attributes = [self attributesWithConfig:config];
    // set color
    UIColor *color = config.textColor;
    if (color) {
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    // set font size
    //    CGFloat fontSize = [dict[@"size"] floatValue];
    CGFloat fontSize=config.fontSize;
    if (fontSize > 0) {
        NSString *fontName = isStrong ? @"Arial-BoldMT" : config.fontStyle;
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)fontName, fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }

    NSString *content = dict[@"content"];
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}

+ (UIColor *)colorFromTemplate:(NSString *)name {
    if ([name isEqualToString:@"blue"]) {
        return [UIColor blueColor];
    } else if ([name isEqualToString:@"red"]) {
        return [UIColor redColor];
    } else if ([name isEqualToString:@"black"]) {
        return [UIColor blackColor];
    } else {
        return nil;
    }
}

+ (BKXCoreTextData *)parseContent:(NSString *)content config:(BKXCTFrameParserConfig*)config {
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSAttributedString *contentString = [[NSAttributedString alloc] initWithString:content
                                                                        attributes:attributes];
    return [self parseAttributedContent:contentString config:config];
}

+ (BKXCoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(BKXCTFrameParserConfig*)config {
    // 创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);

    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;

    // 生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];

    // 将生成好的CTFrameRef实例和计算好的缓制高度保存到CoreTextData实例中，最后返回CoreTextData实例
    BKXCoreTextData *data = [[BKXCoreTextData alloc] init];
    data.ctFrame = frame;
    data.height = textHeight;
    data.content = content;

    // 释放内存
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter
                                  config:(BKXCTFrameParserConfig *)config
                                  height:(CGFloat)height {

    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));

    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

@end
