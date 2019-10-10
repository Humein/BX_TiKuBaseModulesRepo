//
//  BKXBaseExerciseViewController.h
//  TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import "BKXAbstractViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BKXBaseExerciseViewController : BKXAbstractViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)NSMutableArray *dataArray;

- (void)updateTimer:(NSTimer *)timer;

- (void)startTimer;

- (void)pauseTimer;

- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
