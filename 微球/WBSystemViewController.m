//
//  WBSystemViewController.m
//  微球
//
//  Created by 徐亮 on 16/3/23.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import "WBSystemViewController.h"
#import "CreateHelpGroupViewController.h"

#import "WBSystemMessage.h"
#import "WBFollowMessage.h"
#import "WBCommentMessage.h"
#import "WBUnlockMessage.h"
#import "WBSystemMsgCell.h"
#import "WBFollowMsgCell.h"
#import "WBCommentMsgCell.h"
#import "WBUnlockMsgCell.h"

#import "MyDownLoadManager.h"
#import "NSString+string.h"

@interface WBSystemViewController () <RCMessageCellDelegate>

@end

@implementation WBSystemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    self.displayUserNameInCell = NO;
    
    //注册自定义消息cell
    [self registerClass:[WBSystemMsgCell class] forCellWithReuseIdentifier:WBSystemMessageIdentifier];
    [self registerClass:[WBFollowMsgCell class] forCellWithReuseIdentifier:WBFollowMessageIdentifier];
    [self registerClass:[WBCommentMsgCell class] forCellWithReuseIdentifier:WBCommentMessageIdentifier];
    [self registerClass:[WBUnlockMsgCell class] forCellWithReuseIdentifier:WBUnlockMessageIdentifier];
    
    [self.pluginBoardView.allItems removeObjectAtIndex:2];
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
    
    NSNumber *unRead = [NSNumber numberWithInt: [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"unReadTip" object:self userInfo:@{@"unRead":[NSString stringWithFormat:@"%@",unRead]}];
}

-(void)viewWillAppear:(BOOL)animated{
    //调整页面
    if (![self.targetId isEqualToString:@"weiqiu"]) {
        CGSize size = self.conversationMessageCollectionView.frame.size;
        self.conversationMessageCollectionView.frame = CGRectMake(0, 64, size.width, size.height + 50);
        [self.chatSessionInputBarControl removeFromSuperview];
        [self scrollToBottomAnimated:YES];
    }
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

- (RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"userId"] = [WBUserDefaults userId];
    if ([messageCotent isKindOfClass:[RCTextMessage class]]) {
        dic[@"content"] = ((RCTextMessage *)messageCotent).content;
        [MyDownLoadManager postUrl:@"http://121.40.132.44:92/feedBack/talkToHelper" withParameters:dic whenProgress:^(NSProgress *FieldDataBlock) {
        } andSuccess:^(id representData) {
            NSLog(@"成功");
        } andFailure:^(NSString *error) {
            NSLog(@"失败");
        }];
    } else {
        NSData *fileData = UIImageJPEGRepresentation(((RCImageMessage *)messageCotent).thumbnailImage, 1.0);
        NSString *imageName = [[NSString ret32bitString] stringByAppendingString:@".JPG"];
        [MyDownLoadManager postUserInfoUrl:@"http://121.40.132.44:92/feedBack/talkToHelper" withParameters:dic fieldData:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:fileData name:imageName fileName:imageName mimeType:@"image/jpeg"];
        } whenProgress:^(NSProgress *FieldDataBlock) {
        } andSuccess:^(id representData) {
            NSLog(@"成功");
        } andFailure:^(NSString *error) {
            NSLog(@"失败");
        }];
    }
    return messageCotent;
}

#pragma mark - 自定义消息cell展示

- (RCMessageBaseCell *)rcConversationCollectionView:(UICollectionView *)collectionView
                             cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    
    RCMessageContent *messageContent = model.content;
    
    if ([messageContent isMemberOfClass:[WBUnlockMessage class]]) {
        WBUnlockMsgCell *cell = [collectionView
                                 dequeueReusableCellWithReuseIdentifier:WBUnlockMessageIdentifier
                                 forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    } else if ([messageContent isMemberOfClass:[WBSystemMessage class]]) {
         WBSystemMsgCell *cell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:WBSystemMessageIdentifier
                                    forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    } else if ([messageContent isMemberOfClass:[WBFollowMessage class]]) {
        WBFollowMsgCell *cell = [collectionView
                                 dequeueReusableCellWithReuseIdentifier:WBFollowMessageIdentifier
                                 forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    } else if ([messageContent isMemberOfClass:[WBCommentMessage class]]) {
        WBCommentMsgCell *cell = [collectionView
                                 dequeueReusableCellWithReuseIdentifier:WBCommentMessageIdentifier
                                 forIndexPath:indexPath];
        [cell setDataModel:model];
        [cell setDelegate:self];
        return cell;
    } else {
        return [super rcConversationCollectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
}

#pragma mark - 获取cell尺寸调整UI

- (CGSize)rcConversationCollectionView:(UICollectionView *)collectionView
                                layout:(UICollectionViewLayout *)collectionViewLayout
                sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCMessageModel *model = [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    
    if ([messageContent isMemberOfClass:[WBUnlockMessage class]]) {
        return CGSizeMake(collectionView.frame.size.width, [WBUnlockMsgCell getBubbleBackgroundViewSize:(WBUnlockMessage *)messageContent].height + 40);
    } else if ([messageContent isMemberOfClass:[WBSystemMessage class]]) {
        return CGSizeMake(collectionView.frame.size.width, [WBSystemMsgCell getBubbleBackgroundViewSize].height + 40);
    } else if ([messageContent isMemberOfClass:[WBFollowMessage class]]) {
        return CGSizeMake(collectionView.frame.size.width, [WBFollowMsgCell getBubbleBackgroundViewSize].height + 40);
    } else if ([messageContent isMemberOfClass:[WBCommentMessage class]]) {
        return CGSizeMake(collectionView.frame.size.width, [WBCommentMsgCell getBubbleBackgroundViewSize:(WBCommentMessage *)messageContent].height + 40);
    } else {
        return [super rcConversationCollectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
}

#pragma mark - cell点击后的回调

- (void)didTapMessageCell:(RCMessageModel *)model {
    [super didTapMessageCell:model];
    if ([model.content isKindOfClass:[WBUnlockMessage class]]) {
        WBUnlockMessage *message = (WBUnlockMessage *)model.content;
        if ([message.isUnlock isEqualToString:@"NO"]) {
            CreateHelpGroupViewController *unlockVC = [[CreateHelpGroupViewController alloc] init];
            unlockVC.fromSlidePage = YES;
            unlockVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:unlockVC animated:YES];
        }
    } else if ([model.content isKindOfClass:[WBSystemMessage class]]) {
        WBSystemMessage *message = (WBSystemMessage *)model.content;
        NSLog(@"打开消息");
    } else if ([model.content isKindOfClass:[WBFollowMessage class]]) {
        WBFollowMessage *message = (WBFollowMessage *)model.content;
        NSLog(@"查看订阅");
    } else if ([model.content isKindOfClass:[WBCommentMessage class]]) {
        WBCommentMessage *message = (WBCommentMessage *)model.content;
        NSLog(@"回复评论");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
