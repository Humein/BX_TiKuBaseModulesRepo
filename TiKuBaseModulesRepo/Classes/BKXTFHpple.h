//
//  BKXTFHpple.h
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import <Foundation/Foundation.h>
#import "BKXTFHppleElement.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKXTFHpple : NSObject
- (id) initWithData:(NSData *)theData encoding:(NSString *)encoding isXML:(BOOL)isDataXML;
- (id) initWithData:(NSData *)theData isXML:(BOOL)isDataXML;
- (id) initWithXMLData:(NSData *)theData encoding:(NSString *)encoding;
- (id) initWithXMLData:(NSData *)theData;
- (id) initWithHTMLData:(NSData *)theData encoding:(NSString *)encoding;
- (id) initWithHTMLData:(NSData *)theData;

+ (BKXTFHpple *) hppleWithData:(NSData *)theData encoding:(NSString *)encoding isXML:(BOOL)isDataXML;
+ (BKXTFHpple *) hppleWithData:(NSData *)theData isXML:(BOOL)isDataXML;
+ (BKXTFHpple *) hppleWithXMLData:(NSData *)theData encoding:(NSString *)encoding;
+ (BKXTFHpple *) hppleWithXMLData:(NSData *)theData;
+ (BKXTFHpple *) hppleWithHTMLData:(NSData *)theData encoding:(NSString *)encoding;
+ (BKXTFHpple *) hppleWithHTMLData:(NSData *)theData;

- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS;
- (BKXTFHppleElement *) peekAtSearchWithXPathQuery:(NSString *)xPathOrCSS;

@property (nonatomic, readonly) NSData * data;
@property (nonatomic, readonly) NSString * encoding;
@end

NS_ASSUME_NONNULL_END
