//
//  BKXCoreTextLinkData.m
//  TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/9/30.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import "BKXCoreTextLinkData.h"
#import <objc/runtime.h>

@implementation BKXCoreTextLinkData
- (id)copyWithZone:(nullable NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    BKXCoreTextLinkData *abstractItem = [[[self class] allocWithZone:zone] init];
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
@end
