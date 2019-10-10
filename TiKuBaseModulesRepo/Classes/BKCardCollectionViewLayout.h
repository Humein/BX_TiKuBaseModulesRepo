//
//  BKCardCollectionViewLayout.h
//  Pods-TiKuBaseModulesRepo_Tests
//
//  Created by Zhang Xin Xin on 2019/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class CardCollectionViewLayout;

@protocol  filterLayoutDeleaget <NSObject>

@required
/**
 * 每个item的高度
 */
- (CGFloat)waterFallLayout:(CardCollectionViewLayout *)waterFallLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/**
 * 有多少列
 */
- (NSUInteger)columnCountInWaterFallLayout:(CardCollectionViewLayout *)waterFallLayout;

/**
 * 每列之间的间距
 */
- (CGFloat)columnMarginInWaterFallLayout:(CardCollectionViewLayout *)waterFallLayout;

/**
 * 每行之间的间距
 */
- (CGFloat)rowMarginInWaterFallLayout:(CardCollectionViewLayout *)waterFallLayout;

/**
 * 每个item的内边距
 */
- (UIEdgeInsets)edgeInsetdInWaterFallLayout:(CardCollectionViewLayout *)waterFallLayout;


@end

@interface CardCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<filterLayoutDeleaget> delegate;

@end

NS_ASSUME_NONNULL_END
