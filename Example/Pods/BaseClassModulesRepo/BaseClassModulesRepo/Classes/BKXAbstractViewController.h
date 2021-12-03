//
//  BKXAbstractViewController.h
//  BaseClassModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKXPlaceHolderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKXAbstractViewController : UIViewController<PlaceHolderViewDelegate>

//左边按钮，点击回调
@property (nonatomic,copy) void (^leftBarItemClickBlock)(UIButton *button, NSInteger index);

//右边按钮，点击回调
@property (nonatomic,copy) void (^rightBarItemClickBlock)(UIButton *button, NSInteger index);


//从左到右排
- (BKXAbstractViewController * (^) (NSString * leftName,CGRect frame,BOOL isImage))leftBarItem;

//从左到右排列
- (BKXAbstractViewController * (^) (NSString * rightName,UIColor *titleColor,CGRect frame,BOOL isImage))rightBarItem;

-(NSArray<UIBarButtonItem *> *)setRightBarItemWith:(NSString *)rightName t:(UIColor *) titleColor f:(CGRect )frame;

/** 中间的标题 */
- (BKXAbstractViewController * (^) (NSString * centerName))centerBarItem;

- (UIView *)setCenterBarItem:(NSString *)centerName;

//根据下标去获取导航栏上面的按钮
- (UIButton*)buttonItemForIndex:(NSInteger)index isLeft:(BOOL)isLeft;


/**
 指定页面

 @param controllerName <#controllerName description#>
 @param animaed <#animaed description#>
 */
-(void)backToController:(NSString *)controllerName animated:(BOOL)animaed;

// 网络问题
- (void)errorNetWork:(void (^)(void))retryBlock;

- (void)recoverNormal;//数据恢复正常

@end

NS_ASSUME_NONNULL_END
