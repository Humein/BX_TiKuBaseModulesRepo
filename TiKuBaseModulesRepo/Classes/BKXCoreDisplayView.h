//
//  BKXCoreDisplayView.h
//  Pods-TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//

#import <UIKit/UIKit.h>
#import "BKXCoreTextData.h"

NS_ASSUME_NONNULL_BEGIN
extern NSString *const CTDisplayViewImagePressedNotification;
extern NSString *const CTDisplayViewLinkPressedNotification;

@interface BKXCoreDisplayView : UIView

@property (nonatomic, strong) BKXCoreTextData * data;

@end

NS_ASSUME_NONNULL_END
