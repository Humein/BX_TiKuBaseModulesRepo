//
//  BKXTFHppleElement.m
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import "BKXTFHppleElement.h"
#import "BKXXPathQuery.h"

static NSString * const TFHppleNodeContentKey           = @"nodeContent";
static NSString * const TFHppleNodeNameKey              = @"nodeName";
static NSString * const TFHppleNodeChildrenKey          = @"nodeChildArray";
static NSString * const TFHppleNodeAttributeArrayKey    = @"nodeAttributeArray";
static NSString * const TFHppleNodeAttributeNameKey     = @"attributeName";

static NSString * const TFHppleTextNodeName            = @"text";

@interface BKXTFHppleElement ()
{
    NSDictionary * node;
    BOOL isXML;
    NSString *encoding;
    __unsafe_unretained BKXTFHppleElement *parent;
}

@property (nonatomic, unsafe_unretained, readwrite) BKXTFHppleElement *parent;

@end

@implementation BKXTFHppleElement
@synthesize parent;


- (id) initWithNode:(NSDictionary *) theNode isXML:(BOOL)isDataXML withEncoding:(NSString *)theEncoding
{
  if (!(self = [super init]))
    return nil;

    isXML = isDataXML;
    node = theNode;
    encoding = theEncoding;

  return self;
}

+ (BKXTFHppleElement *) hppleElementWithNode:(NSDictionary *) theNode isXML:(BOOL)isDataXML withEncoding:(NSString *)theEncoding
{
  return [[[self class] alloc] initWithNode:theNode isXML:isDataXML withEncoding:theEncoding];
}

#pragma mark -

- (NSString *)raw
{
    return [node objectForKey:@"raw"];
}

- (NSString *)br
{
    return [node objectForKey:@"br"];
}

- (NSString *) content
{
  return [node objectForKey:TFHppleNodeContentKey];
}


- (NSString *) tagName
{
  return [node objectForKey:TFHppleNodeNameKey];
}

- (NSArray *) children
{
  NSMutableArray *children = [NSMutableArray array];
  for (NSDictionary *child in [node objectForKey:TFHppleNodeChildrenKey]) {
      BKXTFHppleElement *element = [BKXTFHppleElement hppleElementWithNode:child isXML:isXML withEncoding:encoding];
      element.parent = self;
      [children addObject:element];
  }
  return children;
}

- (BKXTFHppleElement *) firstChild
{
  NSArray * children = self.children;
  if (children.count)
    return [children objectAtIndex:0];
  return nil;
}


- (NSDictionary *) attributes
{
  NSMutableDictionary * translatedAttributes = [NSMutableDictionary dictionary];
  for (NSDictionary * attributeDict in [node objectForKey:TFHppleNodeAttributeArrayKey]) {
      if ([attributeDict objectForKey:TFHppleNodeContentKey] && [attributeDict objectForKey:TFHppleNodeAttributeNameKey]) {
          [translatedAttributes setObject:[attributeDict objectForKey:TFHppleNodeContentKey]
                                   forKey:[attributeDict objectForKey:TFHppleNodeAttributeNameKey]];
      }
  }
  return translatedAttributes;
}

- (NSString *) objectForKey:(NSString *) theKey
{
  return [[self attributes] objectForKey:theKey];
}

- (id) description
{
  return [node description];
}

- (BOOL)hasChildren
{
    if ([node objectForKey:TFHppleNodeChildrenKey])
        return YES;
    else
        return NO;
}

- (BOOL)isTextNode
{
    // we must distinguish between real text nodes and standard nodes with tha name "text" (<text>)
    // real text nodes must have content
    if ([self.tagName isEqualToString:TFHppleTextNodeName] && (self.content))
        return YES;
    else
        return NO;
}

- (NSArray*) childrenWithTagName:(NSString*)tagName
{
    NSMutableArray* matches = [NSMutableArray array];
    
    for (BKXTFHppleElement* child in self.children)
    {
        if ([child.tagName isEqualToString:tagName])
            [matches addObject:child];
    }
    
    return matches;
}

- (BKXTFHppleElement *) firstChildWithTagName:(NSString*)tagName
{
    for (BKXTFHppleElement* child in self.children)
    {
        if ([child.tagName isEqualToString:tagName])
            return child;
    }
    
    return nil;
}

- (NSArray*) childrenWithClassName:(NSString*)className
{
    NSMutableArray* matches = [NSMutableArray array];
    
    for (BKXTFHppleElement* child in self.children)
    {
        if ([[child objectForKey:@"class"] isEqualToString:className])
            [matches addObject:child];
    }
    
    return matches;
}

- (BKXTFHppleElement *) firstChildWithClassName:(NSString*)className
{
    for (BKXTFHppleElement* child in self.children)
    {
        if ([[child objectForKey:@"class"] isEqualToString:className])
            return child;
    }
    
    return nil;
}

- (BKXTFHppleElement *) firstTextChild
{
    for (BKXTFHppleElement* child in self.children)
    {
        if ([child isTextNode])
            return child;
    }
    
    return [self firstChildWithTagName:TFHppleTextNodeName];
}

- (NSString *) text
{
    return self.firstTextChild.content;
}

// Returns all elements at xPath.
- (NSArray *) searchWithXPathQuery:(NSString *)xPathOrCSS
{
    
    NSData *data = [self.raw dataUsingEncoding:NSUTF8StringEncoding];

    NSArray * detailNodes = nil;
    if (isXML) {
        detailNodes = PerformXMLXPathQueryWithEncoding(data, xPathOrCSS, encoding);
    } else {
        detailNodes = PerformHTMLXPathQueryWithEncoding(data, xPathOrCSS, encoding);
    }
    
    NSMutableArray * hppleElements = [NSMutableArray array];
    for (id newNode in detailNodes) {
        [hppleElements addObject:[BKXTFHppleElement hppleElementWithNode:newNode isXML:isXML withEncoding:encoding]];
    }
    return hppleElements;
}

// Custom keyed subscripting
- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}
@end
