//
//  BKXXPathQuery.h
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import <Foundation/Foundation.h>

NSArray *PerformHTMLXPathQuery(NSData *document, NSString *query);
NSArray *PerformHTMLXPathQueryWithEncoding(NSData *document, NSString *query,NSString *encoding);
NSArray *PerformXMLXPathQuery(NSData *document, NSString *query);
NSArray *PerformXMLXPathQueryWithEncoding(NSData *document, NSString *query,NSString *encoding);

