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

-(instancetype)init{
    if (self = [super init]) {
        self.navigationItem.title = @"猜图签到";
        UIWebView *guessPage = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [self.view addSubview:guessPage];
        [guessPage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://121.40.132.44:92/main/guess?userId=%@",[WBUserDefaults userId]]]]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
