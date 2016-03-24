//
//  WBNavigationController.m
//  微球
//
//  Created by 徐亮 on 16/3/3.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBNavigationController.h"

#import "UIColor+color.h"

@interface WBNavigationController ()

@end

@implementation WBNavigationController

+(void)initialize{
    UINavigationBar *bar = [UINavigationBar appearance];
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    bar.tintColor = [UIColor initWithGreen];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor initWithGreen];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    bar.titleTextAttributes = attr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
