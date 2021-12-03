//
//  BKXPlaceHolderView.m
//  BaseClassModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//

#import "BKXPlaceHolderView.h"
#import "Masonry.h"

#define HexColor(value,a)   [UIColor colorWithRed:((value & 0xFF0000) >> 16)/255.0 green:((value & 0x00FF00) >> 8)/255.0 blue:(value & 0x0000FF)/255.0 alpha:(a)]

@interface BKXPlaceHolderView()

@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation BKXPlaceHolderView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupContentView];
    }
    return self;
}


- (void)setupContentView
{
    self.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGs = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGs:)];
    [self addGestureRecognizer:tapGs];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageView];
    
    self.imageView = imageView;
    
    UILabel *lable = [UILabel new];
    lable.font = [UIFont systemFontOfSize:14];
    lable.textColor = HexColor(0x9B9B9B, 1);
    lable.numberOfLines = 0;
    lable.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lable];
    
    self.descriptLabel = lable;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY).with.offset(-50);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(320*0.5);
        make.height.mas_equalTo(360*0.5);
    }];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).with.offset(-20);
        make.centerX.equalTo(self.mas_centerX);
        make.height.mas_equalTo(@60);
    }];
}


- (void)loadDataFromDelegate
{
    if (self.type==NoNetWorkType) {//无网络
        
        self.placeImage = [self.delegate placeholderNoNetworkImage];
        self.descriptLabel.attributedText = [self.delegate placeholderNoNetworkDescript];
        
    }else if (self.type == DataErrorType){//数据错误
        
        self.placeImage = [self.delegate placeholderDataErrorImage];
        self.descriptLabel.attributedText = [self.delegate placeholderDataErrorDescript];
        
    }else if (self.type==NodataType){
        
        self.placeImage = [self.delegate placeHolderNoDataImage];
        self.descriptLabel.attributedText = [self.delegate placeHolderNoDataDescript];
    }
    
    self.frame= [self.delegate placeHolderFrame];
}


- (void)setPlaceImage:(UIImage *)placeImage
{
    [self.imageView setImage:placeImage];
}

- (void)setPlaceString:(NSString *)placeString
{
    [self.descriptLabel setText:placeString];
}

- (void)setRetryBlock:(PlaceHolderRetryBlock)retryBlock
{
    retryBlock ? _retryBlock = [retryBlock copy] : nil;
}

- (void)tapGs:(UITapGestureRecognizer*)tap
{
    _retryBlock ? _retryBlock(self.type) : nil;
}


@end
