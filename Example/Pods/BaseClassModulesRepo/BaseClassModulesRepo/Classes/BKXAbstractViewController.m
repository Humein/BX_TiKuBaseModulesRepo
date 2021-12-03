//
//  BKXAbstractViewController.m
//  BaseClassModulesRepo_Example
//
//  Created by Zhang Xin Xin on 2019/10/8.
//  Copyright © 2019 Zhang Xin Xin. All rights reserved.
//
#define HexColor(value,a)   [UIColor colorWithRed:((value & 0xFF0000) >> 16)/255.0 green:((value & 0x00FF00) >> 8)/255.0 blue:(value & 0x0000FF)/255.0 alpha:(a)]

#import "BKXAbstractViewController.h"

@interface BKXAbstractViewController ()
@property (nonatomic,strong) BKXPlaceHolderView *placeHolderView;

@end

@implementation BKXAbstractViewController


-(void)dealloc{
    
    NSLog(@"***************** 销毁-->:%@",[self class]);
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    if (self.navigationController.viewControllers.count >1) {
//        self.leftBarItem(@"global-back-arrow-image",CGRectMake(0, 0, 40, 40),YES);
//    }
    
//    typeof(self) __weak weakSelf = self;
//    self.leftBarItemClickBlock = ^(UIButton *button, NSInteger index) {
//        if (index==0) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
//        }
//    };
}

#pragma mark- 设置导航栏

- (UIButton*)buttonItemForIndex:(NSInteger)index isLeft:(BOOL)isLeft
{
    if (isLeft) {
        
        NSArray *array = self.navigationItem.leftBarButtonItems;
        UIBarButtonItem *barButtonItem = [array objectAtIndex:index];
        return barButtonItem.customView;
    }else{
        NSArray *array = self.navigationItem.rightBarButtonItems;
        NSInteger count = array.count;
        UIBarButtonItem *barButtonItem = [array objectAtIndex:count-1-index];
        return barButtonItem.customView;
    }
}

//- (BKXAbstractViewController * (^) (NSString * leftName,CGRect frame,BOOL isImage))leftBarItem
//{}
//
//- (BKXAbstractViewController * (^) (NSString * rightName,UIColor *titleColor,CGRect frame,BOOL isImage))rightBarItem
//{}
//
//- (BKXAbstractViewController * (^) (NSString * centerName))centerBarItem
//{}

- (UIView *)setCenterBarItem:(NSString *)centerName{{
    
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:18];
    label.textColor = HexColor(0x000000, 1);
    label.text = centerName;
    [label sizeToFit];
    
    return label;
}}


//-(NSArray<UIBarButtonItem *> *)setRightBarItemWith:(NSString *)rightName t:(UIColor *) titleColor f:(CGRect )frame{}


- (void)setLeftBarItemClickBlock:(void (^)(UIButton *, NSInteger))leftBarItemClickBlock
{
    leftBarItemClickBlock ? _leftBarItemClickBlock= [leftBarItemClickBlock copy] :nil;
}

- (void)setRightBarItemClickBlock:(void (^)(UIButton *, NSInteger))rightBarItemClickBlock
{
    rightBarItemClickBlock ? _rightBarItemClickBlock = [rightBarItemClickBlock copy] :nil;
}



- (void)leftButtonClick:(UIButton*)leftButton
{
    int index= 0;
    for (UIBarButtonItem *buttonItem in self.navigationItem.leftBarButtonItems) {
        
        if (buttonItem.customView == leftButton) {
            break;
        }
        index++;
    }
    self.leftBarItemClickBlock ? self.leftBarItemClickBlock (leftButton,index) : nil;
}

- (void)rightButtonClick:(UIButton*)rightButton
{
    int index= 0;
    
    for (UIBarButtonItem *buttonItem in self.navigationItem.rightBarButtonItems) {
        
        if (buttonItem.customView == rightButton) {
            break;
        }
        index++;
    }
    self.rightBarItemClickBlock ? self.rightBarItemClickBlock (rightButton,index) : nil;
}

// 网络问题
- (void)errorNetWork:(void (^)(void))retryBlock
{

    
    
    [self.view addSubview:self.placeHolderView];
    
    [self.placeHolderView loadDataFromDelegate];
    
    self.placeHolderView.retryBlock = ^(PlaceType type) {
        retryBlock();
    };
}

- (void)recoverNormal
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[BKXPlaceHolderView class]]) {
            [view removeFromSuperview];
        }
    }
}

-(void)backToController:(NSString *)controllerName animated:(BOOL)animaed{
    
    if (self.navigationController) {
        
        NSArray *controllers = self.navigationController.viewControllers;
        
        NSArray *result = [controllers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            
            return [evaluatedObject isKindOfClass:NSClassFromString(controllerName)];
            
        }]];
        
        if (result.count > 0) {
            
            [self.navigationController popToViewController:result[0] animated:YES];
            
        }
        
    }
    
}

#pragma mark - placeHolderViewdel

- (UIImage*)placeholderDataErrorImage
{
    return [UIImage imageNamed:@"default_empty"];
}

- (NSAttributedString*)placeholderDataErrorDescript
{
    NSString *tmpString =@"网络发生错误，点击重试";
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:tmpString];
    
    return string;
}


- (CGRect)placeHolderFrame
{
    return CGRectMake(0, 0,  ([UIScreen mainScreen].bounds.size.width), ([UIScreen mainScreen].bounds.size.height));
}


- (BKXPlaceHolderView *)placeHolderView{
    if (!_placeHolderView) {
        _placeHolderView = [[BKXPlaceHolderView alloc] initWithFrame:[self placeHolderFrame]];
        _placeHolderView.type = DataErrorType;
        _placeHolderView.delegate= self;
    }

    return _placeHolderView;
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
