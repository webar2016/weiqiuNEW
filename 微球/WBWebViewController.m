//
//  WBWebViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/30.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBWebViewController.h"

@interface WBWebViewController ()

@end

@implementation WBWebViewController

-(instancetype)initWithUrl:(NSURL *)url andTitle:(NSString *)title{
    if (self = [super init]) {
        self.navigationItem.title = title;
        UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 64)];
        web.scrollView.bounces = NO;
        [self.view addSubview:web];
        [web loadRequest:[NSURLRequest requestWithURL:url]];
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
