//
//  BKXSDImageDownLoad.h
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/10/8.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^ImagePrefetcherCompletionBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls);

@interface BKXSDImageDownLoad : NSObject
/*
 *  批量下载图片资源
 *  imageURLs 图片地址数组 成员为String类型
 */
+ (void)downloadImagesWithURLs:(NSArray <NSString *> *)imageURLs completed:(ImagePrefetcherCompletionBlock)completionBlock;

/*
 *  根据图片地址获取图片
 *  imageURL 单个图片地址
 */
+ (UIImage *)imageForURL:(NSString *)imageURL;
@end

NS_ASSUME_NONNULL_END
