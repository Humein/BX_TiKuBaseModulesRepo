//
//  BKXViewController.m
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 09/30/2019.
//  Copyright (c) 2019 Zhang Xin Xin. All rights reserved.
//

#import "BKXViewController.h"
#import "BKXTiKuHeader.h"

@interface BKXViewController ()
@property (nonatomic, strong) BKXCoreDisplayView *textView;
@end

@implementation BKXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    BKXCTFrameParserConfig *topicConfig = [[BKXCTFrameParserConfig alloc] init];
    topicConfig.width = 300;
    topicConfig.fontSize = 16;
    topicConfig.fontStyle = @"PingFangSC-Medium";
    topicConfig.textColor = [UIColor blackColor];
    NSArray *arr = [BKXParserHandleString getHandeString:@"以做好前期<准备(+1.0分)>，真准确定位，认清自我，加强<调查(+2.0分)>研究，了解<市场需求(+11.0分)>" withConfig:topicConfig];
    BKXCoreTextData *data = [BKXCTFrameParser parseTempArr:arr config:topicConfig];
    self.textView = [[BKXCoreDisplayView alloc] initWithFrame:CGRectMake(10,300, 300, data.height)];
    self.textView.data = data;
    [self.view addSubview:self.textView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
