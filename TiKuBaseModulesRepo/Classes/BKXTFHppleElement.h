//
//  BKXTFHppleElement.h
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKXTFHppleElement : NSObject

- (id) initWithNode:(NSDictionary *) theNode isXML:(BOOL)isDataXML withEncoding:(NSString *)theEncoding;

+ (BKXTFHppleElement *) hppleElementWithNode:(NSDictionary *) theNode isXML:(BOOL)isDataXML withEncoding:(NSString *)theEncoding;

@property (nonatomic, copy, readonly) NSString *raw;

@property (nonatomic, copy, readonly) NSString *br;
// Returns this tag's innerHTML content.
@property (nonatomic, copy, readonly) NSString *content;

// Returns the name of the current tag, such as "h3".
@property (nonatomic, copy, readonly) NSString *tagName;

// Returns tag attributes with name as key and content as value.
//   href  = 'http://peepcode.com'
//   class = 'highlight'
@property (nonatomic, strong, readonly) NSDictionary *attributes;

// Returns the children of a given node
@property (nonatomic, strong, readonly) NSArray *children;

// Returns the first child of a given node
@property (nonatomic, strong, readonly) BKXTFHppleElement *firstChild;

// the parent of a node
@property (nonatomic, unsafe_unretained, readonly) BKXTFHppleElement *parent;

// Returns YES if the node has any child
// This is more efficient than using the children property since no NSArray is constructed
- (BOOL)hasChildren;

// Returns YES if this is a text node
- (BOOL)isTextNode;

// Provides easy access to the content of a specific attribute,
// such as 'href' or 'class'.
- (NSString *) objectForKey:(NSString *) theKey;

// Returns the children whose tag name equals the given string
// (comparison is performed with NSString's isEqualToString)
// Returns an empty array if no matching child is found
- (NSArray *) childrenWithTagName:(NSString *)tagName;

// Returns the first child node whose tag name equals the given string
// (comparison is performed with NSString's isEqualToString)
// Returns nil if no matching child is found
- (BKXTFHppleElement *) firstChildWithTagName:(NSString *)tagName;

// Returns the children whose class equals the given string
// (comparison is performed with NSString's isEqualToString)
// Returns an empty array if no matching child is found
- (NSArray *) childrenWithClassName:(NSString *)className;

// Returns the first child whose class requals the given string
// (comparison is performed with NSString's isEqualToString)
// Returns nil if no matching child is found
- (BKXTFHppleElement *) firstChildWithClassName:(NSString*)className;

// Returns the first text node from this element's children
// Returns nil if there is no text node among the children
- (BKXTFHppleElement *) firstTextChild;

// Returns the string contained by the first text node from this element's children
// Convenience method which can be used instead of firstTextChild.content
- (NSString *) text;

// Returns elements searched with xpath
- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS;

// Custom keyed subscripting
- (id)objectForKeyedSubscript:(id)key;

@end

NS_ASSUME_NONNULL_END
