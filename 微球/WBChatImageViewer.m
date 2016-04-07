//
//  WBChatImageViewer.m
//  微球
//
//  Created by 徐亮 on 16/4/7.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBChatImageViewer.h"

@interface WBChatImageViewer ()

@end

@implementation WBChatImageViewer

-(instancetype)initWithChatModel:(RCMessageModel *)model{
    if (self = [super init]) {
        self.messageModel = model;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
        [self.view addGestureRecognizer:tap];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)dismissView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
