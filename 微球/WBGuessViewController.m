//
//  WBGuessViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBGuessViewController.h"

@interface WBGuessViewController ()

@end

@implementation WBGuessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"猜图签到";
    UIWebView *guessPage = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height)];
    [guessPage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.1.124/mbapp/main/guess?userId=967"]]];
    [self.view addSubview:guessPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
