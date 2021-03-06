//
//  WBGroupSettingTableViewCell.h
//  微球
//
//  Created by 徐亮 on 16/3/10.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBUserInfosModel.h"
#import "WBCollectionViewModel.h"

@class WBGroupSettingTableViewCell;
@protocol WBGroupSettingTableViewCellDelegate <NSObject>

@required

//- (void)QAPush:(WBGroupSettingTableViewCell *)cell isOn:(BOOL) isOn;
- (void)messagePush:(WBGroupSettingTableViewCell *)cell isOn:(BOOL) isOn;
- (void)quitGroup:(WBGroupSettingTableViewCell *)cell;
- (void)closeGroup:(WBGroupSettingTableViewCell *)cell;

@end

@interface WBGroupSettingTableViewCell : UITableViewCell

@property (nonatomic, weak) id <WBGroupSettingTableViewCellDelegate> delegate;

@property (nonatomic, assign) BOOL isMaster;

@property (nonatomic, retain) WBUserInfosModel *userInfos;

@property (nonatomic, retain) WBCollectionViewModel *detail;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSection:(NSUInteger)section isMaster:(BOOL)isMaster withGroupDetail:(WBCollectionViewModel *)detail messageIsPush:(BOOL)isPush;

@end
