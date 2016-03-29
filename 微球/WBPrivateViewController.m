//
//  WBPrivateViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/21.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPrivateViewController.h"
#import "WBHomepageViewController.h"

@interface WBPrivateViewController ()

@end

@implementation WBPrivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNumber *unRead = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTip" object:self userInfo:@{@"unRead":[NSString stringWithFormat:@"%@",unRead]}];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell
                   atIndexPath:(NSIndexPath *)indexPath{
    if ([cell isKindOfClass:[RCTextMessageCell class]]) {
        if (cell.messageDirection == 1) {
            ((RCTextMessageCell *)cell).textLabel.textColor = [UIColor whiteColor];
        }else{
            ((RCTextMessageCell *)cell).textLabel.textColor = [UIColor initWithNormalGray];
        }
    }
}

- (void)didTapCellPortrait:(NSString *)userId{
    WBHomepageViewController *friendPage = [[WBHomepageViewController alloc] init];
    friendPage.friendId = userId;
    [self.navigationController pushViewController:friendPage animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
