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
<<<<<<< HEAD
=======
#import "WBSystemViewController.h"
>>>>>>> 3a56be99fafa2afbb6fe41e9f2975a5c09f4e6f5

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
    self.conversationListTableView.separatorColor = [UIColor whiteColor];
    self.conversationListTableView.frame = CGRectMake((self.view.frame.size.width * 0.2), 20, (self.view.frame.size.width * 0.8), (self.view.frame.size.height - 20));
<<<<<<< HEAD
    
=======
    [self notifyUpdateUnreadMessageCount];
>>>>>>> 3a56be99fafa2afbb6fe41e9f2975a5c09f4e6f5
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];
    
}

<<<<<<< HEAD
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

=======
>>>>>>> 3a56be99fafa2afbb6fe41e9f2975a5c09f4e6f5
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

<<<<<<< HEAD
=======
-(void)notifyUpdateUnreadMessageCount{
    NSNumber *unRead = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTip" object:self userInfo:@{@"unRead":[NSString stringWithFormat:@"%@",unRead]}];
}

>>>>>>> 3a56be99fafa2afbb6fe41e9f2975a5c09f4e6f5
- (void)didTapCellPortrait:(RCConversationModel *)model{
    
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
<<<<<<< HEAD
    WBPrivateViewController *talkView = [[WBPrivateViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
=======
    if (![model.targetId isEqualToString:@"weiqiu"] && ![model.targetId isEqualToString:@"unlock_notice"]) {
        WBPrivateViewController *talkView = [[WBPrivateViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
        talkView.hidesBottomBarWhenPushed = YES;
        talkView.title = model.conversationTitle;
        [self pushViewControllerWithController:talkView];
        return;
    }
    WBSystemViewController *talkView = [[WBSystemViewController alloc] initWithConversationType:ConversationType_PRIVATE targetId:model.targetId];
>>>>>>> 3a56be99fafa2afbb6fe41e9f2975a5c09f4e6f5
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

@end
