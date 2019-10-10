//
//  BKXParserHandleString.m
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import "BKXParserHandleString.h"
#import "BKXCTFrameParserConfig.h"
#import "BKXTFHpple.h"

@implementation BKXParserHandleString

+ (NSArray *)getHandeString:(NSString *)str withConfig:(BKXCTFrameParserConfig *)config {
    
    NSData*data = [str dataUsingEncoding:NSUTF8StringEncoding];
    BKXTFHpple *xpathParser = [[BKXTFHpple alloc]initWithHTMLData:data];
    NSArray *elements  = [xpathParser searchWithXPathQuery:@"//p"];
    
    if (!elements.count) {
        elements=[xpathParser searchWithXPathQuery:@"/"];
    }
    
    NSMutableArray * ChildArr=[NSMutableArray array];
    
    for (int i=0; i<elements.count; i++) {
        BKXTFHppleElement * dicsss=[elements objectAtIndex:i];
        
        NSArray * children=[dicsss children];
        if(children.count){
            [ChildArr addObjectsFromArray:[self child:dicsss withUnderline:[dicsss tagName] withConfig:config]];
        }else{
            [ChildArr addObject:[self getTFHppleElement:dicsss withUnderline:[dicsss tagName] withConfig:config]];
        }
        if (ChildArr.count) {
            if (i!=elements.count-1) {
                [ChildArr addObject:@{@"type":@"txt",
                                      @"fontStyle":config.fontStyle?:@"PingFangSC-Regular",
                                      @"content":@"\n",
                                      @"color":config.textColor,
                                      @"size":@14}];
            }
        }
    }
    
    return ChildArr;
}

//递归解析html
+(NSArray*)child:(BKXTFHppleElement*)element withUnderline:(NSString*)underLine withConfig:(BKXCTFrameParserConfig *)config{
    NSMutableArray * mutableArr=[NSMutableArray array];
    NSArray * elementArr=element.children;
    for (int i=0; i<elementArr.count; i++) {
        BKXTFHppleElement * dicsss=[elementArr objectAtIndex:i];
        NSArray * childArr=[dicsss children];
        if (childArr.count) {
            if ([[dicsss tagName] isEqualToString:@"b"]) {
                [mutableArr addObject: [self getTFHppleElement:dicsss withUnderline:@"" withConfig:config]];
            } else {
                [mutableArr addObjectsFromArray:[self child:dicsss withUnderline:[dicsss tagName] withConfig:config]];
            }
        }else{
            [mutableArr addObject: [self getTFHppleElement:dicsss withUnderline:underLine withConfig:config]];
        }
    }
    return [mutableArr copy];
}


+(NSDictionary*)getTFHppleElement:(BKXTFHppleElement*)element withUnderline:(NSString*)underline withConfig:(BKXCTFrameParserConfig *)config{
    NSString * tagName=element.tagName;
    if ([tagName isEqualToString:@"html"]) {
        return @{};
    }
    
    if([tagName isEqualToString:@"img"]){
        NSString * className=[element objectForKey:@"class"];
        if ([className isEqualToString:@"__blank__placeholder"]) {
            return  [self getBlankPlaceholderUnderline:element withConfig:config];
        }else{
            
            return  [self getImage:element withConfig:config];
        }
    }else if([tagName isEqualToString:@"u"]){
        return  [self getUnderline:element withConfig:config];
    }
    else if ([tagName isEqualToString:@"br"]){
        return [self getBr:element withConfig:config];
    }
    
    else if ([tagName isEqualToString:@"b"]){
        return [self getStrong:element withConfig:config];
    }

    if([tagName isEqualToString:@"underline"]){
        return [self getUnderline:element withConfig:config];
    }else{
        if ([underline isEqualToString:@"u"]||[underline isEqualToString:@"underline"]) {
            return [self getUnderline:element withConfig:config];
        }
        return [self getText:element withConfig:config];
    }
    
    
}

+(NSDictionary*)getText:(BKXTFHppleElement*)textElement withConfig:(BKXCTFrameParserConfig *)config{
    
    NSDictionary *dict =   @{@"type":@"txt",
                             @"content":textElement.content,
                             @"color":config.textColor,
                             @"fontStyle":config.fontStyle?:@"PingFangSC-Regular",
                             @"size":@14};
    return    dict;
}

