//
//  BKXPlaceHolderView.h
//  BaseClassModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

enum{
    NoNetWorkType, //无网络
    NodataType,    //无数据,这个变化比较多，对于其他两个，可以采用同样的处理方式
    DataErrorType   //数据错误
};
typedef NSInteger PlaceType;

typedef void (^PlaceHolderRetryBlock)(PlaceType type);

@protocol PlaceHolderViewDelegate <NSObject>

@optional

//无网络占位
- (UIImage*)placeholderNoNetworkImage;
- (NSAttributedString*)placeholderNoNetworkDescript;

//数据错误占位
- (UIImage*)placeholderDataErrorImage;
- (NSAttributedString*)placeholderDataErrorDescript;

//无数据
- (UIImage*)placeHolderNoDataImage;
- (NSAttributedString*)placeHolderNoDataDescript;

//placeView的frame
- (CGRect)placeHolderFrame;

@end

@interface BKXPlaceHolderView : UIView

@property (nonatomic,copy)PlaceHolderRetryBlock retryBlock;

@property (nonatomic,assign)PlaceType type;

@property (nonatomic,weak)id<PlaceHolderViewDelegate>delegate;

@property (nonatomic,strong)UIImage *placeImage;

@property (nonatomic,strong)UILabel *descriptLabel;

@property (nonatomic,copy)NSString *placeString;

- (void)loadDataFromDelegate;

@end

NS_ASSUME_NONNULL_END
