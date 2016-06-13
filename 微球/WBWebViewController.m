//
//  WBWebViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/30.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBWebViewController.h"
#import "WBMyUnlockViewController.h"
#import "WBUnlockSceneryViewController.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.mapView) {
        UIBarButtonItem *unlockDetail = [[UIBarButtonItem alloc] initWithTitle:@"城市" style:UIBarButtonItemStylePlain target:self action:@selector(unlockDetails)];
        UIBarButtonItem *unlockSceneryDetail = [[UIBarButtonItem alloc] initWithTitle:@"景点" style:UIBarButtonItemStylePlain target:self action:@selector(unlockSceneryDetails)];
        
      //  self.navigationItem.rightBarButtonItem = unlockDetail;
        self.navigationItem.rightBarButtonItems = @[unlockSceneryDetail,unlockDetail];
    }
}

- (void)unlockDetails {
    WBMyUnlockViewController *MVC = [[WBMyUnlockViewController alloc]init];
    [self.navigationController pushViewController:MVC animated:YES];
}

-(void)unlockSceneryDetails{
    WBUnlockSceneryViewController *VC = [[WBUnlockSceneryViewController alloc]init];
    [self.navigationController pushViewController:VC animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
