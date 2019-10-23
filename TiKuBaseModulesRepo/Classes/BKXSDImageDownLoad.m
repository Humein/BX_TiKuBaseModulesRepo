//
//  BKXSDImageDownLoad.m
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 2019/10/8.
//

#import "BKXSDImageDownLoad.h"
#import "SDWebImage.h"
@implementation BKXSDImageDownLoad
/*
 *  批量下载图片资源
 *  imageURLs 图片地址数组 成员为String类型
 */
+ (void)downloadImagesWithURLs:(NSArray <NSString *> *)imageURLs completed:(ImagePrefetcherCompletionBlock)completionBlock{
    NSMutableArray *prefetchURLs = [NSMutableArray new];
    
    for (NSString *urlStr in imageURLs) {
        NSURL *url = [NSURL URLWithString:urlStr];
        if (url) {
            [prefetchURLs addObject:url];
        }
    }
    
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:prefetchURLs progress:nil completed:^(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls) {
        completionBlock(noOfFinishedUrls,noOfSkippedUrls);
    }];
}

/*
 *  根据图片地址获取图片
 *  imageURL 单个图片地址
 */
+ (UIImage *)imageForURL:(NSString *)imageURL {
    NSURL *url = [NSURL URLWithString:imageURL];
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
    return image;
}
@end
