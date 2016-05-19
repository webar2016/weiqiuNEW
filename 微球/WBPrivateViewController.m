//
//  WBPrivateViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/21.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBPrivateViewController.h"
#import "WBHomepageViewController.h"
#import "WBChatImageViewer.h"

@interface WBPrivateViewController ()

@end

@implementation WBPrivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNumber *unRead = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]];
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTip" object:self userInfo:@{@"unRead":[NSString stringWithFormat:@"%@",unRead]}];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.backBarButtonItem = back;
    self.enableSaveNewPhotoToLocalSystem = YES;
}

-(void)popBack{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    if (self.fromHomePage && ![userId isEqualToString:[NSString stringWithFormat:@"%@",[WBUserDefaults userId]]]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    WBHomepageViewController *friendPage = [[WBHomepageViewController alloc] init];
    friendPage.userId = userId;
    [self.navigationController pushViewController:friendPage animated:YES];
}

-(void)didTapMessageCell:(RCMessageModel *)model{
    if ([model.content isKindOfClass:[RCImageMessage class]]) {
        WBChatImageViewer *imageViewer = [[WBChatImageViewer alloc] initWithChatModel:model];
        [self presentViewController:imageViewer animated:YES completion:nil];
    } else if ([model.content isKindOfClass:[RCLocationMessage class]]) {
        [self presentLocationViewController:(RCLocationMessage *)model.content];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
