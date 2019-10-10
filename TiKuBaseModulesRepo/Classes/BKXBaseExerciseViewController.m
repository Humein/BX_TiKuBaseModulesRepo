//
//  BKXBaseExerciseViewController.m
//  TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import "BKXBaseExerciseViewController.h"

@interface BKXBaseExerciseViewController ()

@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BKXBaseExerciseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTimer];

}



-(void)configTimer{
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self pauseTimer];
}

// MARK: - timer
// 开始计时
- (void)startTimer {
    if (_timer) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}
// 暂停计时
- (void)pauseTimer {
    if (_timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}
// 停止计时
- (void)stopTimer {
    if (_timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateTimer:(NSTimer *)timer{
    
}


// MARK: - collectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"indentifier" forIndexPath:indexPath];
}



- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
