//
//  WBJoinTableViewCell.h
//  微球
//
//  Created by 徐亮 on 16/3/9.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface WBGroupTableViewCell : RCConversationBaseCell{
    UIImageView      *_iconsView;
    UILabel          *_groupName;
    UILabel          *_totalNumber;
    UILabel          *_talkTime;
    UILabel          *_talkDetail;
    UIImageView      *_disturbSign;
    UILabel          *_unReadTip;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier isMater:(BOOL)isMaster;

-(void)setDataModel:(RCConversationModel *)model;

@end
