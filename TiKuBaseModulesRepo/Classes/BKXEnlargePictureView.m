//
//  BKXEnlargePictureView.m
//  Pods-TiKuBaseModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//

#import "BKXEnlargePictureView.h"

@interface BKXEnlargePictureView() <UIScrollViewDelegate>

@property (nonatomic,retain)UIScrollView * backScroll;
@property (nonnull, strong) UIImageView* imageView;

@end

@implementation BKXEnlargePictureView

-(instancetype)initWithImageView:(UIImage*)image{
    if (self=[super init]) {
        [self shareInstanceWithImage:image];
        
    }
    return self;
}

-(void)shareInstanceWithImage:(UIImage *)image{
    
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    self.frame=window.bounds;
    self.backgroundColor=[UIColor lightGrayColor];
    
    self.imageView=[[UIImageView alloc]initWithFrame:self.bounds];
    self.imageView.backgroundColor=[UIColor clearColor];
    self.imageView.userInteractionEnabled=YES;
    self.imageView.image=image;
    self.imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.imageView addGestureRecognizer:tap];
    
    _backScroll =[[UIScrollView alloc]initWithFrame:self.bounds];
    _backScroll.backgroundColor=[UIColor clearColor];
    _backScroll.contentSize=self.bounds.size;
    _backScroll.delegate = self;
    _backScroll.maximumZoomScale = 2.0;
    _backScroll.minimumZoomScale = 1;
    [_backScroll addSubview:self.imageView];
    
    [self addSubview:_backScroll];
    [window addSubview:self];
}


-(void)close{
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    for (UIView * view in window.subviews) {
        if ([view isKindOfClass:[self class]]) {
            [view removeFromSuperview];
        }
    }
}

/**
 *  单击手势
 */
-(void)handleTap:(UITapGestureRecognizer*)recognizer{
    
    [self removeFromSuperview];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}

@end
