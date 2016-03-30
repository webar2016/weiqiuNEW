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
    UIWebView *guessPage = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [guessPage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.40.132.44:92/main/guess?userId=%@",[WBUserDefaults userId]]]]];
    [self.view addSubview:guessPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
