//
//  WBRightViewController.m
//  微球
//
//  Created by 贾玉斌 on 16/2/27.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBRightViewController.h"
#import "WBFindViewController.h"
#import "WBLeftViewController.h"
#import "WBPrivateViewController.h"
#import "WBSystemViewController.h"

#import "RCIMClient.h"
#import "WBUnlockMessage.h"
#import "MyDBmanager.h"
#import "WBTbl_Unlock_City.h"
#import "WBTbl_Unlocking_City.h"
#import "UIColor+color.h"

#define NAVIGATION_CONTROLLERS self.parentViewController.childViewControllers.lastObject.childViewControllers
#define IS_FIND_PAGE self.sideMenuViewController.isFindPage

@interface WBRightViewController ()


@end

@implementation WBRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor initWithBackgroundGray];
    self.conversationListTableView.backgroundColor = [UIColor initWithBackgroundGray];
    self.emptyConversationView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noconversation"]];
    self.emptyConversationView.center = CGPointMake(SCREENWIDTH / 2, 170);
    self.conversationListTableView.separatorColor = [UIColor whiteColor];
    self.conversationListTableView.frame = CGRectMake((self.view.frame.size.width * 0.2), 20, (self.view.frame.size.width * 0.8), (self.view.frame.size.height - 20));
    [self notifyUpdateUnreadMessageCount];
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)notifyUpdateUnreadMessageCount{
    NSNumber *unRead = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTip" object:self userInfo:@{@"unRead":[NSString stringWithFormat:@"%@",unRead]}];
//    [self checkUnlockCity];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.sideMenuViewController hideMenuViewController];
    [self onSelectedTableRow:RC_CONVERSATION_MODEL_TYPE_NORMAL
           conversationModel:self.conversationListDataSource[indexPath.row]
                 atIndexPath:indexPath];
}

- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    if (![model.targetId isEqualToString:@"weiqiu"] && ![model.targetId isEqualToString:@"unlock_notice"]) {
        WBPrivateViewController *talkView = [[WBPrivateViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
        talkView.hidesBottomBarWhenPushed = YES;
        talkView.title = model.conversationTitle;
        [self pushViewControllerWithController:talkView];
        return;
    }
    WBSystemViewController *talkView = [[WBSystemViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
    talkView.hidesBottomBarWhenPushed = YES;
    talkView.title = model.conversationTitle;
    [self pushViewControllerWithController:talkView];
}

- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath{
    ((RCConversationCell *)cell).contentView.backgroundColor = [UIColor initWithBackgroundGray];
    ((RCConversationCell *)cell).conversationTitle.textColor = [UIColor initWithLightGray];
    ((RCConversationCell *)cell).conversationTitle.font = MAINFONTSIZE;
    ((RCConversationCell *)cell).messageContentLabel.font = FONTSIZE12;
    ((RCConversationCell *)cell).messageCreatedTimeLabel.font = FONTSIZE12;
}

-(void)pushViewControllerWithController:(UIViewController *)vc{
    if (IS_FIND_PAGE == YES) {
        [NAVIGATION_CONTROLLERS.firstObject pushViewController:vc animated:YES];
    }else{
        [NAVIGATION_CONTROLLERS.lastObject pushViewController:vc animated:YES];
    }
}

- (void)didDeleteConversationCell:(RCConversationModel *)model{
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:model.targetId];
    [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:model.targetId];
}

-(void)checkUnlockCity{
    for (RCConversationModel *model in self.conversationListDataSource) {
        if ([model.targetId isEqualToString: @"unlock_notice"]) {
            WBUnlockMessage *unlockMsg = (WBUnlockMessage *)model.lastestMessage;
            if ([unlockMsg.isUnlock isEqual:@"YES"]) {
                //保存到已经解锁
                
                WBTbl_Unlock_City *unlockingCity = [[WBTbl_Unlock_City alloc]init];
                unlockingCity.userId = [[WBUserDefaults userId]integerValue];
                unlockingCity.cityId = [unlockMsg.cityId integerValue];
                
                
                MyDBmanager *manager = [[MyDBmanager alloc]initWithStyle:Tbl_unlock_city];
                if (![manager isAddedItemsID:unlockMsg.cityId]) {
                    [manager addItem:unlockingCity];
                    [manager closeFBDM];
                }else{
                    [manager closeFBDM];
                }
                //解锁成功
            }else{
                //解锁失败
            }
            
            //删掉正在解锁的信息
            MyDBmanager *manager2 = [[MyDBmanager alloc]initWithStyle:Tbl_unlocking_city];
            [manager2 deletedataWithKey:@"cityId" andValue:unlockMsg.cityId];
            [manager2 closeFBDM];
        }
    }
}

@end
