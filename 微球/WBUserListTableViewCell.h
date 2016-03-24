//
//  WBUserListTableViewCell.h
//  微球
//
//  Created by 徐亮 on 16/3/19.
//  Copyright © 2016年 weiqiuwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBUserInfosModel.h"

@interface WBUserListTableViewCell : UITableViewCell

@property (nonatomic, retain) WBUserInfosModel *model;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