+(NSDictionary*)getImage:(BKXTFHppleElement*)imageElement withConfig:(BKXCTFrameParserConfig *)config{
        NSString * name=[imageElement objectForKey:@"src"];
        UIImage *baseImage = [UIImage new];
        
        if ([name containsString:@"base64"]) {
            NSArray *imageArray = [name componentsSeparatedByString:@","];
            NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageArray[1] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            baseImage = [UIImage imageWithData:imageData];
            
            NSString * canClick=[imageElement objectForKey:@"click"];
            if(!canClick){
                canClick=@"1";
            }
            NSString * width = @(baseImage.size.width).stringValue;
            NSString * height = @(baseImage.size.height).stringValue;
            
            float widths=[width floatValue];
            float heights=[height floatValue];
            
            int newWidth=0;
            int newHeight=0;
            
            if (widths>[UIScreen mainScreen].bounds.size.width-20) {
                newWidth=[UIScreen mainScreen].bounds.size.width-20;
                newHeight=newWidth/widths*heights;
            }else{
                newWidth=widths;
                newHeight=heights;
            }
            
            return @{@"type":@"img",
                     @"width":[NSNumber numberWithInt:newWidth],
                     @"height":[NSNumber numberWithInt:newHeight],
                     @"click":[NSNumber numberWithBool:[canClick boolValue]],
                     @"baseImage":baseImage,
                     @"name":name};
        }
        
        if (name.length) {
            NSString * canClick=[imageElement objectForKey:@"click"];
            if(!canClick){
                canClick=@"1";
            }
            NSString * width=[imageElement objectForKey:@"width"];
            NSString * height=[imageElement objectForKey:@"height"];
            if (width&&height) {
                
                float widths=[width floatValue];
                float heights=[height floatValue];
                int newWidth=0;
                int newHeight=0;
                
                if (widths>[UIScreen mainScreen].bounds.size.width-20) {
                    newWidth=[UIScreen mainScreen].bounds.size.width-20;
                    newHeight=newWidth/widths*heights;
                }else{
                    newWidth=widths;
                    newHeight=heights;
                }

                [self cacheImageName:name];
                
                return @{@"type":@"img",
                         @"width":[NSNumber numberWithInt:newWidth],
                         @"height":[NSNumber numberWithInt:newHeight],
                         @"click":[NSNumber numberWithBool:[canClick boolValue]],
                         @"baseImage":baseImage,
                         @"name":name};
            }
        }
    return @{};
}

+(NSDictionary*)getBlankPlaceholderUnderline:(BKXTFHppleElement*)underlineElement withConfig:(BKXCTFrameParserConfig *)config
{
    return @{@"type":@"blankPlaceholder",
             @"content":@"               ",
             @"color":config.textColor,
             @"fontStyle":config.fontStyle?:@"PingFangSC-Regular",
             @"size":@14};
}

+(NSDictionary*)getUnderline:(BKXTFHppleElement*)underlineElement withConfig:(BKXCTFrameParserConfig *)config
{
    return @{@"type":@"underline",
             @"content":underlineElement.content,
             @"color":config.textColor,
             @"fontStyle":config.fontStyle?:@"PingFangSC-Regular",
             @"size":@14};
}

// br
+(NSDictionary*)getBr:(BKXTFHppleElement*)underlineElement withConfig:(BKXCTFrameParserConfig *)config
{
    NSDictionary *dict =  @{@"type":@"txt",
                            @"content":@"\n",
                            @"color":config.textColor,
                            @"fontStyle":config.fontStyle?:@"PingFangSC-Regular",
                            @"size":@14};
    return dict;
}

// strong
+(NSDictionary*)getStrong:(BKXTFHppleElement*)underlineElement withConfig:(BKXCTFrameParserConfig *)config
{
    NSDictionary *dict =  @{@"type":@"b",
                            @"content":underlineElement.content,
                            @"color":config.textColor,
                            @"fontStyle":config.fontStyle?:@"PingFangSC-Regular",
                            @"size":@14};
    return dict;
}

/**
 *  预缓存图
 */
+(void)cacheImageName:(NSString*)imageUrl{
    
    return;

}

/**
 *  得到图片的宽度和高度和点击事件
 */
+(NSString*)getImageAttributeStr:(NSString*)str withSeparatedString:(NSString*)sepStr{
    NSArray *arr =[str componentsSeparatedByString:sepStr];
    return [[arr.lastObject componentsSeparatedByString:@" "] firstObject];
}

@end
