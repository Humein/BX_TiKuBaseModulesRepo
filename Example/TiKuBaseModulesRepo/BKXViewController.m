//
//  BKXViewController.m
//  TiKuBaseModulesRepo
//
//  Created by Zhang Xin Xin on 09/30/2019.
//  Copyright (c) 2019 Zhang Xin Xin. All rights reserved.
//

#import "BKXViewController.h"
@import TiKuBaseModulesRepo;
#import "TiKuBaseModulesRepo_Example-Swift.h"

@interface BKXViewController ()
@property (nonatomic, strong) BKXCoreDisplayView *textView;
@end

@implementation BKXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView.backgroundColor = [UIColor yellowColor];
    BKXCTFrameParserConfig *topicConfig = [[BKXCTFrameParserConfig alloc] init];
    topicConfig.width = 300;
    topicConfig.fontSize = 16;
    topicConfig.fontStyle = @"PingFangSC-Medium";
    topicConfig.textColor = [UIColor blackColor];
    NSArray *arr = [BKXParserHandleString getHandeString:@"<img src= https://sfs-public.shangdejigou.cn/teach-resource/question_content/picture/3336eca3910d1a5026d4118395c5aae1/image.png" withConfig:topicConfig];
    BKXCoreTextData *data = [BKXCTFrameParser parseTempArr:arr config:topicConfig];
    data.height = 100;
    
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
