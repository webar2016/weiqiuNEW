//
//  WBMapViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/25.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBMapViewController.h"

@interface WBMapViewController ()

@end

@implementation WBMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"征服地球";
    UIWebView *mapPage = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, self.view.frame.size.height)];
    [mapPage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://121.40.132.44:92/map/m?userId=636"]]];
    [self.view addSubview:mapPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
