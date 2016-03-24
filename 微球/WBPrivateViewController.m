//
//  WBPrivateViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/21.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPrivateViewController.h"

@interface WBPrivateViewController ()

@end

@implementation WBPrivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    self.displayUserNameInCell = NO;
    if ([self.targetId isEqualToString:@"weiqiu"] || [self.targetId isEqualToString:@"unlock_notice"]) {
        CGSize size = self.conversationMessageCollectionView.frame.size;
        self.conversationMessageCollectionView.frame = CGRectMake(0, 64, size.width, size.height + 50);
        self.chatSessionInputBarControl.hidden = YES;
    }
    [self scrollToBottomAnimated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
