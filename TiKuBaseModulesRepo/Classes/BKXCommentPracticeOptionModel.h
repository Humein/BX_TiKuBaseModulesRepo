//
//  BKXCommentPracticeModel.h
//  TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/9.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^BKXQuestionStateChangeBlock)(void);
@interface BKXCommentPracticeOptionModel : NSObject
@property (nonatomic,strong)BKXQuestionStateChangeBlock stateBlock;

@end

NS_ASSUME_NONNULL_END
