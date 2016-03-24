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
    NSNumber *unRead = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]];
    NSNumber *unReadGroup = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_GROUP)]]];
    NSMutableDictionary *unReadDic = [NSMutableDictionary dictionary];
    unReadDic[@"unRead"] = [NSString stringWithFormat:@"%@",unRead];
    unReadDic[@"unReadGroup"] = [NSString stringWithFormat:@"%@",unReadGroup];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTip" object:self userInfo:unReadDic];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
